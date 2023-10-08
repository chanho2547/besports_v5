import 'package:besports_v5/constants/custom_colors.dart';
import 'package:besports_v5/constants/rGaps.dart';
import 'package:besports_v5/constants/rSizes.dart';
import 'package:besports_v5/features/search/widgets/workout_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const routeName = "/search";
  static const routeURL = "/search";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String workout_name = 'WORKOUT';

  final List<String> workoutsImages = [
    'Images/bench_press.png',
    'Images/shoulder_press.png',
    'Images/squat.png',
    'Images/lat_pull_down.png',
    'Images/cable_crossover.png',
    'Images/pec_deck_fly.png',
  ];
  final List<String> workouts = [
    "BENCH PRESS",
    "SHOULDER PRESS",
    "SQUAT",
    "LAT PULL DOWN",
    "CABLE CROSSOVER",
    "PEC DECK FLY",
  ];
  int currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  late RSizes s;
  late RGaps g;

  void _showWorkoutPicker(BuildContext context) {
    final List<String> workouts = [
      "Bench Press",
      "Shoulder Press",
      "Squat",
      "Lat Pull Down",
      "Cable Crossover",
      "Pec Deck Fly"
    ];

    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          int selectedIndex = 0; // Default to the first item
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: custom_colors.besportsGreen,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Select Workout',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              workout_name = workouts[selectedIndex];
                              currentPage = selectedIndex;
                              if (_pageController.hasClients) {
                                _pageController.animateToPage(
                                  selectedIndex,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              }
                            });
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '저장',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: custom_colors.besportsGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: CupertinoPicker(
                    onSelectedItemChanged: (int index) {
                      selectedIndex = index;
                      currentPage = index;
                    },
                    itemExtent: 60,
                    children: workouts
                        .map((workout) => Center(
                                child: Text(
                              workout,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w300),
                            )))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    s = RSizes(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);
    g = RGaps(
        MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return SafeArea(
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
                  Text(
                    'Search',
                    style: TextStyle(
                      color: custom_colors.backgroundLightBlack,
                      fontSize: s.hrSize028(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            g.vr03(),
            g.vr006(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: custom_colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: custom_colors.black.withOpacity(0.2),
                        offset: const Offset(0, 5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: s.wrSize50() + s.wrSize25(),
                    height: s.hrSize08(),
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: s.wrSize10()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'TRY',
                                  style: TextStyle(
                                    color: custom_colors.backgroundLightBlack,
                                    fontSize: s.hrSize015(),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                g.vr002(),
                                Text(
                                  '"$workout_name"',
                                  style: TextStyle(
                                    color: custom_colors.backgroundLightBlack,
                                    fontSize: s.hrSize02(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: s.wrSize02()),
                  child: Container(
                    width: s.hrSize08(),
                    height: s.hrSize08(),
                    decoration: BoxDecoration(
                      color: custom_colors.backgroundLightBlack,
                      borderRadius: BorderRadius.circular(45),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          _showWorkoutPicker(context);
                        },
                        iconSize: s.hrSize04(),
                        color: Colors.white,
                        icon: const Icon(Icons.search_outlined),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            g.vr04(),
            Expanded(
              child: PageView.builder(
                itemCount: workoutsImages.length,
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    workout_name = workouts[index];
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  bool isActive = currentPage == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: EdgeInsets.symmetric(
                      horizontal: isActive ? 0 : s.wrSize03(),
                      vertical: isActive ? s.hrSize02() : s.hrSize05(),
                    ),
                    child: workout_card(
                      image_path: workoutsImages[index],
                      onTap: () {
                        setState(() {
                          workout_name = workouts[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
