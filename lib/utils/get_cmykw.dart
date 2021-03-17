import 'dart:math';

//ignore_for_file: non_constant_identifier_names

class CMYKW {
  const CMYKW({this.c, this.m, this.y, this.k, this.w});

  final int c;
  final int m;
  final int y;
  final int k;
  final int w;
}

bool isAll0(List<dynamic> param1) {
  if (param1[0] is List) param1 = param1[0];
  return param1.where((e) => e != 0).isEmpty;
}

bool isAllz(List<dynamic> param1) {
  if (param1[0] is List) param1 = param1[0];
  return param1.where((e) => e < 0).isEmpty;
}

List<dynamic> marMul(dynamic param1, dynamic param2) {
  if (param1 is int || param1 is double) {
    param1 = [
      [param1]
    ];
  } else if (param1[0] is int || param1[0] is double) {
    param1 = [param1];
  }

  if (param2 is int || param2 is double) {
    param2 = [
      [param2]
    ];
  } else if (param2[0] is int || param2[0] is double) {
    param2 = [param2];
  }

  final rec = List.generate(param1.length, (index) {
    return List.generate(param2[0].length, (index) => index * 1.0);
  });

  for (var i = 0; i < param1.length; i++) {
    for (var j = 0; j < param2[0].length; j++) {
      var tmp = 0.0;
      for (var k = 0; k < param2.length; k++) {
        tmp += param1[i][k] * param2[k][j];
      }
      rec[i][j] = tmp;
    }
  }
  return rec;
}

List<dynamic> marInv(List<dynamic> param1) {
  final rec = [
    [0.0, 0.0],
    [0.0, 0.0]
  ];
  final tmp = 1 / (param1[0][0] * param1[1][1] - param1[0][1] * param1[1][0]);
  rec[0][0] = param1[1][1] * tmp;
  rec[0][1] = -1 * param1[0][1] * tmp;
  rec[1][0] = -1 * param1[1][0] * tmp;
  rec[1][1] = param1[0][0] * tmp;
  return rec;
}

List<dynamic> marAdd(
    List<dynamic> param1, List<dynamic> param2, List<dynamic> param3) {
  final rec = [0.0, 0.0];
  rec[0] = param1[0] + param2[0] + param3[0];
  rec[1] = param1[1] + param2[1] + param3[1];
  return rec;
}

List<dynamic> g2kw(double _G) {
  _G = 255 * (1 - _G);
  var G_kwM = 130.0;
  var G_W_max = 204.0;
  var G_K_min = 66.0;
  var G_kw1 = 73.0;
  var Ka = 1507.0;
  var Kb1 = 70.65;
  var Kb2 = -5.63;
  var Kc = 6.61;

  var _kw;

  if (_G > G_kwM) {
    if (_G > G_W_max) {
      _G = G_W_max;
    }
    _kw = [(G_W_max - _G) / Ka, 1];
  } else if (_G > G_kw1) {
    _kw = [log((_G - G_kw1) / Kb1) / Kb2, 1];
  } else {
    if (_G < G_K_min) {
      _G = G_K_min;
    }
    _kw = [(_G - G_K_min) / Kc, 2];
  }
  return _kw;
}

double fkg(List<double> _kg) {
  double k_g;
  if (isAll0(_kg)) {
    k_g = 1;
  } else if (_kg[3] < 0.02) {
    k_g = 1 - _kg[4];
  } else {
    k_g = _kg[3] / (_kg[0] + _kg[1] + _kg[2] + _kg[3]);
  }
  return k_g;
}

double avg(List<dynamic> kg) {
  return kg[3] / kg.reduce((value, element) => value + element);
}

