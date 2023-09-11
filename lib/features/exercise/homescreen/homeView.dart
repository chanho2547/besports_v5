import 'package:besports_v5/features/exercise/buttons/circleButton.dart';
import 'package:besports_v5/features/exercise/nfc/nfcView.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 버튼을 누르면 다른 화면으로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NFCScreen()),
            );
          },
          // 동그라미 버튼 생성
          child: const CircleButton(),
        ),
      ),
    );
  }
}
