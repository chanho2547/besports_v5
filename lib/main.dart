import 'package:besports_v5/constants/sizes.dart';
import 'package:besports_v5/features/dashboard/dashboard_screen.dart';
import 'package:besports_v5/features/exercise/bluetooth_method/bluetoothView.dart';
import 'package:besports_v5/constants/staticStatus.dart';
import 'package:besports_v5/features/dashboard/Screens/bottomModalView.dart';
import 'package:besports_v5/features/history/history_screen.dart';
import 'package:besports_v5/features/profile/profile_screen.dart';
import 'package:besports_v5/features/recommend/recommend_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';

void myTask() {
  print('my task is running');
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _readNFC(); // NFC 읽기 시작
  }

  bool isReadingNfc = false; // NFC를 읽고 있는지 여부를 저장하는 변수 추가

  void _readNFC() async {
    if (isReadingNfc) return; // 이미 NFC를 읽고 있으면 return
    isReadingNfc = true; // NFC 읽기 시작 상태로 설정

    try {
      if (!BoolStatus.isModal) {
        bool isAvailable = await NfcManager.instance.isAvailable();

        if (!isAvailable) {
          isReadingNfc = false; // NFC 읽기 종료 상태로 설정
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

            _showNFCModal(context, payloadAsString);

            await Future.delayed(const Duration(
                seconds: 10)); // 10초 동안 딜레이를 준 후 NFC를 다시 읽을 수 있도록 함
            isReadingNfc = false; // 딜레이가 끝나면 NFC 읽기 종료 상태로 설정
          },
        );
      } else {
        isReadingNfc = false; // NFC 읽기 종료 상태로 설정
        return;
      }
    } catch (e) {
      isReadingNfc = false; // NFC 읽기 종료 상태로 설정
      print("NFC Error: $e");
    }
  }

  void _showNFCModal(BuildContext context, String message) async {
    if (!BoolStatus.isModal) {
      HapticFeedback.vibrate; // 햅틱 피드백 호출
      showTopModal(
        context: context,
        builder: (builder) {
          return FractionallySizedBox(
            heightFactor: 0.85,
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: BluetoothScreen(
                addr: message,
                onDispose: _readNFC, // 여기서 콜백 연결
              ),
            ),
          );
        },
        onClose: _readNFC, // 모달이 닫힐 때 호출될 콜백으로 _readNFC를 전달
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(), // 스크롤 기능을 비활성화
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          DashboardScreen(),
          // SearchScreen(),
          RecommendScreen(),
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
          HapticFeedback.lightImpact(); // 햅틱 피드백 호출
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
              icon: Icon(Icons.calendar_month), label: 'Calendar'),
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
