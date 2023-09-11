import 'package:flutter/material.dart';

class workout_card extends StatelessWidget {
  final String image_path;
  final VoidCallback onTap;

  const workout_card({
    Key? key,
    required this.image_path,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: appWidth * 0.025),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: AssetImage(image_path), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
