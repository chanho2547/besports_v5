import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/sizes.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  static const routeName = "/home";
  static const routeURL = "/home";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int calorie = 432;
  late ScrollController _scrollController;
  final DateTime _baseDate = DateTime.now();
  int _currentIndex = 2;

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

  String _monthToString(int month) {
    List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;

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
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              color: custom_colors.txtLightBlack,
                              fontSize: appHeight * 0.028,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: appHeight * 0.036,
                    ),
                    Container(
                      height: appHeight * 0.08,
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
                      child: PageView.builder(
                        controller: PageController(
                            viewportFraction: 0.2, initialPage: _currentIndex),
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          DateTime currentDate =
                              _baseDate.add(Duration(days: index - 2));

                          double opacity = (index == _currentIndex) ? 1.0 : 0.2;

                          return Opacity(
                            opacity: opacity,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${currentDate.day}",
                                    style: TextStyle(
                                        fontSize:
                                            appHeight * 0.001 * Sizes.size24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _monthToString(currentDate.month),
                                    style: TextStyle(
                                        fontSize:
                                            appHeight * 0.001 * Sizes.size18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: appHeight * 0.032,
                    ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: appHeight * 0.06,
                                horizontal: appWidth * 0.06),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$calorie Kcal',
                                  style: TextStyle(
                                    fontSize: appHeight * 0.035,
                                    fontWeight: FontWeight.w400,
                                    color: custom_colors.kcalGrey,
                                  ),
                                ),
                                SizedBox(
                                  height: appHeight * 0.02,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle,
                                      color: custom_colors.kcalGrey,
                                      size: appHeight * 0.01,
                                    ),
                                    SizedBox(
                                      width: appWidth * 0.01,
                                    ),
                                    Text(
                                      '섭취량',
                                      style: TextStyle(
                                          fontSize: appHeight * 0.01,
                                          fontWeight: FontWeight.w200,
                                          color: custom_colors.kcalGrey),
                                    ),
                                    SizedBox(
                                      width: appWidth * 0.1,
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: custom_colors.kcalGrey,
                                      size: appHeight * 0.01,
                                    ),
                                    SizedBox(
                                      width: appWidth * 0.01,
                                    ),
                                    Text(
                                      '운동량',
                                      style: TextStyle(
                                          fontSize: appHeight * 0.01,
                                          fontWeight: FontWeight.w200,
                                          color: custom_colors.kcalGrey),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: appHeight * 0.035,
                                ),
                                Center(
                                  child: Image.asset(
                                    'Images/Graph.png',
                                    width: appWidth,
                                    height: appHeight * 0.323,
                                    fit: BoxFit.fill,
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
      ),
    );
  }
}
