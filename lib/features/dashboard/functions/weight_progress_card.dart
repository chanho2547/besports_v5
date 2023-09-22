import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/gaps.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:besports_v5/features/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class weight_progress_card extends StatelessWidget {
  weight_progress_card({
    super.key,
    required this.g,
    required this.s,
    required this.workoutName,
    required this.UpDownEven,
    required this.totalWeights,
    required this.updateWeights,
  });

  final RGaps g;
  final RSizes s;
  String workoutName;
  updateStatus UpDownEven;
  int totalWeights;
  int updateWeights;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: s.hrSize01(),
            horizontal: s.wrSize015(),
          ),
          child: Container(
            width: s.wrSize50() + s.wrSize35(),
            height: s.hrSize12(),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: custom_colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: const Offset(0, 5),
                  blurRadius: 10,
                ),
              ],
            ),
            child: workout_update(
              s: s,
              workoutName: workoutName,
              upDownEven: UpDownEven,
              totalWeights: totalWeights,
              updateWeights: updateWeights,
            ),
          ),
        ),
      ],
    );
  }
}

class workout_update extends StatelessWidget {
  workout_update({
    super.key,
    required this.s,
    required this.workoutName,
    required this.upDownEven,
    required this.totalWeights,
    required this.updateWeights,
  });

  final RSizes s;
  String workoutName;
  updateStatus upDownEven;
  int totalWeights;
  int updateWeights;

  Color _getColorFromState() {
    switch (upDownEven) {
      case updateStatus.Plus:
        return custom_colors.updownRed;
      case updateStatus.Even:
        return custom_colors.evenGreen; // 이 색상은 정의해야 합니다.
      case updateStatus.Minus:
        return custom_colors.updownBlue;
    }
  }

  String _getImageFromState() {
    switch (upDownEven) {
      case updateStatus.Plus:
        return "Images/updownUpRed.png";
      case updateStatus.Even:
        return "Images/updownEvenGreen.png"; // 이 색상은 정의해야 합니다.
      case updateStatus.Minus:
        return "Images/updownDownBlue.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: s.wrSize01(),
          ),
          width: s.hrSize10(),
          child: Text(
            workoutName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          width: s.hrSize20(),
          child: Text(
            "${totalWeights}KG",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Gaps.h10,
        SizedBox(
          width: s.wrSize10(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                _getImageFromState(),
                width: s.wrSize10(),
              ),
              Text(
                updateWeights == 0 ? "EVEN" : "${updateWeights}KG",
                style: TextStyle(
                  color: _getColorFromState(),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
