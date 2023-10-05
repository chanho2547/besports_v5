import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/gaps.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  static const routeName = '/history';
  static const routeURL = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  int minute = 150;
  int calorie = 200;

  late RSizes s;
  late RGaps g;

  late int hours = minute ~/ 60;
  late int remainingMinutes = minute % 60;

  late DateTime _selectedDay;
  late DateTime _focusedDay;

  bool isDetailsOnTop = false;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: custom_colors.backgroundLightBlack,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(s.hrSize07()),
        child: AppBar(
          backgroundColor: custom_colors.backgroundLightBlack,
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'Images/logo_white.png',
              height: s.hrSize04(),
              width: s.wrSize10(),
              fit: BoxFit.fill,
            ),
          ),
          elevation: 0,
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: s.maxHeight(),
            color: custom_colors.backgroundLightBlack,
            child: Padding(
              padding: EdgeInsets.fromLTRB(s.wrSize01(), 0, s.wrSize01(), 0),
              child: Column(
                children: [
                  Container(
                    height: s.hrSize10(), // 일반적인 AppBar의 높이
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: s.hrSize04(),
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isDetailsOnTop = true;
                });
              },
              child: Container(
                height: s.maxHeight(),
                decoration: const BoxDecoration(
                  color: custom_colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: s.hrSize025(),
                          left: s.wrSize09()), // 조금 상단으로 올린다.
                      child: Column(
                        children: [
                          Text(
                            "Details",
                            style: TextStyle(
                              color: custom_colors.black,
                              fontSize: s.hrSize03(),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: s.wrSize06(),
                        vertical: s.hrSize02(),
                      ),
                      child: Column(children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_focusedDay.month}월 ${_focusedDay.day}일",
                              style: TextStyle(
                                fontSize: s.hrSize03(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Run Time : $hours시간 $remainingMinutes분",
                              style: TextStyle(
                                fontSize: s.hrSize015(),
                                fontWeight: FontWeight.w500,
                                color: custom_colors.backgroundLightBlack,
                              ),
                            ),
                            Text(
                              "Carlorie : $calorie Kcal",
                              style: TextStyle(
                                fontSize: s.hrSize015(),
                                fontWeight: FontWeight.w500,
                                color: custom_colors.backgroundLightBlack,
                              ),
                            ),
                          ],
                        ),
                        g.vr03(),
                        Center(
                          child: Image.asset(
                            'Images/Graph.png',
                            width: s.maxWidth(),
                            height: s.hrSize32() + s.hrSize003(),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: custom_colors.besportsGreen,
                                  size: s.hrSize015(),
                                ),
                                g.hr015(),
                                Text(
                                  '운동량',
                                  style: TextStyle(
                                      fontSize: s.hrSize018(),
                                      fontWeight: FontWeight.w300,
                                      color:
                                          custom_colors.backgroundLightBlack),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: custom_colors.consumeLightGreen,
                                  size: s.hrSize015(),
                                ),
                                g.hr015(),
                                Text(
                                  '섭취량',
                                  style: TextStyle(
                                      fontSize: s.hrSize018(),
                                      fontWeight: FontWeight.w300,
                                      color:
                                          custom_colors.backgroundLightBlack),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: isDetailsOnTop ? s.hrSize70() + s.hrSize05() : s.hrSize13(),
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isDetailsOnTop = false;
                });
              },
              child: Container(
                height: s.maxHeight(),
                decoration: const BoxDecoration(
                  color: custom_colors.backgroundLightBlack,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: s.hrSize025(), left: s.wrSize09()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "History",
                            style: TextStyle(
                              color: custom_colors.white,
                              fontSize: s.hrSize03(),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: s.hrSize01(),
                          ),
                          Visibility(
                            visible: !isDetailsOnTop,
                            child: Column(
                              children: [
                                Text(
                                  'Run Time : $hours시간 $remainingMinutes분',
                                  style: TextStyle(
                                    fontSize: s.hrSize015(),
                                    color: custom_colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Carlorie : $calorie Kcal',
                                  style: TextStyle(
                                    fontSize: s.hrSize015(),
                                    color: custom_colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    g.vr01(),
                    Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.utc(2021, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,

                          calendarBuilders: CalendarBuilders(
                            todayBuilder: (context, date, _) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  g.vr008(),
                                  Text('${date.day}',
                                      style: TextStyle(
                                        fontSize: s.hrSize02(),
                                        fontWeight: FontWeight.w800,
                                      ).copyWith(
                                        color: Colors.green,
                                      )),
                                  g.vr001(),
                                  Text(
                                    'TODAY',
                                    style: TextStyle(
                                      fontSize: s.hrSize015(),
                                      color: Colors.green,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),

                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          rowHeight: s.wrSize12(),
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            formatButtonDecoration: BoxDecoration(
                              color: custom_colors
                                  .backgroundDarkWhite, // 버튼의 색상을 변경
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            titleCentered:
                                true, // If you don't want the format button
                            titleTextStyle: TextStyle(
                                color: custom_colors
                                    .white, // Setting month/year text color to white
                                fontSize: s.hrSize02(),
                                fontWeight: FontWeight.w600),
                            leftChevronIcon: const Icon(Icons.arrow_back_ios,
                                color: custom_colors.white), // Left arrow color
                            rightChevronIcon: const Icon(
                                Icons.arrow_forward_ios,
                                color:
                                    custom_colors.white), // Right arrow color
                          ),
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekendStyle: TextStyle(
                                color: custom_colors.weekendRed,
                                fontSize: s.hrSize015()),
                            weekdayStyle: TextStyle(
                                color: custom_colors.white,
                                fontSize: s.hrSize015()),
                          ),
                          calendarStyle: CalendarStyle(
                              // Customize the color of selected day's background
                              selectedDecoration: BoxDecoration(
                                color: Colors
                                    .grey[400], // Set your desired color here
                                shape: BoxShape
                                    .circle, // You can use other shapes like BoxShape.rectangle
                              ),
                              // Customize the color of weekend days' text
                              weekendTextStyle: TextStyle(
                                color: custom_colors.weekendRed,
                                fontSize: s.hrSize02(),
                              ),
                              // Customize the color of other days' text
                              defaultTextStyle: TextStyle(
                                color: custom_colors.white,
                                fontSize: s.hrSize02(),
                                // Set the color for other days here
                              ),
                              selectedTextStyle: TextStyle(
                                color: custom_colors.black,
                                fontSize: s.hrSize02(),
                                fontWeight: FontWeight.w700,
                              )
                              // Customize other properties as needed...
                              ),
                          // Other options...
                        ),
                        g.vr06(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _focusedDay = DateTime.now();
                              _selectedDay = _focusedDay;
                            });
                          },
                          child: Container(
                            width: s.wrSize25(),
                            height: s.hrSize04(),
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
                            child: const Center(
                              child: Text(
                                "TODAY",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: custom_colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
