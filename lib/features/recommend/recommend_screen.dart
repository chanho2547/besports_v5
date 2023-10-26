import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/gaps.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:flutter/material.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({super.key});

  static const routeName = '/recommend';
  static const routeURL = '/recommend';

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  late RSizes s;
  late RGaps g;

  final ValueNotifier<int> _selectGender = ValueNotifier<int>(-1);
  final ValueNotifier<int> _selectGoal = ValueNotifier<int>(-1);
  final ValueNotifier<int> _selectDivide = ValueNotifier<int>(-1);
  final ValueNotifier<List<int>> _selectPart = ValueNotifier<List<int>>([]);

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return SafeArea(
      child: Scaffold(
        backgroundColor: custom_colors.backgroundDarkWhite,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(s.hrSize10()),
          child: AppBar(
            backgroundColor: custom_colors.backgroundDarkWhite,
            flexibleSpace: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'Images/logo_green.png',
                height: s.hrSize04(),
                width: s.wrSize10(),
                fit: BoxFit.fill,
              ),
            ),
            elevation: 0,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: s.hrSize03()),
              child: Column(
                children: [
                  g.vr02(),
                  Text(
                    'Workout Recommend',
                    style: TextStyle(
                      color: custom_colors.backgroundLightBlack,
                      fontSize: s.hrSize028(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectButton(
                  type: _selectGender,
                  typeChoice: 0,
                  w: s.wrSize40(),
                  h: s.hrSize05(),
                  text: "남자",
                ),
                selectButton(
                  type: _selectGender,
                  typeChoice: 1,
                  w: s.wrSize40(),
                  h: s.hrSize05(),
                  text: "여자",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectButton(
                  type: _selectGoal,
                  typeChoice: 0,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "다이어트",
                ),
                selectButton(
                  type: _selectGoal,
                  typeChoice: 1,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "근성장",
                ),
                selectButton(
                  type: _selectGoal,
                  typeChoice: 2,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "유지",
                ),
                selectButton(
                  type: _selectGoal,
                  typeChoice: 3,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "건강",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectButton(
                  type: _selectDivide,
                  typeChoice: 0,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "무분할",
                ),
                selectButton(
                  type: _selectDivide,
                  typeChoice: 1,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "2분할",
                ),
                selectButton(
                  type: _selectDivide,
                  typeChoice: 2,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "3분할",
                ),
                selectButton(
                  type: _selectDivide,
                  typeChoice: 3,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "5분할",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 0,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "팔",
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 1,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "가슴",
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 2,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "하체",
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 3,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "등",
                ),
                selectMultipleButton(
                  type: _selectPart,
                  typeChoice: 4,
                  w: s.wrSize15(),
                  h: s.hrSize05(),
                  text: "어깨",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector selectButton({
    required ValueNotifier<int> type,
    required int typeChoice,
    required double w,
    required double h,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          type.value = typeChoice;
        });
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: type.value == typeChoice
              ? custom_colors.besportsGreen
              : custom_colors.consumeLightGreen,
          borderRadius: BorderRadius.circular(s.hrSize01()),
        ),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }

  GestureDetector selectMultipleButton({
    required ValueNotifier<List<int>> type,
    required int typeChoice,
    required double w,
    required double h,
    required String text,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (type.value.contains(typeChoice)) {
            type.value.remove(typeChoice);
          } else {
            type.value.add(typeChoice);
          }
          type.notifyListeners();
        });
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: type.value.contains(typeChoice)
              ? custom_colors.besportsGreen
              : custom_colors.consumeLightGreen,
          borderRadius: BorderRadius.circular(s.hrSize01()),
        ),
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
