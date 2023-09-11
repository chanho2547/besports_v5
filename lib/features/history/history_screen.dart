import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  static const routeName = '/history';
  static const routeURL = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int minute = 150;
  int calorie = 200;

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
    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF373737),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appHeight * 0.07),
        child: AppBar(
          backgroundColor: const Color(0xFF373737),
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'Images/logo_white.png',
              height: appHeight * 0.04,
              width: appWidth * 0.1,
              fit: BoxFit.fill,
            ),
          ),
          elevation: 0,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // 첫 번째 화면 (전체 화면을 덮는다)
            Container(
              height: appHeight,
              color: const Color(0xFF373737),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    appWidth * 0.01, appHeight * 0, appWidth * 0.01, 0),
                child: Column(
                  children: [
                    Container(
                      height: appHeight * 0.1, // 일반적인 AppBar의 높이
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    ),
                  ],
                ),
              ),
            ),

            // 두 번째 화면 (첫 번째 화면 위에 쌓는다)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: appHeight * 0.07,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isDetailsOnTop = true;
                  });
                },
                child: Container(
                  height: appHeight * 1,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: appHeight * 0.025,
                            left: appWidth * 0.09), // 조금 상단으로 올린다.
                        child: Column(
                          children: [
                            Text(
                              "Details",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: appHeight * 0.03,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: appWidth * 0.06,
                          vertical: appHeight * 0.02,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${_focusedDay.month}월 ${_focusedDay.day}일",
                                  style: TextStyle(
                                    fontSize: appHeight * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Run Time :$hours시간 $remainingMinutes분",
                                  style: TextStyle(
                                    fontSize: appHeight * 0.015,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.amber,
                                  ),
                                ),
                                Text(
                                  "Carlorie : $calorie Kcal",
                                  style: TextStyle(
                                    fontSize: appHeight * 0.015,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // 세 번째 화면 (두 번째 화면 위에 쌓는다)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              top: isDetailsOnTop ? appHeight * 0.78 : appHeight * 0.15,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isDetailsOnTop = false;
                  });
                },
                child: Container(
                  height: appHeight * 1,
                  decoration: const BoxDecoration(
                    color: Color(0xFF373737),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: appHeight * 0.025, left: appWidth * 0.09),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "History",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: appHeight * 0.03,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: appHeight * 0.01,
                            ),
                            Text(
                              'Run Time : $hours시간 $remainingMinutes분',
                              style: TextStyle(
                                fontSize: appHeight * 0.015,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Carlorie : $calorie Kcal',
                              style: TextStyle(
                                fontSize: appHeight * 0.015,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: appHeight * 0.05,
                      ),
                      Stack(
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
                                    SizedBox(
                                      height: appHeight * 0.008,
                                    ),
                                    Text(
                                      '${date.day}',
                                      style: TextStyle(
                                        fontSize: appHeight * 0.025,
                                        fontWeight: FontWeight.w800,
                                      ).copyWith(color: Colors.amber),
                                    ),
                                    SizedBox(
                                      height: appHeight * 0.001,
                                    ),
                                    Text(
                                      'TODAY',
                                      style: TextStyle(
                                        fontSize: appHeight * 0.015,
                                        color: Colors.amber,
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
                            rowHeight: appWidth * 0.135,
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              formatButtonDecoration: BoxDecoration(
                                color: Colors.amber, // 버튼의 색상을 변경
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              titleCentered:
                                  true, // If you don't want the format button
                              titleTextStyle: TextStyle(
                                  color: Colors
                                      .white, // Setting month/year text color to white
                                  fontSize: appHeight * 0.02,
                                  fontWeight: FontWeight.w600),
                              leftChevronIcon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.white), // Left arrow color
                              rightChevronIcon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white), // Right arrow color
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekendStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: appHeight * 0.015),
                              weekdayStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: appHeight * 0.015),
                            ),
                            calendarStyle: CalendarStyle(
                                // Customize the color of selected day's background
                                selectedDecoration: const BoxDecoration(
                                  color: Colors
                                      .amberAccent, // Set your desired color here
                                  shape: BoxShape
                                      .circle, // You can use other shapes like BoxShape.rectangle
                                ),
                                // Customize the color of weekend days' text
                                weekendTextStyle: TextStyle(
                                  color: Colors.red,
                                  fontSize: appHeight * 0.02,
                                ),
                                // Customize the color of other days' text
                                defaultTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: appHeight *
                                        0.02 // Set the color for other days here
                                    ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: appHeight * 0.02,
                                  fontWeight: FontWeight.w700,
                                )
                                // Customize other properties as needed...
                                ),
                            // Other options...
                          ),
                          Positioned(
                            top: appHeight * 0.008, // top 위치 조절
                            right: appWidth * 0.14, // 오른쪽에서 얼마나 떨어지게 할지 조절
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber, // 버튼의 색상
                              ),
                              child: const Text(
                                "Today",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _focusedDay = DateTime.now();
                                  _selectedDay = _focusedDay;
                                });
                              },
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
      ),
    );
  }
}
