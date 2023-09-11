import 'package:besports_v5/constants/sizes.dart';
import 'package:besports_v5/router.dart';
import 'package:flutter/material.dart';
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

  String _setMessage = "4SET START!!"; // 초기 메시지는 빈 문자열

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

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.6).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    viewModel!.countNotifier.addListener(() {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });

      if (viewModel!.countNotifier.value == 0) {
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

  void _showSetCountPicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.25, // 화면의 1/4 높이
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
    goRouter.go("/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.05, //left
                      MediaQuery.of(context).size.height * 0.05, //top
                      MediaQuery.of(context).size.width * 0.05, //right
                      MediaQuery.of(context).size.height * 0.05, //top
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
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.width * 0.15,
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
                  const SizedBox(height: Sizes.size52),
                  Container(
                    child: ValueListenableBuilder<String>(
                      valueListenable: viewModel!.receivedDataNotifier,
                      builder: (context, receivedData, _) => Center(
                        child: Text(
                          receivedData
                              .replaceAll("\$r", '')
                              .replaceAll(';', ''),
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
                  const SizedBox(height: Sizes.size52),
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
                                    color: Colors.green, // 빨간색 원
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
                        const SizedBox(height: 50), // 간격을 주기 위한 코드
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
