import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../functions/_date_picker.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<String> options = ["5 days", "Week", "2 Weeks", "Month", "Custom"];
  String selectedOption = "Week";
  bool isCustom = false;

  String formatCustomDates(DateTime start, DateTime end) {
    return "${DateFormat('yyyy.MM.dd').format(start)} - ${DateFormat('yyyy.MM.dd').format(end)}";
  }

  @override
  Widget build(BuildContext context) {
    final double appWidth = MediaQuery.of(context).size.width;
    final double appHeight = MediaQuery.of(context).size.height;

    void _showOptions() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return BottomSheetOptions(
            options: options,
            initialValue: selectedOption,
            onSelected: (value, isCurrentCustom) {
              setState(() {
                selectedOption = value;
                isCustom = isCurrentCustom;
              });
            },
          );
        },
      );
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: appHeight * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isCustom)
                const Text(
                  "This",
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (!isCustom)
                SizedBox(
                  width: appWidth * 0.025,
                ),
              GestureDetector(
                onTap: _showOptions,
                child: Row(
                  children: [
                    const Icon(FontAwesomeIcons.caretDown),
                    Text(
                      selectedOption,
                      style: TextStyle(
                        fontSize: isCustom ? 15 : 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: appWidth * 0.025,
              ),
              const Text(
                "Workouts",
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;

    double flexibleHeight =
        (temp == "Custom") ? appHeight * 0.2 : appHeight * 0.15;
    return SizedBox(
      height: flexibleHeight,
      child: Column(
        children: [
          if (temp == "Custom")
            Column(
              children: [
                SizedBox(
                  height: appHeight * 0.045,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _showStartDatePicker(context),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            height: appHeight * 0.04,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('yyyy.MM.dd')
                                        .format(customStartDate!),
                                    style: TextStyle(
                                      fontSize: appHeight * 0.02,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text(
                          " - ",
                          style: TextStyle(
                            fontSize: appHeight * 0.02,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showEndDatePicker(context),
                          child: Container(
                            padding: const EdgeInsets.all(4.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                            height: appHeight * 0.04,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('yyyy.MM.dd')
                                        .format(customEndDate!),
                                    style: TextStyle(
                                      fontSize: appHeight * 0.02,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                Divider(
                  height: appHeight * 0.005,
                  color: Colors.black,
                ),
              ],
            ),
          SizedBox(
            height: appHeight * 0.05,
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
                    width: appWidth / 5,
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black : Colors.transparent,
                      border: isSelected
                          ? Border.all(color: Colors.black, width: 2.0)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black.withOpacity(0.5),
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
          Container(
            margin: EdgeInsets.only(
              left: appWidth * 0.3,
              right: appWidth * 0.3,
            ),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (temp == "Custom") {
                  widget.onSelected(
                      "${DateFormat('yyyy.MM.dd').format(customStartDate!)} - ${DateFormat('yyyy.MM.dd').format(customEndDate!)}",
                      true);
                } else {
                  widget.onSelected(temp, false);
                }
                Navigator.pop(context);
              },
              child: const Text("Select"),
            ),
          ),
        ],
      ),
    );
  }
}
