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
  static int setCount = 4;
  ValueNotifier<String> receivedDataNotifier = ValueNotifier<String>("");

  NavigationCallback? onNavigateToHome;

  StreamSubscription? _connectionSubscription;

  BluetoothViewModel({required this.deviceAddr});

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
          final charToSubscribe = QualifiedCharacteristic(
              characteristicId: characteristic.characteristicId,
              serviceId: service.serviceId,
              deviceId: device.id);
          _flutterReactiveBle
              .subscribeToCharacteristic(charToSubscribe)
              .listen((value) {
            String receivedData = utf8.decode(value);
            receivedDataNotifier.value = receivedData;
            print("Received string from device: $receivedData");
            _updateCount();
            print("count 업데이트");
          });
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
        _discoverAndSubscribe(device); // 서비스 및 캐릭터리스틱 검색 및 구독
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        // 연결이 끊어졌을 때 재스캔
        _startScanning();
      }
    }, onError: (error) {
      // 에러 발생 시 재스캔 시작
      _startScanning();
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
  void _updateCount() {
    countNotifier.value--;

    if (countNotifier.value == 0) {
      _debounceTimer = Timer(const Duration(microseconds: 300), () {
        countNotifier.value = 5;
      });
      //onNavigateToHome?.call();
    }
  }

  void _updateData() {}

  // dispose 메서드
  void dispose() {
    print('모델이 해제되었습니다.');
    disconnect(); // 자원 해제 추가
    _debounceTimer?.cancel();
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
