import 'package:besports_v5/constants/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatePicker {
  static void showDatePicker(
    BuildContext context,
    DateTime startDate,
    Function(DateTime) onDateSelected,
    String mainTitle,
  ) {
    DateTime selectedDate = startDate;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 18,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: custom_colors.besportsGreen,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.21,
                          right: MediaQuery.of(context).size.width * 0.09,
                        ),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: Center(
                            child: Text(
                              mainTitle,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: TextButton(
                          onPressed: () {
                            onDateSelected(DateTime
                                .now()); // 날짜를 선택하면 onDateSelected를 호출하여 새로운 날짜 전달
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '오늘',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: custom_colors.besportsGreen,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.12,
                        child: TextButton(
                          onPressed: () {
                            onDateSelected(
                                selectedDate); // 날짜를 선택하면 onDateSelected를 호출하여 선택한 날짜 전달
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '저장',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: custom_colors.besportsGreen,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: startDate,
                  maximumDate: DateTime.now(),
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime newDate) {
                    selectedDate = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
