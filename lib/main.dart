import 'package:besports_v5/constants/sizes.dart';
import 'package:besports_v5/features/dashboard/dashboard_screen.dart';

import 'package:besports_v5/features/history/history_screen.dart';
import 'package:besports_v5/features/profile/profile_screen.dart';
import 'package:besports_v5/features/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Smooth Navigation with PageView',
      theme: ThemeData(primaryColor: Colors.green[700]),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  void _readNFC() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();

      if (!isAvailable) {
        // NFC를 사용할 수 없는 경우 처리
        return;
      }

      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          Map tagData = tag.data;
          Map tagNdef = tagData['ndef'];
          Map cachedMessage = tagNdef['cachedMessage'];
          Map records = cachedMessage['records'][0];
          Uint8List payload = records['payload'];
          String payloadAsString = String.fromCharCodes(payload);

          // 읽어온 NFC 텍스트 값으로 모달창을 표시
          _showNFCModal(context, payloadAsString);
        },
      );
    } catch (e) {
      print("NFC Error: $e");
    }
  }

  void _showNFCModal(BuildContext context, String message) {
    showTopModal(
      context: context,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          alignment: Alignment.topCenter,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  message,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _readNFC(); // NFC 읽기 시작
  }

  int _currentIndex = 0;
  final PageController _pageController = PageController();

  /////아래 showModalSheet은 현재 사용하지 않음
  // void _showModalSheet(BuildContext context) {
  //   HapticFeedback.lightImpact(); // 햅틱 피드백 호출
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent, // 배경색을 투명하게 설정
  //     isScrollControlled: true, // 스크롤이 제어되도록 설정
  //     useRootNavigator: true,

  //     builder: (builder) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.5, // 화면의 높이의 50%(절반)만큼 설정
  //         alignment: Alignment.bottomCenter, // 아래쪽에서 시작
  //         child: Container(
  //           padding: const EdgeInsets.all(20),
  //           decoration: const BoxDecoration(
  //             color: Colors.white, // 이 부분은 필요에 따라 조절하세요. 바텀 시트의 실제 배경색입니다.
  //             borderRadius: BorderRadius.only(
  //               // 상단의 모서리만 둥글게 합니다.
  //               topLeft: Radius.circular(20.0),
  //               topRight: Radius.circular(20.0),
  //             ),
  //           ),
  //           child: const Center(
  //               child: Text(
  //             "Tap to Start",
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           )),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(), // 스크롤 기능을 비활성화
        controller: _pageController,
        onPageChanged: (index) {
          HapticFeedback.lightImpact(); // 햅틱 피드백 호출
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          DashboardScreen(),
          SearchScreen(),
          HistoryScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        enableFeedback: true,
        backgroundColor: Colors.grey[100],
        selectedItemColor: Colors.grey[900], // 선택된 아이템의 색상
        unselectedItemColor: Colors.grey[500], // 선택되지 않은 아이템의 색상
        iconSize: Sizes.size28,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
          HapticFeedback.lightImpact();
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          'Page with ${color.toString()}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

void showTopModal({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  Navigator.of(context).push(_TopModalRoute(builder: builder));
}

class _TopModalRoute<T> extends PopupRoute<T> {
  _TopModalRoute({required this.builder});

  final WidgetBuilder builder;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.5);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Builder(builder: builder);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -1),
        end: const Offset(0, 0),
      ).animate(animation),
      child: child,
    );
  }
}
