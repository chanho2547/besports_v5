import 'package:besports_v5/constants/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '_date_picker.dart';

late RSizes s;
late RGaps g;

class BottomSheetOptions extends StatefulWidget {
  final List<String> options;
  final String initialValue;
  final Function(String, bool) onSelected;

  const BottomSheetOptions({
    super.key,
    required this.options,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  _BottomSheetOptionsState createState() => _BottomSheetOptionsState();
}

class _BottomSheetOptionsState extends State<BottomSheetOptions> {
  late String temp;
  DateTime? customStartDate;
  DateTime? customEndDate;
  bool isDateRangeValid = true;

  @override
  void initState() {
    super.initState();
    temp = widget.initialValue;
    customStartDate = DateTime.now().subtract(const Duration(days: 7));
    customEndDate = DateTime.now();
  }

  void _showStartDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      customStartDate!,
      (DateTime newDate) {
        setState(() {
          customStartDate = newDate;
        });
      },
      "Start Date",
    );
  }

  void _showEndDatePicker(BuildContext context) {
    DatePicker.showDatePicker(
      context,
      customEndDate!,
      (DateTime newDate) {
        setState(() {
          customEndDate = newDate;
        });
      },
      "End Date",
    );
  }

  void _showAlert({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("확인"),
            ),
          ],
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

    return Container(
      height: s.hrSize20(),
      decoration: const BoxDecoration(
        color: custom_colors.backgroundLightBlack,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                ),
                color: custom_colors.white,
                iconSize: s.hrSize02(),
              ),
              IconButton(
                onPressed: () {
                  if (temp == "Custom" &&
                      (customStartDate!.isAfter(customEndDate!))) {
                    _showAlert(
                        title: "날짜 오류", message: "시작하는 날을 종료되는 날보다 빠르게 설정해주세요");
                  } else if (temp == "Custom") {
                    widget.onSelected(
                        "${DateFormat('yyyy.MM.dd').format(customStartDate!)} - ${DateFormat('yyyy.MM.dd').format(customEndDate!)}",
                        true);
                  } else {
                    widget.onSelected(temp, false);
                  }
                  Navigator.pop(context);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.check,
                ),
                color: custom_colors.white,
                iconSize: s.hrSize02(),
              ),
            ],
          ),
          SizedBox(
            height: s.hrSize05(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.options.map((option) {
                bool isSelected = option == temp;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      temp = option;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: s.maxWidth() / 5,
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: isSelected
                          ? custom_colors.besportsGreen
                          : custom_colors.unselectedGrey,
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? custom_colors.white
                              : custom_colors.black.withOpacity(0.5),
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          if (temp == "Custom")
            Column(
              children: [
                g.vr02(),
                SizedBox(
                  height: s.hrSize045(),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _showStartDatePicker(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            color: custom_colors.besportsGreen,
                            height: s.hrSize04(),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('yyyy.MM.dd')
                                        .format(customStartDate!),
                                    style: TextStyle(
                                        fontSize: s.hrSize02(),
                                        fontWeight: FontWeight.w600,
                                        color: custom_colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          " - ",
                          style: TextStyle(
                              fontSize: s.hrSize02(),
                              fontWeight: FontWeight.w600,
                              color: custom_colors.white),
                        ),
                        GestureDetector(
                          onTap: () => _showEndDatePicker(context),
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            color: custom_colors.besportsGreen,
                            height: s.hrSize04(),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('yyyy.MM.dd')
                                        .format(customEndDate!),
                                    style: TextStyle(
                                        fontSize: s.hrSize02(),
                                        fontWeight: FontWeight.w600,
                                        color: custom_colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
