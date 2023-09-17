import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'functions/_date_picker.dart';
import 'Screens/overview_screen.dart';
import 'Screens/graph1_screen.dart';
import 'Screens/graph2_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const routeName = "/home";
  static const routeURL = "/home";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ScrollController _scrollController;
  final DateTime _baseDate = DateTime.now();
  int _currentIndex = 2;
  int dates_count = 5;
  DateTime _startDate = DateTime.utc(2022, 2, 8);

  double _selectedOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController =
        ScrollController(initialScrollOffset: 2 * 100.0) // Start at the middle
          ..addListener(() {
            int newIndex = (_scrollController.offset / 100.0).round();
            if (newIndex != _currentIndex) {
              setState(() {
                _currentIndex = newIndex;
              });
            }
          });
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

  @override
  Widget build(BuildContext context) {
    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;
    String startDate = DateFormat('yyyy. MM. dd').format(_startDate);
    Duration difference = _baseDate.difference(_startDate);
    String dDay = difference.inDays + 1 > 0
        ? "+${difference.inDays + 1}"
        : "${difference.inDays + 1}";

    Widget _buildTab(
        int index, String title, double appHeight, double appWidth) {
      bool isSelected = _currentIndex == index;

      return GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
            _selectedOffset = appWidth * 0.30 * index;
          });
        },
        child: AnimatedContainer(
          width: appWidth * 0.305,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.transparent,
            borderRadius: BorderRadius.circular(5), // 둥근 모서리를 위해 추가
            border: isSelected
                ? Border.all(color: Colors.green, width: 2.0)
                : null, // 선택된 항목에만 둥근 직사각형 테두리 추가
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color:
                    isSelected ? Colors.white : Colors.black.withOpacity(0.5),
                fontSize: appHeight * 0.02,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildCurrentScreen() {
      switch (_currentIndex) {
        case 0:
          return const OverviewScreen();
        case 1:
          return const Graph1Screen();
        case 2:
          return Graph2Screen();
        default:
          return const OverviewScreen(); // Default to Overview screen
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: custom_colors.bgGray,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(appHeight * 0.1),
          child: AppBar(
            backgroundColor: custom_colors.bgGray,
            flexibleSpace: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'Images/logo_green.png',
                height: appHeight * 0.04,
                width: appWidth * 0.1,
                fit: BoxFit.fill,
              ),
            ),
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: appHeight * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: appWidth * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: appHeight * 0.02,
                          ),
                          Row(
                            children: [
                              Text(
                                'You are ',
                                style: TextStyle(
                                  color: custom_colors.txtBlack,
                                  fontSize: appHeight * 0.028,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'D$dDay',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: appHeight * 0.028,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                ' with ',
                                style: TextStyle(
                                  color: custom_colors.txtBlack,
                                  fontSize: appHeight * 0.028,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'BESPORTS',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: appHeight * 0.028,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: appHeight * 0.01,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: appWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "since",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: appHeight * 0.02,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(
                                width: appWidth * 0.01,
                              ),
                              Text(
                                startDate,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: appHeight * 0.02,
                                  color: Colors.green,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _showDatePicker(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: appWidth * 0.005,
                                  horizontal: appHeight * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: custom_colors.txtBlack,
                              ),
                              child: const Text(
                                'new start date',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: appHeight * 0.036,
                    ),
                    Container(
                      height: appHeight * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTab(0, "Overview", appHeight, appWidth),
                          _buildTab(1, "Graph1", appHeight, appWidth),
                          _buildTab(2, "Graph2", appHeight, appWidth),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: appHeight * 0.01,
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: appHeight * 0.56,
                            width: appWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child:
                                _buildCurrentScreen(), // Display the selected screen
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
      ),
    );
  }
}
