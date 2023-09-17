import 'package:besports_v5/constants/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Graph2Screen extends StatelessWidget {
  int calorie = 432;

  Graph2Screen({super.key});
  @override
  Widget build(BuildContext context) {
    final double appHeight = MediaQuery.of(context).size.height;
    final double appWidth = MediaQuery.of(context).size.width;
    return Container(
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
                vertical: appHeight * 0.06, horizontal: appWidth * 0.06),
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
    );
  }
}
