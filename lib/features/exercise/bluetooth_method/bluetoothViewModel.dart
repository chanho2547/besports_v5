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
  int setCount = 4;
  final int _count = 5;
  bool isRest = false;
  static int retryCount = 0; // 재시도 횟수
  final int maxRetry = 5; // 최대 재시도 횟수

  ValueNotifier<String> receivedDataNotifier = ValueNotifier<String>("");

  NavigationCallback? onNavigateToHome;

  StreamSubscription? _connectionSubscription;

  BluetoothViewModel({required this.deviceAddr});

  late final QualifiedCharacteristic _charToSubscribe;
  late QualifiedCharacteristic _charToWrite;

  bool isPaused = false; // 카운트 일시 중지 상태

  // 초기화 메서드
  void initialize() async {
    // 이전 연결/스캔 구독 및 타이머 해제
    disconnect();
    _debounceTimer?.cancel();
    _scanSubscription?.cancel();

    countNotifier.value = 5; // 카운터 초기화
    connectedDevices.clear(); // 연결된 장치 목록 초기화

    _startScanning(); // 스캔 시작 메서드 호출
  }

  int get count => _count;
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
    final services = await _flutterReactiveBle.discoverServices(device.id);
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.isNotifiable) {
          // 알림 활성화
          _charToSubscribe = QualifiedCharacteristic(
              characteristicId: characteristic.characteristicId,
              serviceId: service.serviceId,
              deviceId: device.id);
          _flutterReactiveBle
              .subscribeToCharacteristic(_charToSubscribe)
              .listen((value) {
            String receivedData = utf8.decode(value);
            //_writeDataToDevice();
            _onNewDataReceived(receivedData, device);
          });
        }
        if (characteristic.isWritableWithoutResponse ||
            characteristic.isWritableWithResponse) {
          _charToWrite = QualifiedCharacteristic(
              characteristicId: characteristic.characteristicId,
              serviceId: service.serviceId,
              deviceId: device.id);
          writeDataToDevice("\$wr;");
        }
      }
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
        retryCount = 0; // 연결에 성공하면 재시도 횟수 초기화
        _discoverAndSubscribe(device); // 서비스 및 캐릭터리스틱 검색 및 구독
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        // 연결이 끊어졌을 때 재스캔
        _startScanning();
      }
    }, onError: (error) {
      // 에러 발생 시
      print("Connection error: $error"); // 에러 로깅
      if (retryCount < maxRetry) {
        _startScanning();
        retryCount++;
      } else {
        // 사용자에게 에러 알림 (구현은 여기에 추가)
        print("Max retry attempts reached.");
      }
    });
  }

  // 연결 해제 메서드
  void disconnect() async {
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

  // 디바운스된 카운터 업데이트 메서드
  void _updateCount(DiscoveredDevice device) async {
    if (!isRest) {
      // rest 상태가 아닐 때만 카운트 감소
      countNotifier.value--;
    }

    if (countNotifier.value == 0) {
      _debounceTimer = Timer(const Duration(microseconds: 300), () {
        countNotifier.value = 5;
      });
      //onNavigateToHome?.call();
    }
  }

  void _onNewDataReceived(String receivedData, DiscoveredDevice device) {
    // 데이터 수신 시 호출될 함수
    receivedDataNotifier.value = receivedData;
    print("Received string from device: $receivedData");
    _updateCount(device);
    print("count 업데이트");
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

  void setRestState(bool isRest) {
    this.isRest = isRest;
  }

  void setCountSet(int setCount) {
    this.setCount = setCount;
  }

  int getSetCount() {
    return setCount;
  }

  void minusSetCount() {
    --setCount;
  }

  // dispose 메서드
  void dispose() {
    print('모델이 해제되었습니다.');
    disconnect(); // 자원 해제 추가
    _debounceTimer?.cancel();
    MyHomePageState.isModal = false;
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
