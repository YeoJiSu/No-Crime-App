/// 출처: @June222
import 'dart:math';

class CrimeModel {
  // ignore: non_constant_identifier_names
  final int theft, murder, robbery, sexual_assault, assault;

  CrimeModel.fromJson(Map<String, dynamic> json)
      : theft = json['절도'],
        murder = json['살인'],
        robbery = json['강도'],
        sexual_assault = json['성폭력'],
        assault = json['폭행'];

  CrimeModel()
      : theft = 0,
        murder = 0,
        robbery = 0,
        sexual_assault = 0,
        assault = 0;

  String getBestRatioType() {
    String best;
    final win1 = max(theft, murder);
    final win2 = max(robbery, sexual_assault);
    final win3 = max(win1, win2);
    final win4 = max(win3, assault);

    if (win4 == theft) {
      best = "절도";
    } else if (win4 == murder) {
      best = "살인";
    } else if (win4 == robbery) {
      best = "강도";
    } else if (win4 == sexual_assault) {
      best = "성폭력";
    } else {
      best = '폭행';
    }
    return best;
  }

  String getWorstRatioType() {
    String worst;
    final win1 = min(theft, murder);
    final win2 = min(robbery, sexual_assault);
    final win3 = min(win1, win2);
    final win4 = min(win3, assault);

    if (win4 == theft) {
      worst = "절도";
    } else if (win4 == murder) {
      worst = "살인";
    } else if (win4 == robbery) {
      worst = "강도";
    } else if (win4 == sexual_assault) {
      worst = "성폭력";
    } else {
      worst = '폭행';
    }
    return worst;
  }
}
