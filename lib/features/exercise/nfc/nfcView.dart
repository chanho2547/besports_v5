import 'dart:io';
import 'dart:typed_data';
import 'package:app_settings/app_settings.dart';

import 'package:besports_v5/features/exercise/bluetooth_method/bluetoothView.dart';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCScreen extends StatefulWidget {
  const NFCScreen({super.key});

  static const routeName = '/nfc';
  static const routeURL = '/nfc';

  @override
  State<NFCScreen> createState() => _NFCScreenState();
}

class _NFCScreenState extends State<NFCScreen> {
  Color buttonColor = Colors.blue;
  Color pressedButtonColor = Colors.blue.shade100;
  String id = "회원";

  @override
  void initState() {
    super.initState();
    //id = widget.id; // initState 메서드에서 widget.id를 사용하여 id를 초기화합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onNFCButtonPressedDown(); // 첫 프레임이 그려진 후에 onNFCButtonPressedDown 함수를 호출합니다.
    });
  }

  String _handleNFCMessage(NfcTag tag) {
    try {
      Map tagData = tag.data;
      Map tagNdef = tagData['ndef'];
      Map cachedMessage = tagNdef['cachedMessage'];
      Map records = cachedMessage['records'][0];
      Uint8List payload = records['payload'];
      String payloadAsString = String.fromCharCodes(payload);

      return payloadAsString;
    } catch (e) {
      throw "NFC 데이터를 가져올 수 없습니다.";
    }
  }

  Future<void> onNFCButtonPressedDown() async {
    if (Platform.isAndroid) {
      await showDialog(
        context: context,
        builder: (context) =>
            _AndroidSessionDialog("Settng The Phone", _handleNFCMessage),
      );
    }
    if (!(await NfcManager.instance.isAvailable())) {
      if (Platform.isAndroid) {
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("오류"),
            content: const Text(
              "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.",
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);

                  AppSettings.openAppSettings();
                },
                child: const Text("설정", style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("확인", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        );

        return;
      }

      throw "NFC를 지원하지 않는 기기이거나 일시적으로 비활성화 되어 있습니다.";
    }
  }

  // void onNFCButtonPressedUp() {
  //   setState(() {
  //     buttonColor = Colors.blue;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                // Text(
                //   "$id 님\n반갑습니다!",
                //   style: const TextStyle(
                //     fontSize: 30,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // GestureDetector(
                //   onTapDown: (details) async {
                //     onNFCButtonPressedDown();
                //   },
                //   onTapUp: (details) {
                //     onNFCButtonPressedUp();
                //   },
                //   child: Container(
                //     width: 300,
                //     height: 300,
                //     decoration: BoxDecoration(
                //       shape: BoxShape.circle,
                //       color: buttonColor,
                //     ),
                //     child: const Center(
                //       child: Text(
                //         "NFC 연결 임시버튼",
                //         style: TextStyle(
                //           fontSize: 30,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const BluetoothConnection(),
                //       ),
                //     );
                //   },
                //   child: const Text("To TMP Page"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AndroidSessionDialog extends StatefulWidget {
  const _AndroidSessionDialog(this.alertMessage, this._handleNFCMessage);

  final String alertMessage;

  // final String Function(NfcTag tag) handleTag;

  final String Function(NfcTag tag) _handleNFCMessage;

  @override
  State<StatefulWidget> createState() => _AndroidSessionDialogState();
}

class _AndroidSessionDialogState extends State<_AndroidSessionDialog> {
  String? _alertMessage;
  String? _errorMessage;

  String? _result;

  @override
  void initState() {
    super.initState();

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        try {
          _result = widget._handleNFCMessage(tag);

          //setState(() => _alertMessage = "NFC 태그를 인식하였습니다.");
          print("_result : $_result");

          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              // builder: (context) => BluetoothConnection(),
              builder: (context) => BluetoothScreen(addr: _result!),
            ),
          );

          // showModalBottomSheet(
          //   context: context,
          //   builder: (context) => BluetoothScreen(addr: _result!),
          // );
        } catch (e) {
          await NfcManager.instance.stopSession();

          setState(() => _errorMessage = '$e');
        }
      },
    ).catchError((e) => setState(() => _errorMessage = '$e'));
  }

  @override
  void dispose() {
    NfcManager.instance.stopSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  width: 270, // 원하는 크기로 조절
                  height: 270, // 원하는 크기로 조절
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade800, // 원의 배경색. 필요에 따라 수정
                    border: Border.all(
                      color: Colors.white, // 원의 테두리 색상. 필요에 따라 수정
                      width: 5, // 원의 테두리 두께. 필요에 따라 수정
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "SETUP",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text("기기를 거치하면 자동으로",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const Text("운동 측정이 시작됩니다",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          )

          // if (_alertMessage == null && _errorMessage == null)
          //   const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
