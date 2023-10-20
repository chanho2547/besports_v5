import 'package:besports_v5/IO/mapFileIO.dart';
import 'package:besports_v5/IO/user.dart';
import 'package:besports_v5/IO/userFileIO.dart';
import 'package:besports_v5/constants/staticStatus.dart';
import 'package:besports_v5/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';
import 'dart:convert';

typedef NavigationCallback = void Function();

class BluetoothViewModel {
  final FlutterReactiveBle _flutterReactiveBle = FlutterReactiveBle();
  final String deviceAddr;
  ValueNotifier<int> countNotifier = ValueNotifier<int>(0);
  final Set<String> connectedDevices = {};
  StreamSubscription? _scanSubscription;
  Timer? _debounceTimer;
  int _setCount = 4;
  final int _count = 5;
  bool _isRest = false;
  static int _retryCount = 0; // 재시도 횟수
  final int _maxRetry = 5; // 최대 재시도 횟수

  List<Map<String, int>> lawDatas = [];
  Map<String, int> lawData = {};
  ValueNotifier<String> receivedDataNotifier = ValueNotifier<String>("");
  NavigationCallback? onNavigateToHome;
  StreamSubscription? _connectionSubscription;
  BluetoothViewModel({required this.deviceAddr});
  late final QualifiedCharacteristic _charToSubscribe;
  late QualifiedCharacteristic _charToWrite;
  final MapFileIO _mapFileIO = MapFileIO();

  bool isPaused = false; // 카운트 일시 중지 상태

  int get count => _count;
  int get setCount => _setCount;
  bool get isRset => _isRest;
  void pushData() {
    lawDatas.add(lawData);
    lawData.clear();
  }

  set setCountSet(int value) => _setCount = value;
  set setRestState(bool isRest) => _isRest = isRest;
  void minusSetCount() {
    --_setCount;
  }

  // 초기화 메서드
  void initialize() async {
    // 이전 연결/스캔 구독 및 타이머 해제
    _disconnect();
    _debounceTimer?.cancel();
    _scanSubscription?.cancel();

    countNotifier.value = 5; // 카운터 초기화
    connectedDevices.clear(); // 연결된 장치 목록 초기화

    _startScanning(); // 스캔 시작 메서드 호출
  }

