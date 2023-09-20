class RSizes {
  late final double _maxHeight;
  late final double _maxWidth;
  // 사용법:
  // 1. class 상단에 late키워드로 객체변수 임의로 s를 선언 ex: late RSizes s;
  // 2. builder내에서 s = RGaps(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width); 로 객체 초기화
  // 3. 세로로 1/10만큼 길이를 사용하고 싶으면, s.hrSize10() 수식.
  // 4. 가로로 1/10만큼 길이를 사용하고 싶으면, s.wrSize10() 수식.

  RSizes(this._maxHeight, this._maxWidth);
  double rSize(String a, int raito) {
    if (a == "height") {
      double maxH = _maxHeight;
      return maxH * raito / 1000.0;
    }
    if (a == "width") {
      double maxW = _maxWidth;
      return maxW * raito / 1000.0;
    }
    return 0.0;
  }

  maxHeight() {
    return _maxHeight;
  }

  maxWidth() {
    return _maxWidth;
  }

  rSize00() {
    return 0.0;
  }

  hrSize001() {
    return _maxHeight * 0.001;
  }

  hrSize002() {
    return _maxHeight * 0.002;
  }

  hrSize003() {
    return _maxHeight * 0.003;
  }

  hrSize004() {
    return _maxHeight * 0.004;
  }

  hrSize005() {
    return _maxHeight * 0.005;
  }

  hrSize006() {
    return _maxHeight * 0.006;
  }

  hrSize007() {
    return _maxHeight * 0.007;
  }

  hrSize008() {
    return _maxHeight * 0.008;
  }

  hrSize009() {
    return _maxHeight * 0.009;
  }

  hrSize01() {
    return _maxHeight * 0.01;
  }

  hrSize011() {
    return _maxHeight * 0.011;
  }

  hrSize012() {
    return _maxHeight * 0.012;
  }

  hrSize013() {
    return _maxHeight * 0.013;
  }

  hrSize014() {
    return _maxHeight * 0.014;
  }

  hrSize015() {
    return _maxHeight * 0.015;
  }

  hrSize016() {
    return _maxHeight * 0.016;
  }

  hrSize017() {
    return _maxHeight * 0.017;
  }

  hrSize018() {
    return _maxHeight * 0.018;
  }

  hrSize019() {
    return _maxHeight * 0.019;
  }

  hrSize02() {
    return _maxHeight * 0.02;
  }

  hrSize021() {
    return _maxHeight * 0.021;
  }

  hrSize022() {
    return _maxHeight * 0.022;
  }

  hrSize023() {
    return _maxHeight * 0.023;
  }

  hrSize024() {
    return _maxHeight * 0.024;
  }

  hrSize025() {
    return _maxHeight * 0.025;
  }

  hrSize026() {
    return _maxHeight * 0.026;
  }

  hrSize027() {
    return _maxHeight * 0.027;
  }

  hrSize028() {
    return _maxHeight * 0.028;
  }

  hrSize029() {
    return _maxHeight * 0.029;
  }

  hrSize03() {
    return _maxHeight * 0.03;
  }

  hrSize035() {
    return _maxHeight * 0.035;
  }

  hrSize04() {
    return _maxHeight * 0.04;
  }

  hrSize045() {
    return _maxHeight * 0.045;
  }

  hrSize05() {
    return _maxHeight * 0.05;
  }

  hrSize055() {
    return _maxHeight * 0.055;
  }

  hrSize06() {
    return _maxHeight * 0.06;
  }

  hrSize065() {
    return _maxHeight * 0.065;
  }

  hrSize07() {
    return _maxHeight * 0.07;
  }

  hrSize075() {
    return _maxHeight * 0.075;
  }

  hrSize08() {
    return _maxHeight * 0.08;
  }

  hrSize085() {
    return _maxHeight * 0.085;
  }

  hrSize09() {
    return _maxHeight * 0.09;
  }

  hrSize095() {
    return _maxHeight * 0.095;
  }

  hrSize10() {
    return _maxHeight * 0.1;
  }

  hrSize11() {
    return _maxHeight * 0.11;
  }

  hrSize12() {
    return _maxHeight * 0.12;
  }

  hrSize13() {
    return _maxHeight * 0.13;
  }

  hrSize14() {
    return _maxHeight * 0.14;
  }

  hrSize15() {
    return _maxHeight * 0.15;
  }

  hrSize16() {
    return _maxHeight * 0.16;
  }

  hrSize17() {
    return _maxHeight * 0.17;
  }

  hrSize18() {
    return _maxHeight * 0.18;
  }

  hrSize19() {
    return _maxHeight * 0.19;
  }

  hrSize20() {
    return _maxHeight * 0.2;
  }

  hrSize21() {
    return _maxHeight * 0.21;
  }

  hrSize22() {
    return _maxHeight * 0.22;
  }

  hrSize23() {
    return _maxHeight * 0.23;
  }

  hrSize24() {
    return _maxHeight * 0.24;
  }

  hrSize25() {
    return _maxHeight * 0.25;
  }

  hrSize26() {
    return _maxHeight * 0.26;
  }

  hrSize27() {
    return _maxHeight * 0.27;
  }

  hrSize28() {
    return _maxHeight * 0.28;
  }

  hrSize29() {
    return _maxHeight * 0.29;
  }

  hrSize30() {
    return _maxHeight * 0.3;
  }

  hrSize31() {
    return _maxHeight * 0.31;
  }

  hrSize32() {
    return _maxHeight * 0.32;
  }

  hrSize33() {
    return _maxHeight * 0.33;
  }

  hrSize34() {
    return _maxHeight * 0.34;
  }

  hrSize35() {
    return _maxHeight * 0.35;
  }

  hrSize36() {
    return _maxHeight * 0.36;
  }

  hrSize37() {
    return _maxHeight * 0.37;
  }

  hrSize38() {
    return _maxHeight * 0.38;
  }

  hrSize39() {
    return _maxHeight * 0.3;
  }

  hrSize40() {
    return _maxHeight * 0.4;
  }

  hrSize41() {
    return _maxHeight * 0.41;
  }

  hrSize42() {
    return _maxHeight * 0.42;
  }

  hrSize43() {
    return _maxHeight * 0.43;
  }

  hrSize44() {
    return _maxHeight * 0.44;
  }

  hrSize45() {
    return _maxHeight * 0.45;
  }

  hrSize46() {
    return _maxHeight * 0.46;
  }

  hrSize47() {
    return _maxHeight * 0.47;
  }

  hrSize48() {
    return _maxHeight * 0.48;
  }

  hrSize49() {
    return _maxHeight * 0.49;
  }

  hrSize50() {
    return _maxHeight * 0.5;
  }

  hrSize60() {
    return _maxHeight * 0.6;
  }

  hrSize70() {
    return _maxHeight * 0.7;
  }

  hrSize75() {
    return _maxHeight * 0.75;
  }

  hrSize78() {
    return _maxHeight * 0.78;
  }

  hrSize80() {
    return _maxHeight * 0.8;
  }

  hrSize90() {
    return _maxHeight * 0.9;
  }

  //width
  wrSize001() {
    return _maxWidth * 0.001;
  }

  wrSize002() {
    return _maxWidth * 0.002;
  }

  wrSize003() {
    return _maxWidth * 0.003;
  }

  wrSize004() {
    return _maxWidth * 0.004;
  }

  wrSize005() {
    return _maxWidth * 0.005;
  }

  wrSize006() {
    return _maxWidth * 0.006;
  }

  wrSize007() {
    return _maxWidth * 0.007;
  }

  wrSize008() {
    return _maxWidth * 0.008;
  }

  wrSize009() {
    return _maxWidth * 0.009;
  }

  wrSize01() {
    return _maxWidth * 0.01;
  }

  wrSize011() {
    return _maxWidth * 0.011;
  }

  wrSize012() {
    return _maxWidth * 0.012;
  }

  wrSize013() {
    return _maxWidth * 0.013;
  }

  wrSize014() {
    return _maxWidth * 0.014;
  }

  wrSize015() {
    return _maxWidth * 0.015;
  }

  wrSize016() {
    return _maxWidth * 0.016;
  }

  wrSize017() {
    return _maxWidth * 0.017;
  }

  wrSize018() {
    return _maxWidth * 0.018;
  }

  wrSize019() {
    return _maxWidth * 0.019;
  }

  wrSize02() {
    return _maxWidth * 0.02;
  }

  wrSize021() {
    return _maxWidth * 0.021;
  }

  wrSize022() {
    return _maxWidth * 0.022;
  }

  wrSize023() {
    return _maxWidth * 0.023;
  }

  wrSize024() {
    return _maxWidth * 0.024;
  }

  wrSize025() {
    return _maxWidth * 0.025;
  }

  wrSize026() {
    return _maxWidth * 0.026;
  }

  wrSize027() {
    return _maxWidth * 0.027;
  }

  wrSize028() {
    return _maxWidth * 0.028;
  }

  wrSize029() {
    return _maxWidth * 0.029;
  }

  wrSize03() {
    return _maxWidth * 0.03;
  }

  wrSize035() {
    return _maxWidth * 0.035;
  }

  wrSize04() {
    return _maxWidth * 0.04;
  }

  wrSize045() {
    return _maxWidth * 0.045;
  }

  wrSize05() {
    return _maxWidth * 0.05;
  }

  wrSize055() {
    return _maxWidth * 0.055;
  }

  wrSize06() {
    return _maxWidth * 0.06;
  }

  wrSize065() {
    return _maxWidth * 0.065;
  }

  wrSize07() {
    return _maxWidth * 0.07;
  }

  wrSize075() {
    return _maxWidth * 0.075;
  }

  wrSize08() {
    return _maxWidth * 0.08;
  }

  wrSize085() {
    return _maxWidth * 0.085;
  }

  wrSize09() {
    return _maxWidth * 0.09;
  }

  wrSize095() {
    return _maxWidth * 0.095;
  }

  wrSize10() {
    return _maxWidth * 0.1;
  }

  wrSize11() {
    return _maxWidth * 0.11;
  }

  wrSize12() {
    return _maxWidth * 0.12;
  }

  wrSize13() {
    return _maxWidth * 0.13;
  }

  wrSize14() {
    return _maxWidth * 0.14;
  }

  wrSize15() {
    return _maxWidth * 0.15;
  }

  wrSize16() {
    return _maxWidth * 0.16;
  }

  wrSize17() {
    return _maxWidth * 0.17;
  }

  wrSize18() {
    return _maxWidth * 0.18;
  }

  wrSize19() {
    return _maxWidth * 0.19;
  }

  wrSize20() {
    return _maxWidth * 0.2;
  }

  wrSize21() {
    return _maxWidth * 0.21;
  }

  wrSize22() {
    return _maxWidth * 0.22;
  }

  wrSize23() {
    return _maxWidth * 0.23;
  }

  wrSize24() {
    return _maxWidth * 0.24;
  }

  wrSize25() {
    return _maxWidth * 0.25;
  }

  wrSize26() {
    return _maxWidth * 0.26;
  }

  wrSize27() {
    return _maxWidth * 0.27;
  }

  wrSize28() {
    return _maxWidth * 0.28;
  }

  wrSize29() {
    return _maxWidth * 0.29;
  }

  wrSize30() {
    return _maxWidth * 0.3;
  }

  wrSize31() {
    return _maxWidth * 0.31;
  }

  wrSize32() {
    return _maxWidth * 0.32;
  }

  wrSize33() {
    return _maxWidth * 0.33;
  }

  wrSize34() {
    return _maxWidth * 0.34;
  }

  wrSize35() {
    return _maxWidth * 0.35;
  }

  wrSize36() {
    return _maxWidth * 0.36;
  }

  wrSize37() {
    return _maxWidth * 0.37;
  }

  wrSize38() {
    return _maxWidth * 0.38;
  }

  wrSize39() {
    return _maxWidth * 0.3;
  }

  wrSize40() {
    return _maxWidth * 0.4;
  }

  wrSize41() {
    return _maxWidth * 0.41;
  }

  wrSize42() {
    return _maxWidth * 0.42;
  }

  wrSize43() {
    return _maxWidth * 0.43;
  }

  wrSize44() {
    return _maxWidth * 0.44;
  }

  wrSize45() {
    return _maxWidth * 0.45;
  }

  wrSize46() {
    return _maxWidth * 0.46;
  }

  wrSize47() {
    return _maxWidth * 0.47;
  }

  wrSize48() {
    return _maxWidth * 0.48;
  }

  wrSize49() {
    return _maxWidth * 0.49;
  }

  wrSize50() {
    return _maxWidth * 0.5;
  }
}
