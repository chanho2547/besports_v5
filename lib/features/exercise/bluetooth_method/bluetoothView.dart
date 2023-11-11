import 'package:audioplayers/audioplayers.dart';
import 'package:besports_v5/IO/mapFileIO.dart';
import 'package:besports_v5/constants/gaps.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:besports_v5/constants/sizes.dart';
import 'package:besports_v5/constants/staticStatus.dart';
import 'package:besports_v5/main.dart';
import 'package:besports_v5/router.dart';
import 'package:besports_v5/utils/dateUtils.dart';
import 'package:besports_v5/utils/ttsUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'bluetoothViewModel.dart'; // BluetoothViewModel 위치로 변경하세요.

class BluetoothScreen extends StatefulWidget {
  final String addr;
  final VoidCallback? onDispose; // 여기에 콜백을 추가

  const BluetoothScreen({required this.addr, this.onDispose, Key? key})
      : super(key: key);

  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen>
    with TickerProviderStateMixin {
  late BluetoothViewModel? _viewModel;

  late Animation<double> _pulseAnimation;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  final FlutterTts flutterTts = FlutterTts();

  final int _count = 0;

  late int _lastNumber;

  String _setMessage = "4 SET 남음"; // 초기 메시지는 빈 문자열

  @override
  void initState() {
    super.initState();

    _lastNumber = -1;
    flutterTts.setLanguage("ko-KR");

    _initTTS();
    _initAnimationController();
    _checkModal();
    _initializeViewModel(); // ViewModel을 초기화합니다.
    _listenForCountChanges();
    _initPulseAnimation();
  }

  //TTS 초기화
  void _initTTS() async {
    print("TTS 초기화");
    String macAddress = widget.addr.substring(3);

    print("macAddress :$macAddress");
    String machinName = macAddress == "E8:D2:3E:98:B5:85" ? "랫풀다운" : "시티드로우";
    await flutterTts.stop();
    await flutterTts.speak("$machinName 운동을 시작합니다.");
    print("TTS 초기화 완료");
  }

//펄스 애니메이션 init
  void _initPulseAnimation() {
    _pulseAnimation =
        Tween<double>(begin: 1.0, end: 1.03).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  //애니메이션 컨트롤러 초기화
  void _initAnimationController() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addListener(() {
      setState(() {});
    });
  }

  //모달 확인
  void _checkModal() {
    if (!BoolStatus.isModal) {
      BoolStatus.isModal = true;
      print("BluetoothViewModel 초기화 중");
    }
  }

  //viewModel초기화
  void _initializeViewModel() {
    _viewModel = BluetoothViewModel(deviceAddr: widget.addr);
    // _viewModel!.onNavigateToHome = _navigateToHome;
    _viewModel!.initialize();
  }

  //count 변경 감지 (구)
  void _listenForCountChanges() {
    _viewModel!.countNotifier.addListener(() {
      _animateCountChange();

      if (_viewModel!.countNotifier.value == 0) {
        _handleCountZero();
      }
    });
  }

  // DateTime? _lastCountTime; // 마지막 카운트 변경 시간을 추적하는 변수

  //count 변경 감지 (신)
//count 변경 감지 (신)
  // void _listenForCountChanges() {
  //   _viewModel!.countNotifier.addListener(() {
  //     try {
  //       final currentTime = DateTime.now(); // 현재 시간을 기록합니다.

  //       if (_lastCountTime != null) {
  //         // 이전 카운트 변경 시간이 있으면 시간 차이를 계산합니다.
  //         final difference = currentTime.difference(_lastCountTime!);
  //         _giveTimeFeedback(difference); // 시간 피드백 함수를 호출합니다.
  //       }

  //       _lastCountTime = currentTime; // 마지막 카운트 변경 시간을 갱신합니다.
  //       _animateCountChange(); // 카운트 변경 애니메이션을 실행합니다.

  //       if (_viewModel!.countNotifier.value == 0) {
  //         _handleCountZero(); // 카운트가 0이면 처리합니다.
  //       }
  //     } catch (error) {
  //       print('An error occurred in _listenForCountChanges: $error'); // 에러 로깅
  //     }
  //   });
  // }

  //count시 애니메이션 처리
  void _animateCountChange() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  //count가 0일때 처리
  void _handleCountZero() {
    if (_viewModel!.setCount > 0) {
      _showRestTimeSheet();
    }
    setState(() {
      _viewModel?.minusSetCount();
      _setMessage = "${_viewModel?.setCount} SET 남음";
      if (_viewModel?.setCount == 0) {
        _setMessage = "운동 종료";
        _viewModel?.dispose();
        Navigator.pop(context);
      }
    });
  }

  void _onCloseTap() {
    _viewModel!.pushData();
    _viewModel?.setRestState = false;
    _viewModel?.writeDataToDevice("\$wr;");
    flutterTts.speak('휴식 종료');
    Navigator.of(context).pop();
  }

  // 홈 화면으로 이동하는 함수
  void _navigateToHome() {
    print("0초 지남, 홈 화면으로 이동 시도중");
    //goRouter.go("/home");
    HapticFeedback.lightImpact(); // 햅틱 피드백 호출
    _viewModel?.dispose();
    print("viewModel.dispose");
    Navigator.pop(context);
  }

  void _showRestTimeSheet() async {
    _viewModel?.setRestState = true;
    _viewModel?.pushData();
    int start = 10;

    // 시간이 변화할 때마다 이 Stream에서 이벤트를 내보냅니다.
    Stream<int> timerStream =
        Stream<int>.periodic(const Duration(seconds: 1), (second) {
      return start - second;
    }).take(start);

    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withOpacity(0.2),
      context: context,
      isDismissible: true, // 바텀 시트 외부를 탭하면 바텀 시트가 닫힙니다.
      builder: (context) {
        RSizes s = RSizes(MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width);

        RGaps g = RGaps(MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width);
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            //color: Colors.transparent,
            clipBehavior: Clip.hardEdge,
            height: s.rSize("height", 600),
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withOpacity(1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),

            child: Center(
                child: StreamBuilder<int>(
              stream: timerStream,
              initialData: start,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Future.delayed(Duration.zero, () {
                    _onCloseTap(); // 바텀 시트를 닫습니다.
                  });
                }
                return Padding(
                  padding: EdgeInsets.fromLTRB(
                      s.rSize("width", 050), // left,
                      s.rSize("height", 010), // top,
                      s.rSize("width", 050), // right,
                      s.rSize("height", 0) // bottom,
                      ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () => {_onCloseTap()},
                            icon: const Icon(Icons.close),
                            color: Colors.white,
                          )
                        ],
                      ),
                      g.vr10(),
                      Container(
                        height: 130,
                        width: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: EdgeInsets.all(
                          s.rSize("width", 00),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Rest Time",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: s.rSize("width", 60),
                              ),
                            ),
                            g.vr01(),
                            Text(
                              "${((snapshot.data ?? 0) ~/ 60).toString().padLeft(2, '0')}:${((snapshot.data ?? 0) % 60).toString().padLeft(2, '0')}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: s.rSize("width", 80),
                              ),
                            ),
                          ],
                        ),
                      ),
                      g.vr10(),
                      Text(
                        "SET: ${_viewModel?.setCount}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: s.rSize("width", 100),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
          ),
        );
      },
    );
  }

  void _showSetCountPicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          RSizes s = RSizes(MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width);

          RGaps g = RGaps(MediaQuery.of(context).size.height,
              MediaQuery.of(context).size.width);
          return Container(
            height: s.rSize("height", 400),
            color: Colors.white,
            child: ListView.builder(
              itemCount: 10, // 이곳에서 원하는 setCount 범위를 설정하세요
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Set ${index + 1}'),
                  onTap: () {
                    setState(() {
                      _viewModel?.setCountSet = index + 1;
                      _setMessage = '남은 Set: ${_viewModel?.setCount}';
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        });
  }

  _updateProgress(double count) {
    setState(
      () {
        _progressAnimation = Tween<double>(
          begin: _progressAnimation.value, // 현재의 애니메이션 값
          end: (5 - _count) / 5, // 새로운 count 값으로 계산된 값
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );
      },
    );

    _animationController.forward(from: 0);
  }

  // 실제 화면을 그리는 코드
  @override
  Widget build(BuildContext context) {
    // size
    RSizes s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    RGaps g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    // 로딩 인디케이터와 위젯을 표시하는 ValueListenableBuilder
    return SafeArea(
      child: Scaffold(
        body: ValueListenableBuilder<bool>(
          valueListenable: _viewModel!.connect, // connect ValueNotifier
          builder: (context, isConnect, _) {
            if (isConnect) {
              // 연결 중이면 로딩 인디케이터 표시
              return const Center(child: CircularProgressIndicator());
            } else {
              // 연결이 완료되면 아래 위젯 표시
              return Stack(
                children: [
                  Positioned(
                    top: s.rSize00(),
                    left: s.rSize00(),
                    right: s.rSize00(),
                    bottom: s.rSize00(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              s.wrSize05(), //left
                              s.hrSize015(), //top
                              s.wrSize05(), //right
                              s.rSize00(), //bottom
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // 뒤로가기 버튼을 누를 때 수행할 작업을 여기에 작성합니다.
                                    _viewModel?.dispose();
                                    Navigator.pop(context);
                                  },
                                ),
                                SizedBox(
                                  width: s.wrSize10(),
                                  height: s.wrSize10(),
                                  child: Image.asset("Images/logo_white.png"),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // ... 버튼을 누를 때 수행할 작업을 여기에 작성합니다.
                                    _showSetCountPicker();
                                  },
                                ),
                              ],
                            ),
                          ),
                          g.vr12(),
                          ValueListenableBuilder<String>(
                            valueListenable: _viewModel!.receivedDataNotifier,
                            builder: (context, receivedData, _) => Center(
                              child: Text(
                                "${recivedDataToRawData(receivedData)} KG",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: Sizes.size52,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          g.vr05(),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF373737),
                                        ),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: ValueListenableBuilder<int>(
                                    valueListenable: _viewModel!.countNotifier,
                                    builder: (context, count, _) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              width: 200,
                                              height: 200,
                                              child: CircularProgressIndicator(
                                                value: (5 - count) / 5,
                                                strokeWidth: 10,
                                                backgroundColor:
                                                    Colors.grey.shade400,
                                                valueColor:
                                                    const AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.green,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              '${5 - count}',
                                              style: const TextStyle(
                                                fontSize: 100,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                g.vr05(),
                                Text(_setMessage,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 40)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // NfcManager.instance.stopSession();
    print("view dispose");
    _animationController.dispose();
    _viewModel!.dispose();
    widget.onDispose?.call(); // 여기서 콜백 호출
    super.dispose();
  }
}
