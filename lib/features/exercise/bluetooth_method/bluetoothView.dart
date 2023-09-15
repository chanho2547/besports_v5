import 'package:besports_v5/constants/sizes.dart';
import 'package:besports_v5/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:go_router/go_router.dart';
import 'bluetoothViewModel.dart'; // BluetoothViewModel 위치로 변경하세요.

class BluetoothScreen extends StatefulWidget {
  final String addr;

  const BluetoothScreen({Key? key, required this.addr}) : super(key: key);

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen>
    with SingleTickerProviderStateMixin {
  late BluetoothViewModel? viewModel;
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  double maxHeight = 0.0;
  double maxWidth = 0.0;

  String _setMessage = "START!!"; // 초기 메시지는 빈 문자열

  @override
  void initState() {
    super.initState();
    print("BluetoothViewModel 초기화 중");

    viewModel = BluetoothViewModel(deviceAddr: widget.addr);
    viewModel!.onNavigateToHome = _navigateToHome;

    // ViewModel 초기화
    viewModel!.initialize();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    viewModel!.countNotifier.addListener(() {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      if (viewModel!.countNotifier.value == 0) {
        _showRestTimeSheet();
        setState(() {
          BluetoothViewModel.setCount--;
          _setMessage = "${BluetoothViewModel.setCount} SET 남음";

          if (BluetoothViewModel.setCount == 0) {
            _setMessage = "운동 종료";
            BluetoothViewModel.setCount = 3;
            viewModel!.disconnect();
            _navigateToHome();
          }
        });
      }
    });
  }

  void _showRestTimeSheet() async {
    viewModel?.enterRestState();
    int start = 5;

    // 시간이 변화할 때마다 이 Stream에서 이벤트를 내보냅니다.
    Stream<int> timerStream =
        Stream<int>.periodic(const Duration(seconds: 1), (second) {
      return start - second;
    }).take(start);

    await showModalBottomSheet(
      context: context,
      isDismissible: true, // 바텀 시트 외부를 탭하면 바텀 시트가 닫힙니다.
      builder: (context) {
        return Container(
          height: maxHeight,
          color: Colors.white, // 백그라운드 색상을 흰색으로 설정
          child: Center(
              child: StreamBuilder<int>(
            stream: timerStream,
            initialData: start,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Future.delayed(Duration.zero, () {
                  viewModel?.exitRestState();
                  Navigator.of(context).pop(); // 바텀 시트를 닫습니다.
                });
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Rest Time!",
                      style: TextStyle(color: Colors.black, fontSize: 25)),
                  const SizedBox(height: 20),
                  Text("${snapshot.data} seconds",
                      style:
                          const TextStyle(color: Colors.black, fontSize: 18)),
                ],
              );
            },
          )),
        );
      },
    );
  }

  void _showSetCountPicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: maxHeight * 0.25, // 화면의 1/4 높이
            color: Colors.white,
            child: ListView.builder(
              itemCount: 10, // 이곳에서 원하는 setCount 범위를 설정하세요
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Set ${index + 1}'),
                  onTap: () {
                    setState(() {
                      BluetoothViewModel.setCount = index + 1;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          );
        });
  }

  // 홈 화면으로 이동하는 함수
  void _navigateToHome() {
    //dispose(); // 여기서 연결 해제

    // 4초 후에 홈 화면으로 이동하는 코드

    print("0초 지남, 홈 화면으로 이동 시도중");
    //goRouter.go("/home");
    HapticFeedback.lightImpact(); // 햅틱 피드백 호출
    BluetoothViewModel.setCount = 4;
    viewModel?.disconnect();
    viewModel?.dispose();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    maxWidth = MediaQuery.of(context).size.width;
    maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: maxHeight * 0,
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
                      maxWidth * 0.05, //left
                      maxHeight * 0, //top
                      maxWidth * 0.05, //right
                      maxHeight * 0, //bottom
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
                            BluetoothViewModel.setCount = 4;
                            viewModel?.disconnect();
                            viewModel?.dispose();
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: maxWidth * 0.15,
                          height: maxHeight * 0.15,
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
                  SizedBox(
                    height: maxHeight * 0.12,
                  ),
                  Container(
                    child: ValueListenableBuilder<String>(
                      valueListenable: viewModel!.receivedDataNotifier,
                      builder: (context, receivedData, _) => Center(
                        child: Text(
                          "${receivedData.replaceAll("\$r", '').replaceAll(';', '')} KG",
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
                  SizedBox(
                    height: maxHeight * 0.05,
                  ),
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
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF373737), // 초록색 띠
                                  border: Border.all(
                                    color: Colors.grey.shade100,
                                    width: Sizes.size7,
                                  ),
                                ),
                                child: child,
                              ),
                            );
                          },
                          child: ValueListenableBuilder<int>(
                            valueListenable: viewModel!.countNotifier,
                            builder: (context, count, _) => Text(
                              '$count',
                              style: const TextStyle(
                                fontSize: 100,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: maxHeight * 0.05), // 간격을 주기 위한 코드
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
    );
  }

  @override
  void dispose() {
    viewModel!.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
