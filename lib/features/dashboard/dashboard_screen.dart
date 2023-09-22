import 'dart:math';

import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/gaps.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'functions/_date_picker.dart';
import 'functions/bottomDaysSetting.dart';
import 'functions/weight_progress_card.dart';

enum updateStatus { Plus, Even, Minus }

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const routeName = "/home";
  static const routeURL = "/home";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DateTime _baseDate = DateTime.now();
  DateTime _startDate = DateTime.utc(2022, 2, 8);

  // 임의의 코드
  final random = Random();

  List<String> options = ["Week", "2 Weeks", "Month", "Custom"];
  String selectedOption = "Week";
  String showingOption = "SELECT";
  bool isCustom = false;

  var totalWeights = new List<int>.filled(6, 0);
  var updateWeights = new List<int>.filled(6, 0);
  List<updateStatus> updateStatuses = [
    updateStatus.Even,
    updateStatus.Even,
    updateStatus.Even,
    updateStatus.Even,
    updateStatus.Even,
    updateStatus.Minus
  ];

  late RSizes s;
  late RGaps g;

  @override
  void initState() {
    super.initState();
  }

  void _showDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      _startDate,
      (DateTime newDate) {
        setState(() {
          _startDate = newDate;
        });
      },
      "Select Workout",
    );
  }

  void _showOptions() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomSheetOptions(
            options: options,
            initialValue: selectedOption,
            onSelected: (value, isCurrentCustom) {
              _updateNumbers(value);
              setState(() {
                selectedOption = isCurrentCustom ? "Custom" : value;
                showingOption = value;
                isCustom = isCurrentCustom;
              });
            },
          ),
        );
      },
    );
  }

  void _updateNumbers(String option) {
    switch (option) {
      case "Week":
        totalWeights = [2000, 750, 2580, 650, 1200, 640];
        updateWeights = [200, 50, 0, 75, 25, 30];
        updateStatuses = [
          updateStatus.Minus,
          updateStatus.Plus,
          updateStatus.Even,
          updateStatus.Plus,
          updateStatus.Plus,
          updateStatus.Minus
        ];
        break;

      case "2 Weeks":
        totalWeights = [4800, 1200, 2580, 1400, 2500, 1200];
        updateWeights = [150, 150, 100, 0, 50, 100];
        updateStatuses = [
          updateStatus.Plus,
          updateStatus.Minus,
          updateStatus.Minus,
          updateStatus.Even,
          updateStatus.Plus,
          updateStatus.Minus
        ];
        break;

      case "Month":
        totalWeights = [9900, 3000, 5000, 2890, 5100, 2000];
        updateWeights = [100, 90, 0, 0, 100, 20];
        updateStatuses = [
          updateStatus.Minus,
          updateStatus.Plus,
          updateStatus.Even,
          updateStatus.Even,
          updateStatus.Minus,
          updateStatus.Plus
        ];
        break;

      default:
        totalWeights = [
          (random.nextInt(50) + 1) * 10,
          (random.nextInt(50) + 1) * 10,
          (random.nextInt(50) + 1) * 10,
          (random.nextInt(50) + 1) * 10,
          (random.nextInt(50) + 1) * 10,
          (random.nextInt(50) + 1) * 10
        ];
        updateWeights = [
          (random.nextInt(4) + 1) * 10,
          (random.nextInt(4) + 1) * 10,
          (random.nextInt(4) + 1) * 10,
          (random.nextInt(4) + 1) * 10,
          (random.nextInt(4) + 1) * 10,
          (random.nextInt(4) + 1) * 10
        ];
        updateStatuses = [
          updateStatus.Minus,
          updateStatus.Plus,
          updateStatus.Minus,
          updateStatus.Plus,
          updateStatus.Minus,
          updateStatus.Plus
        ];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    Duration difference = _baseDate.difference(_startDate);
    String dDay = difference.inDays + 1 > 0
        ? "+${difference.inDays + 1}"
        : "${difference.inDays + 1}";

    return SafeArea(
      child: Scaffold(
        backgroundColor: custom_colors.backgroundDarkWhite,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(s.hrSize10()),
          child: AppBar(
            backgroundColor: custom_colors.backgroundDarkWhite,
            flexibleSpace: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: s.wrSize25()),
                    child: Image.asset(
                      'Images/logo_green.png',
                      height: s.hrSize04(),
                      width: s.wrSize10(),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: s.wrSize05()),
                    width: s.wrSize20(),
                    child: IconButton(
                      onPressed: () => _showDatePicker(context),
                      icon: const FaIcon(FontAwesomeIcons.ellipsis),
                      color: custom_colors.ellipsisGrey,
                      iconSize: s.hrSize035(),
                    ),
                  )
                ],
              ),
            ),
            elevation: 0,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: s.hrSize02()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: s.wrSize02()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        g.vr05(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'D$dDay',
                              style: TextStyle(
                                color: custom_colors.hotRed,
                                fontSize: s.hrSize028(),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            g.hr04(),
                            Text(
                              ' with ',
                              style: TextStyle(
                                color: custom_colors.black,
                                fontSize: s.hrSize028(),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            g.hr02(),
                            Image.asset(
                              'Images/besports_letters_logo.png',
                              width: s.wrSize45(),
                              height: s.hrSize02(),
                              fit: BoxFit.fitHeight,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  g.vr03(),
                  Expanded(
                    child: Container(
                      width: s.maxWidth(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: custom_colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                s.wrSize03(), s.hrSize03(), s.wrSize03(), 0),
                            child: Column(
                              children: [
                                Center(
                                  child: GestureDetector(
                                    onTap: _showOptions,
                                    child: Container(
                                      width: isCustom
                                          ? s.wrSize50() + s.wrSize20()
                                          : s.wrSize25(),
                                      height: s.hrSize05(),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: custom_colors.besportsGreen,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            offset: const Offset(0, 5),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          showingOption,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: custom_colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                g.vr005(),
                                SizedBox(
                                  height: s.hrSize50(),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        weight_progress_card(
                                          g: g,
                                          s: s,
                                          workoutName: "Bench Press",
                                          UpDownEven: updateStatuses[0],
                                          totalWeights: totalWeights[0],
                                          updateWeights: updateWeights[0],
                                        ),
                                        weight_progress_card(
                                          g: g,
                                          s: s,
                                          workoutName: "Shoulder Press",
                                          UpDownEven: updateStatuses[1],
                                          totalWeights: totalWeights[1],
                                          updateWeights: updateWeights[1],
                                        ),
                                        weight_progress_card(
                                          g: g,
                                          s: s,
                                          workoutName: "Squat",
                                          UpDownEven: updateStatuses[2],
                                          totalWeights: totalWeights[2],
                                          updateWeights: updateWeights[2],
                                        ),
                                        weight_progress_card(
                                          g: g,
                                          s: s,
                                          workoutName: "Lat Pull Down",
                                          UpDownEven: updateStatuses[3],
                                          totalWeights: totalWeights[3],
                                          updateWeights: updateWeights[3],
                                        ),
                                        weight_progress_card(
                                          g: g,
                                          s: s,
                                          workoutName: "Cable Crossover",
                                          UpDownEven: updateStatuses[4],
                                          totalWeights: totalWeights[4],
                                          updateWeights: updateWeights[4],
                                        ),
                                        weight_progress_card(
                                          g: g,
                                          s: s,
                                          workoutName: "Pec Deck Fly",
                                          UpDownEven: updateStatuses[5],
                                          totalWeights: totalWeights[5],
                                          updateWeights: updateWeights[5],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
