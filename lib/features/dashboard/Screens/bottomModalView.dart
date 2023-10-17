import 'package:besports_v5/features/exercise/bluetooth_method/bluetoothView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NFCView extends StatefulWidget {
  final String payload;
  const NFCView({Key? key, required this.payload}) : super(key: key);

  @override
  _NFCViewState createState() => _NFCViewState();
}

class _NFCViewState extends State<NFCView> {
  // NFC 읽기 기능은 MyHomePageState 클래스로 옮겨졌으므로 여기서는 삭제됩니다.

  @override
  Widget build(BuildContext context) {
    // 필요에 따라 NFCView에서 보여주고 싶은 UI 요소들을 추가할 수 있습니다.
    return Container();
  }
}

void showTopModal({
  required BuildContext context,
  required WidgetBuilder builder,
  required VoidCallback onClose, // 여기에 onClose 콜백을 추가
}) {
  Navigator.of(context).push(_TopModalRoute(
    builder: builder,
    onClose: onClose, // 콜백을 _TopModalRoute로 전달
  ));
}

class _TopModalRoute<T> extends PopupRoute<T> {
  _TopModalRoute({required this.builder, required this.onClose});

  final WidgetBuilder builder;
  final VoidCallback onClose;

  @override
  Color? get barrierColor => Colors.white.withOpacity(0.8);

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
    return WillPopScope(
      onWillPop: () async {
        onClose();
        return true;
      },
      child: Builder(builder: builder),
    );
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
