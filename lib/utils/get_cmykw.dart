import 'dart:math';

import 'package:blue_demo/data/database/entity/config_entity.dart';
import 'package:flutter/cupertino.dart';

// ignore_for_file: non_constant_identifier_names

class CMYKW {
  const CMYKW({
    required this.c,
    required this.m,
    required this.y,
    required this.k,
    required this.w,
  });

  final int c;
  final int m;
  final int y;
  final int k;
  final int w;

  @override
  String toString() {
    return 'c:$c  m:$m  y:$y  k:$k  w:$w';
  }
}

class CMYKWConfig {
  CMYKWConfig({
    this.G_K_min = 66.0,
    this.G_kw1 = 73.0,
    this.G_kwM = 130.0,
    this.G_W_max = 204.0,
    this.Ka = 1507.0,
    this.Kb1 = 70.65,
    this.Kb2 = -5.63,
    this.Kc = 6.61,
    this.ts = 200,
    this.XY_cmy = const [
      [-0.295519, 0.093337],
      [0.316407, 0.323877],
      [0.408362, -0.637566]
    ],
  });

  CMYKWConfig.database(ConfigEntity entity)
      : G_kwM = entity.G_kwM,
        G_W_max = entity.G_W_max,
        G_K_min = entity.G_K_min,
        G_kw1 = entity.G_kw1,
        Ka = entity.Ka,
        Kb1 = entity.Kb1,
        Kb2 = entity.Kb2,
        Kc = entity.Kc,
        ts = entity.ts,
        XY_cmy = [
          [entity.xy11, entity.xy12],
          [entity.xy21, entity.xy22],
          [entity.xy31, entity.xy32],
        ];

  double G_kwM; //最灰色值
  double G_W_max; //最白色值
  double G_K_min; //最黑色值
  double G_kw1; //黑阶分界值
  double Ka; //拟合参数a
  double Kb1; //拟合参数b1
  double Kb2; //拟合参数b2
  double Kc; //拟合参数c
  double ts;

  List<List<double>> XY_cmy;

  bool isSame(ConfigEntity entity) {
    return entity.G_K_min == G_K_min &&
        entity.G_kw1 == G_kw1 &&
        entity.G_kwM == G_kwM &&
        entity.G_W_max == G_W_max &&
        entity.Ka == Ka &&
        entity.Kb1 == Kb1 &&
        entity.Kb2 == Kb2 &&
        entity.Kc == Kc &&
        entity.ts == ts &&
        XY_cmy[0][0] == entity.xy11 &&
        XY_cmy[0][1] == entity.xy12 &&
        XY_cmy[1][0] == entity.xy21 &&
        XY_cmy[1][1] == entity.xy22 &&
        XY_cmy[2][0] == entity.xy31 &&
        XY_cmy[2][1] == entity.xy32;
  }
}

class CMYKWUtil {
  CMYKWUtil(CMYKWConfig? config)
      : G_W_max = config?.G_W_max ?? 204.0,
        G_kwM = config?.G_kwM ?? 130.0,
        G_K_min = config?.G_K_min ?? 66.0,
        G_kw1 = config?.G_kw1 ?? 73.0,
        Ka = config?.Ka ?? 1507.0,
        Kb1 = config?.Kb1 ?? 70.65,
        Kb2 = config?.Kb2 ?? -5.63,
        Kc = config?.Kc ?? 6.61,
        ts = config?.ts ?? 200,
        XY_cmy = config?.XY_cmy ??
            const [
              [-0.295519, 0.093337],
              [0.316407, 0.323877],
              [0.408362, -0.637566]
            ];

  double G_kwM; //最灰色值
  double G_W_max; //最白色值
  double G_K_min; //最黑色值
  double G_kw1; //黑阶分界值
  double Ka; //拟合参数a
  double Kb1; //拟合参数b1
  double Kb2; //拟合参数b2
  double Kc; //拟合参数c
  double ts;

  List<List<double>> XY_cmy;