  // 장치 스캔 시작 메서드
  void _startScanning() {
    _scanSubscription = _flutterReactiveBle.scanForDevices(
      withServices: [],
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      if (device.id == deviceAddr.substring(3) &&
          !connectedDevices.contains(device.id)) {
        _scanSubscription?.cancel(); // 스캔 중단
        _connectToDevice(device); // 디바이스 연결 시도
      }
    });
  }

  void _discoverAndSubscribe(DiscoveredDevice device) async {
    // 서비스 검색
    await _flutterReactiveBle.discoverAllServices(device.id);

    // 검색된 서비스 가져오기
    final services = await _flutterReactiveBle.getDiscoveredServices(device.id);

    for (final service in services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.isNotifiable) {
          // 알림 활성화
          _charToSubscribe = QualifiedCharacteristic(
              characteristicId: characteristic.id,
              serviceId: service.id,
              deviceId: device.id);

          // 알림 구독 (신)
          // _connectionSubscription = _flutterReactiveBle
          //     .subscribeToCharacteristic(_charToSubscribe)
          //     .listen((value) {
          //   print("this is value _connectionSubscription : $value");
          //   String receivedData = utf8.decode(value);
          //   _onNewDataReceived(receivedData, device);
          // });

          // 알림 구독 (구)
          _flutterReactiveBle
              .subscribeToCharacteristic(_charToSubscribe)
              .listen((value) {
            print("this is value : $value");

            String receivedData = utf8.decode(value);
            _onNewDataReceived(receivedData, device);
          });
        }
        if (characteristic.isWritableWithoutResponse ||
            characteristic.isWritableWithResponse) {
          _charToWrite = QualifiedCharacteristic(
              characteristicId: characteristic.id,
              serviceId: service.id,
              deviceId: device.id);
          writeDataToDevice("\$wr;");
        }
      }
    }
  }

  //오류처리 코드
  void _retryConnection() {
    if (_retryCount < _maxRetry) {
      _startScanning();
      _retryCount++;
    } else {
      // 사용자에게 에러 알림 (구현은 여기에 추가)
      print("Max retry attempts reached.");
    }
  }

  // 디바이스 연결 메서드
  void _connectToDevice(DiscoveredDevice device) {
    _connectionSubscription = _flutterReactiveBle
        .connectToDevice(
      id: device.id,
      connectionTimeout: const Duration(seconds: 5),
    )
        .listen((connectionState) async {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        _retryCount = 0; // 연결에 성공하면 재시도 횟수 초기화
        _discoverAndSubscribe(device); // 서비스 및 캐릭터리스틱 검색 및 구독
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        // 연결이 끊어졌을 때 재스캔
        _startScanning();
      }
    }, onError: (error) {
      // 에러 발생 시
      print("Connection error: $error"); // 에러 로깅
      _retryConnection(); // 오류 발생 시 재시도 로직 호출
    });
  }

  void _onNewDataReceived(String receivedData, DiscoveredDevice device) {
    // 데이터 수신 시 호출될 함수
    lawData.putIfAbsent(receivedData, () => 0);
    lawData[receivedData] = lawData[receivedData]! + 1;
    receivedDataNotifier.value = receivedData;
    print("Received string from device: $receivedData");
    _updateCount(device);
    print("count 업데이트");
  }

  // 디바운스된 카운터 업데이트 메서드
  void _updateCount(DiscoveredDevice device) {
    if (_debounceTimer?.isActive ?? false) {
      // 디바운싱 중이라면 더 이상 로직을 진행하지 않습니다.
      return;
    }

    if (!_isRest) {
      // rest 상태가 아닐 때만 카운트 감소
      countNotifier.value--;
    }

    if (countNotifier.value == 0) {
      countNotifier.value = 5;
    }

    // 디바운스 타이머 설정
    _debounceTimer = Timer(const Duration(milliseconds: 0), () {
      // 이 타이머가 실행되는 동안 _updateCount는 더 이상 진행되지 않습니다.
    });
  }

  Future<void> writeDataToDevice(String text) async {
    final List<int> byte = utf8.encode(text);
    try {
      await _flutterReactiveBle.writeCharacteristicWithoutResponse(_charToWrite,
          value: byte);
    } catch (e) {
      print("Characteristic write failed: $e");
      // 필요한 경우 여기에서 재시도 로직을 추가하십시오.
    }
  }

  // 연결 해제 메서드
  void _disconnect() async {
    if (_connectionSubscription != null) {
      await _connectionSubscription!.cancel();
      _connectionSubscription = null;
    }
    if (_scanSubscription != null) {
      await _scanSubscription!.cancel();
      _scanSubscription = null;
    }
    if (connectedDevices.contains(deviceAddr.substring(3))) {
      _flutterReactiveBle.clearGattCache(deviceAddr.substring(3));
      connectedDevices.remove(deviceAddr.substring(3));
    }
  }

  void _saveData() {
    UserFileIO fileIO = UserFileIO();
    ExerciseSession session = ExerciseSession(
        machineName: _mapFileIO.keyToValue(deviceAddr)!, // 실제 기계 이름으로 변경 필요
        weightToCountPerSet: lawDatas);
    fileIO.addExerciseSession(DateTime.now(), session);
  }

  // dispose 메서드
  void dispose() {
    _saveData();
    _setCount = 4;
    _disconnect(); // 자원 해제 추가
    _debounceTimer?.cancel();
    BoolStatus.isModal = false;
    print("isModal: false");
  }
}

class CustomEvent {
  final int value;

  CustomEvent(this.value);

  @override
  String toString() {
    return 'CustomEvent(value: $value)';
  }
}
