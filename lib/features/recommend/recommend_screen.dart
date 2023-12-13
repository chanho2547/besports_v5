import 'dart:ui';

import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/gaps.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:besports_v5/env.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'canvas/chat_bubble.dart';
import 'package:dart_openai/dart_openai.dart';

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

  // final openAI = OpenAI.instance.build(
  //     token: tokenApi,
  //     baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
  //     enableLog: true);

  // 질문을 받을 때 버튼을 누르면 항목을 선택해줄 매개변수
  final ValueNotifier<int> _selectGender = ValueNotifier<int>(-1);
  final ValueNotifier<int> _selectGoal = ValueNotifier<int>(-1);
  final ValueNotifier<int> _selectDivide = ValueNotifier<int>(-1);
  final ValueNotifier<List<int>> _selectPart = ValueNotifier<List<int>>([]);
  final ValueNotifier<int> _selectTime = ValueNotifier<int>(-1);

  // 질문 생성 시 버튼을 누를 때 단일 선택이 가능하도록 하는 함수
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
          if (type.value == typeChoice) {
            type.value = -1;
          } else {
            type.value = typeChoice;
          }
        });
      },
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: type.value == typeChoice
              ? custom_colors.besportsGreen
              : custom_colors.consumeLightGreen,
          borderRadius: BorderRadius.circular(s.hrSize007()),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: s.wrSize03(),
              fontWeight: FontWeight.w600,
              color: type.value == typeChoice
                  ? custom_colors.bgWhite
                  : custom_colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // 질문 생성 시 버튼을 누를 때 복수 선택이 가능하도록 하는 함수
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
          borderRadius: BorderRadius.circular(s.hrSize007()),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: s.wrSize03(),
              fontWeight: FontWeight.w600,
              color: type.value.contains(typeChoice)
                  ? custom_colors.bgWhite
                  : custom_colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // 질문의 답변을 받을 String
  String answerPrint = "";

  // 질문 생성기 (버튼을 누르면 String으로 변환된다.)
  String generateQuestion() {
    String goal = "";
    if (_selectGoal.value == 0) {
      goal = "to lose weight";
    } else if (_selectGoal.value == 1) {
      goal = "for muscle growth";
    } else if (_selectGoal.value == 2) {
      goal = "to maintain";
    } else if (_selectGoal.value == 3) {
      goal = "to enhance performance";
    }

    String gender = "";
    if (_selectGender.value == 0) {
      gender = "for a man";
    } else if (_selectGender.value == 1) {
      gender = "for a women";
    }

    String divide = "workout";
    if (_selectDivide.value == 0) {
      divide = "workout";
    } else if (_selectDivide.value == 1) {
      divide = "2-day split workout";
    } else if (_selectDivide.value == 2) {
      divide = "3-day split workout";
    } else if (_selectDivide.value == 3) {
      divide = "5-day split workout";
    }

    String part = "";
    if (_selectPart.value.contains(0)) {
      part += "arm, ";
    }
    if (_selectPart.value.contains(1)) {
      part += "chest, ";
    }
    if (_selectPart.value.contains(2)) {
      part += "lower-body, ";
    }
    if (_selectPart.value.contains(3)) {
      part += "back, ";
    }
    if (_selectPart.value.contains(4)) {
      part += "shoulder, ";
    }

    String time = "";
    if (_selectTime.value == 0) {
      time = "for 30 minutes or less per day";
    } else if (_selectTime.value == 1) {
      time = "for an hour per day";
    } else if (_selectTime.value == 2) {
      time = "for an hour and half per day";
    } else if (_selectTime.value == 3) {
      time = "for 2 hours or more per day";
    }

    if (part.endsWith(", ")) {
      part = part.substring(0, part.length - 2);
    }
    String prompt = 'Recommend $part $divide $gender to do $goal $time';

    return prompt;
  }

  Future<String> chatGpt(String prompt) async {
    OpenAI.apiKey = "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";

    final completion = await OpenAI.instance.completion.create(
      model: "text-davinci-003",
      prompt: prompt,
    );

    return completion.choices[0].text;
  }

  // Future<String> chatComplete(String question) async {
  //   final request = ChatCompleteText(
  //       messages: [Messages(role: Role.user, content: 'Hello')],
  //       maxToken: 200,
  //       model: GptTurboChatModel());

  //   String answer = "";

  //   final response = await openAI.onChatCompletion(request: request);
  //   for (var element in response!.choices) {
  //     debugPrint("data -> ${element.message?.content}");
  //     answer += element.message!.content;
  //   }
  //   return answer;
  // }

  @override
  Widget build(BuildContext context) {
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return SafeArea(
      // 헤더파일
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

                  // 화면 제목
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

            // 화면에 뜨는 버튼 -> 질문 생성 가능
            g.vr01(),
            Row(
              children: [
                SizedBox(
                  width: s.wrSize16(),
                  child: Text(
                    "성별 :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                selectButton(
                  type: _selectGender,
                  typeChoice: 0,
                  w: s.wrSize37(),
                  h: s.hrSize05(),
                  text: "남자",
                ),
                g.hr05(),
                selectButton(
                  type: _selectGender,
                  typeChoice: 1,
                  w: s.wrSize37(),
                  h: s.hrSize05(),
                  text: "여자",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: s.wrSize14(),
                  child: Text(
                    "목적 :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
                  text: "체중유지",
                ),
                selectButton(
                  type: _selectGoal,
                  typeChoice: 3,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "수행능력 향상",
                ),
              ],
            ),
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: s.wrSize14(),
                  child: Text(
                    "분할 :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
                SizedBox(
                  width: s.wrSize12(),
                  child: Text(
                    "부위 :\n(복수선택)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
            g.vr01(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: s.wrSize14(),
                  child: Text(
                    "운동시간 :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: s.wrSize023(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                selectButton(
                  type: _selectTime,
                  typeChoice: 0,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "30분 이하",
                ),
                selectButton(
                  type: _selectTime,
                  typeChoice: 1,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "1시간",
                ),
                selectButton(
                  type: _selectTime,
                  typeChoice: 2,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "1시간 30분",
                ),
                selectButton(
                  type: _selectTime,
                  typeChoice: 3,
                  w: s.wrSize20(),
                  h: s.hrSize05(),
                  text: "2시간 이상",
                ),
              ],
            ),

            // 운동 추천 버튼 -> 누르면 질문 생성 후 -> 위의 함수를 통해 Open AI에 보냄
            g.vr03(),
            Center(
              child: GestureDetector(
                onTap: () async {
                  String prompt = generateQuestion();
                  String answer = await chatGpt(prompt);
                  setState(() {
                    answerPrint = answer;
                  });
                },
                child: Container(
                  width: s.wrSize40(),
                  height: s.hrSize04(),
                  decoration: BoxDecoration(
                    color: custom_colors.besportsGreen,
                    borderRadius: BorderRadius.circular(s.hrSize03()),
                  ),
                  child: Center(
                    child: Text(
                      "운동 추천받기",
                      style: TextStyle(
                          fontSize: s.hrSize015(),
                          fontWeight: FontWeight.w700,
                          color: custom_colors.bgWhite),
                    ),
                  ),
                ),
              ),
            ),

            // 질문 출력
            g.vr05(),
            // loading이 끝나면 답변 생성 후 ChatBubble을 통해 답변 출력
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: s.wrSize08(),
              ),
              child: Center(
                // ChatBubble -> 답변 생성 Canvas (chat_bubble.dart라는 파일 만들어서 import)
                child: ChatBubble(
                  child: Text(
                    answerPrint,
                    style: TextStyle(
                      fontSize: s.hrSize015(),
                      fontWeight: FontWeight.w500,
                    ),
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