  CMYKW RGB_CMYG(Color rgb) {
    var C_0 = (255 - rgb.red) / 255;
    var M_0 = (255 - rgb.green) / 255;
    var Y_0 = (255 - rgb.blue) / 255;

    final S = min(C_0, min(M_0, Y_0));
    final L = max(C_0, max(M_0, Y_0));

    const N = 15;
    final SA = L - S;
    const M = 0.02;
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

    final kw = g2kw(G * 1.0);
    final C_1 = C_0 - G;
    final M_1 = M_0 - G;
    final Y_1 = Y_0 - G;
    final K_g = fkg([C_1, M_1, Y_1, G, SA]);

    double BK, W;

    if (kw[1] == 1) {
      BK = ts * K_g * (kw[0] / (1 + kw[0]));
      W = ts * K_g - BK;
    } else {
      W = ts * K_g * (kw[0] / (1 + kw[1]));
      BK = ts * K_g - W;
    }

    List<double> dd;
    if (K_g != 1) {
      dd = F3_cmy([C_1, M_1, Y_1, ts * (1 - K_g)]);
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

  bool isAll0(List<dynamic> param1) {
    if (param1[0] is List) param1 = param1[0] as List<dynamic>;
    return !param1.any((e) => e != 0);
  }

  bool isAllz(List<dynamic> param1) {
    if (param1[0] is List) param1 = param1[0] as List<dynamic>;
    return !param1.any((e) => e as double < 0);
  }

  List<List<double>> marMul(dynamic p1, dynamic p2) {
    late List<List<double>> param1, param2;
    if (p1 is int || p1 is double || p1 is num) {
      param1 = [
        [p1 as double]
      ];
    } else if (p1[0] is int || p1[0] is double) {
      param1 = [p1 as List<double>];
    } else {
      param1 = p1 as List<List<double>>;
    }

    if (p2 is int || p2 is double) {
      param2 = [
        [p2 as double]
      ];
    } else if (p2[0] is int || p2[0] is double || p2[0] is num) {
      param2 = [p2 as List<double>];
    } else {
      param2 = p2 as List<List<double>>;
    }

    final rec = List.generate(param1.length, (index) {
      return List.generate((param2[0]).length, (index) => index * 1.0);
    });

    for (var i = 0; i < param1.length; i++) {
      for (var j = 0; j < (param2[0]).length; j++) {
        var tmp = 0.0;
        for (var k = 0; k < param2.length; k++) {
          tmp += param1[i][k] * param2[k][j];
        }
        rec[i][j] = tmp;
      }
    }
    return rec;
  }

  List<dynamic> marInv(List<List<double>> param1) {
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

  List<double> marAdd(
      List<double> param1, List<double> param2, List<double> param3) {
    final rec = [0.0, 0.0];
    rec[0] = param1[0] + param2[0] + param3[0];
    rec[1] = param1[1] + param2[1] + param3[1];
    return rec;
  }

  List<double> g2kw(double _G) {
    _G = 255 * (1 - _G);
    late List<double> _kw;

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

  double avg(List<double> kg) {
    return kg[3] / kg.reduce((value, element) => value + element);
  }

  List<double> F3_cmy(List<double> _cmy) {
    final _cmykw_3 = [0.0, 0.0, 0.0];
    if (_cmy[3] != 0) {
      final XY_ec = marMul(1.0 - _cmy[0], [1.0, 0.0]) +
          marMul(1.0 - _cmy[1], [-0.5, -0.5 * 1.732051]) +
          marMul(1.0 - _cmy[2], [-0.5, 0.5 * 1.732051]);

      final XY_e = marAdd(XY_ec[0], XY_ec[1], XY_ec[2]);

      final XY_my = marMul(XY_e, marInv([XY_cmy[1], XY_cmy[2]]));
      final XY_cy = marMul(XY_e, marInv([XY_cmy[0], XY_cmy[2]]));
      List<double> K_cmy;
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
        final K_g = avg([_cmy[0], _cmy[1], _cmy[2], _cmy[1]]);
        _cmykw_3[0] = _cmy[3] * K_g / 3 +
            _cmy[3] * (1 - K_g) * (K_cmy[0] / (K_cmy[0] + K_cmy[1]));
        _cmykw_3[1] = _cmy[3] * K_g / 3;
        _cmykw_3[2] = _cmy[3] * K_g / 3 +
            _cmy[3] * (1 - K_g) * (K_cmy[1] / (K_cmy[0] + K_cmy[1]));
      } else {
        final XY_cm = marMul(XY_e, marInv([XY_cmy[0], XY_cmy[1]]));
        K_cmy = XY_cm[0];
        final K_g = avg([_cmy[0], _cmy[1], _cmy[2], _cmy[2]]);
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
}