List<double> F3_cmy(List<double> _cmy) {
  var _cmykw_3 = [0.0, 0.0, 0.0];
  if (_cmy[3] != 0) {
    final XY_cmy = [
      [-0.295519, 0.093337],
      [0.316407, 0.323877],
      [0.408362, -0.637566]
    ];
    var XY_e = marMul((1 - _cmy[0]), [1, 0]) +
        marMul((1 - _cmy[1]), [-0.5, -0.5 * 1.732051]) +
        marMul((1 - _cmy[2]), [-0.5, 0.5 * 1.732051]);
    XY_e = marAdd(XY_e[0], XY_e[1], XY_e[2]);
    final XY_my = marMul(XY_e, marInv([XY_cmy[1], XY_cmy[2]]));
    final XY_cy = marMul(XY_e, marInv([XY_cmy[0], XY_cmy[2]]));
    dynamic K_cmy;
    if (isAllz(XY_my)) {
      K_cmy = XY_my[0];
      final K_g = avg([_cmy[0], _cmy[1], _cmy[2], _cmy[0]]);
      _cmykw_3[0] = _cmy[3] * K_g / 3;
      _cmykw_3[1] = _cmy[3] * K_g / 3 +
          _cmy[3] * (1 - K_g) * (K_cmy[0] / (K_cmy[0] + K_cmy[1]));
      _cmykw_3[2] = _cmy[3] * K_g / 3 +
          _cmy[3] * (1 - K_g) * (K_cmy[1] / (K_cmy[0] + K_cmy[1]));
    } else if (isAllz(XY_cy)) {
      K_cmy = XY_cy[0];
      var K_g = avg([_cmy[0], _cmy[1], _cmy[2], _cmy[1]]);
      _cmykw_3[0] = _cmy[3] * K_g / 3 +
          _cmy[3] * (1 - K_g) * (K_cmy[0] / (K_cmy[0] + K_cmy[1]));
      _cmykw_3[1] = _cmy[3] * K_g / 3;
      _cmykw_3[2] = _cmy[3] * K_g / 3 +
          _cmy[3] * (1 - K_g) * (K_cmy[1] / (K_cmy[0] + K_cmy[1]));
    } else {
      var XY_cm = marMul(XY_e, marInv([XY_cmy[0], XY_cmy[1]]));
      K_cmy = XY_cm[0];
      var K_g = avg([_cmy[0], _cmy[1], _cmy[2], _cmy[2]]);
      _cmykw_3[0] = _cmy[3] * K_g / 3 +
          _cmy[3] * (1 - K_g) * (K_cmy[0] / (K_cmy[0] + K_cmy[1]));
      _cmykw_3[1] = _cmy[3] * K_g / 3 +
          _cmy[3] * (1 - K_g) * (K_cmy[1] / (K_cmy[0] + K_cmy[1]));
      _cmykw_3[2] = _cmy[3] * K_g / 3;
    }

    for (var col = 0; col < 2; col++) {
      if (K_cmy[col] > 1) {
        break;
      }
    }
  }
  return _cmykw_3;
}

class Rgb2CMYG {
  final List<int> rgb;
  final int TS;

  Rgb2CMYG({this.rgb, this.TS});
}

class CMYGResult {
  final List<int> data;

  const CMYGResult(this.data);
}

CMYKW RGB_CMYG(Rgb2CMYG data) {
  var _rgb = data.rgb;
  var _TS = data.TS;

  var C_0 = (255 - _rgb[0]) / 255;
  var M_0 = (255 - _rgb[1]) / 255;
  var Y_0 = (255 - _rgb[2]) / 255;

  var S = min(C_0, min(M_0, Y_0));
  var L = max(C_0, max(M_0, Y_0));

  var N = 15;
  var SA = L - S;
  var M = 0.02;
  double G;
  if (SA < M) {
    C_0 = (C_0 + M_0 + Y_0) / 3;
    M_0 = C_0;
    Y_0 = C_0;
    G = C_0;
  } else {
    G = S - (L - S) / N;
  }

  if (G < 0) {
    G = 0.0;
  }

  var kw = g2kw(G * 1.0);
  var C_1 = C_0 - G;
  var M_1 = M_0 - G;
  var Y_1 = Y_0 - G;
  var K_g = fkg([C_1, M_1, Y_1, G, SA]);

  double BK, W;

  if (kw[1] == 1) {
    BK = _TS * K_g * (kw[0] / (1 + kw[0]));
    W = _TS * K_g - BK;
  } else {
    W = _TS * K_g * (kw[0] / (1 + kw[1]));
    BK = _TS * K_g - W;
  }

  List<double> dd;
  if (K_g != 1) {
    dd = F3_cmy([C_1, M_1, Y_1, _TS * (1 - K_g)]);
  } else {
    dd = [0.0, 0.0, 0.0];
  }

  return CMYKW(
    c: !dd[0].isFinite ? 0 : dd[0].round(),
    m: !dd[1].isFinite ? 0 : dd[1].round(),
    y: !dd[2].isFinite ? 0 : dd[2].round(),
    k: BK.round(),
    w: W.round(),
  );
}
