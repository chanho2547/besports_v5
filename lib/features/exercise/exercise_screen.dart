import 'package:besports_v5/constants/gaps.dart';
import 'package:besports_v5/features/exercise/buttons/circleButton.dart';
import 'package:besports_v5/features/exercise/nfc/nfcView.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});
  static const routeName = '/exercise';
  static const routeURL = '/exercise';

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.grey.shade700,
      //   elevation: 0,
      // ),
      backgroundColor: Colors.grey.shade800,
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Gaps.v10,
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_outlined,
                        color: Colors.white, size: 40),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Gaps.v96,
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // 버튼을 누르면 다른 화면으로 이동
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const NFCScreen()),
                  //     );
                  //   },

                  //   // 동그라미 버튼 생성
                  //   child: const CircleButton(),
                  // ),

                  // 동그라미 버튼 생성
                  GestureDetector(
                    child: const CircleButton(),
                    onTap: () {
                      context.pushNamed(NFCScreen.routeName);
                    },
                  ),
                  Gaps.v44,
                  IconButton(
                    icon: const Icon(Icons.arrow_upward,
                        color: Colors.white, size: 40),
                    onPressed: () {},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent, // 하이라이트 효과를 제거
                  ),
                  Text(
                    'tap to start',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
