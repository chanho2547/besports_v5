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

enum updateState { Plus, Even, Minus }

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

  List<String> options = ["Week", "2 Weeks", "Month", "Custom"];
  String selectedOption = "Week";
  String showingOption = "Week";
  bool isCustom = false;

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
                  Container(
                    height: s.hrSize60(),
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
                                          color: Colors.black.withOpacity(0.2),
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
                                        UpDownEven: updateState.Plus,
                                        totalWeights: 70,
                                        updateWeights: 15,
                                      ),
                                      weight_progress_card(
                                        g: g,
                                        s: s,
                                        workoutName: "Shoulder Press",
                                        UpDownEven: updateState.Minus,
                                        totalWeights: 90,
                                        updateWeights: 10,
                                      ),
                                      weight_progress_card(
                                        g: g,
                                        s: s,
                                        workoutName: "Squat",
                                        UpDownEven: updateState.Even,
                                        totalWeights: 120,
                                        updateWeights: 0,
                                      ),
                                      weight_progress_card(
                                        g: g,
                                        s: s,
                                        workoutName: "Lat Pull Down",
                                        UpDownEven: updateState.Minus,
                                        totalWeights: 100,
                                        updateWeights: 20,
                                      ),
                                      weight_progress_card(
                                        g: g,
                                        s: s,
                                        workoutName: "Cable Crossover",
                                        UpDownEven: updateState.Plus,
                                        totalWeights: 70,
                                        updateWeights: 10,
                                      ),
                                      weight_progress_card(
                                        g: g,
                                        s: s,
                                        workoutName: "Pec Deck Fly",
                                        UpDownEven: updateState.Minus,
                                        totalWeights: 20,
                                        updateWeights: 40,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
