import 'package:audioplayers/audioplayers.dart';
import 'package:besports_v5/constants/gaps.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:besports_v5/constants/sizes.dart';
import 'package:besports_v5/constants/staticStatus.dart';
import 'package:besports_v5/main.dart';
import 'package:besports_v5/router.dart';
import 'package:besports_v5/utils/dateUtils.dart';
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

  late RSizes s;
  late RGaps g;

  String _setMessage = "4 SET 남음"; // 초기 메시지는 빈 문자열

  @override
  void initState() {
    super.initState();
    _lastNumber = -1;
    flutterTts.setLanguage("ko-KR");

    _initAnimationController();
    _checkModal();
    _initializeViewModel();
    _listenForCountChanges();
    _initPulseAnimation();
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
    _viewModel!.onNavigateToHome = _navigateToHome;
    _viewModel!.initialize();
  }

  void numberToKoreanWord(int number) async {
    //_lastNumber = number; // 마지막 번호를 업데이트
    if (number == 0 && _lastNumber == 0) {
      // 이전 번호도 0이었으므로 아무것도 하지 않음
    } else {
      try {
        switch (number) {
          case 1:
            await flutterTts.stop();
            await flutterTts.speak("하나");
            break;
          case 2:
            await flutterTts.stop();
            await flutterTts.speak("둘");
            break;
          case 3:
            await flutterTts.stop();
            await flutterTts.speak("셋");
            break;
          case 4:
            await flutterTts.stop();
            await flutterTts.speak("넷");
            break;
          case 5:
            await flutterTts.stop();
            await flutterTts.speak("둘");
            break;
          case 0:
            await flutterTts.stop();
            // 벨소리 재생을 위한 audioplayer
            final player = AudioPlayer();
            player.setVolume(0.4); // 볼륨 설정, 최대 1.0
            player.play(AssetSource('../sounds/bell_sound.mp3')); // 벨소리 재생
            break;
          default:
        }
      } catch (e) {
        print("Error occurred: $e");
      }
    }
  }

  //count 변경 감지
  void _listenForCountChanges() {
    _viewModel!.countNotifier.addListener(() {
      _animateCountChange();

      if (_viewModel!.countNotifier.value == 0) {
        _handleCountZero();
      }
    });
  }

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
    //dispose(); // 여기서 연결 해제

    // 4초 후에 홈 화면으로 이동하는 코드

    print("0초 지남, 홈 화면으로 이동 시도중");
    //goRouter.go("/home");
    HapticFeedback.lightImpact(); // 햅틱 피드백 호출
    _viewModel?.dispose();
    print("viewModel.dispose");
    Navigator.pop(context);
  }

  void _showRestTimeSheet() async {
    _viewModel?.setRestState = true;
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

  @override
  Widget build(BuildContext context) {
    //size
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                    Container(
                      child: ValueListenableBuilder<String>(
                        valueListenable: _viewModel!.receivedDataNotifier,
                        builder: (context, receivedData, _) => Center(
                          child: Text(
                            "${recivedDataToLowData(receivedData)} KG",
                            textAlign: TextAlign.center, // 텍스트 정렬을 중앙으로 설정
                            style: const TextStyle(
                              fontSize: Sizes.size52,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
                                    color: Color(0xFF373737), // 초록색 띠
                                    // border: Border.all(
                                    //   color: Colors.grey.shade100,
                                    //   width: Sizes.size7,
                                    // ),
                                  ),
                                  child: child,
                                ),
                              );
                            },
                            child: ValueListenableBuilder<int>(
                              valueListenable: _viewModel!.countNotifier,
                              builder: (context, count, _) {
                                if (_viewModel!.countNotifier.value !=
                                    _lastNumber) {
                                  numberToKoreanWord(5 - count);
                                  _lastNumber = _viewModel!.countNotifier.value;
                                }
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: 200,
                                        height: 200,
                                        child: CircularProgressIndicator(
                                          value: (5 - count) /
                                              5, // count 값에 따라 진행률이 변경됩니다. 5는 최대 카운트 값입니다.
                                          strokeWidth: 10,
                                          backgroundColor: Colors
                                              .grey.shade400, // 미완료 부분의 색상을 설정
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(
                                            Colors.green,
                                          ), // 완료 부분의 색상을 설정
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
                          g.vr05(), // 간격을 주기 위한 코드
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
