import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/features/recommend/recommend_screen.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Widget child;

  const ChatBubble({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          painter: ChatBubblePainter(),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      ],
    );
  }
}

class ChatBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = custom_colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2 + 10, 0)
      ..lineTo(size.width / 2, -10) // 말풍선 꼬리
      ..lineTo(size.width / 2 - 10, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint); // Fill the bubble with white color
    canvas.drawPath(path, borderPaint); // Add border to the bubble
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
