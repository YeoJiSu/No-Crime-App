/// 출처: @June222 깃허브
import 'dart:convert';
import 'dart:developer';

import '../models/crime_model.dart';
import 'package:http/http.dart' as http;

class CrimeApiService {
  final String host = 'https://yeojisu.pythonanywhere.com';
  final String district = 'district';
  final String population = 'population';
  final String place = 'place';
  final String day = 'day';
  final String time = 'time';
  final String year = 'year';
  final String predict = 'predict';
  final String search = 'search';
  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    // 'Accept': 'application/json'
  };

  Future<List<CrimeModel>> getExample() async {
    List<CrimeModel> crimeInfoInstances = [];

    final url = Uri.parse(host);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonExamples = jsonDecode(response.body);

      var crimeInfo = CrimeModel.fromJson(jsonExamples['data']);
      crimeInfoInstances.add(crimeInfo);
    } else {
      throw Error();
    }
    return crimeInfoInstances;
  }

  Future<List<String>> getDistrict() async {
    List<String> districtInstances = [];

    final url = Uri.parse("$host/$district");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonDistrict = jsonDecode(response.body);
      for (var district in jsonDistrict['data']) {
        districtInstances.add(district);
      }
      return districtInstances;
    } else {
      throw Error();
    }
  }

  Future<List<String>> getSecondDistrictList(String selectedDistrict) async {
    List<String> secondDistrictInstances = [];

    final data = {"도.특별시.광역시": selectedDistrict};
    final body = jsonEncode(data);

    final url = Uri.parse("$host/$district/");
    final response = await http.post(
      url,
      headers: _headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var jsonSecondDistrict = jsonDecode(response.body);
      for (var dis in jsonSecondDistrict['data']) {
        secondDistrictInstances.add(dis);
      }
      return secondDistrictInstances;
    } else {
      throw Error();
    }
  }

  Future<Map<String, dynamic>> getInfos(
      String firstDistrict, String secondDistrict) async {
    final data = {"도.특별시.광역시": firstDistrict, "시.군.구": secondDistrict};
    final body = jsonEncode(data);

    final url = Uri.parse("$host/$population/");
    final response = await http.post(
      url,
      headers: _headers,
      body: body,
    );
    //log(response.body);
    if (response.statusCode == 200) {
      var jsonPopMap = jsonDecode(response.body);
      return jsonPopMap;
    } else {
      throw Error();
    }
  }

  Future<CrimeModel> getCrimeModel(Map<String, dynamic> parms) async {
    var infos = await getInfos(parms['first'], parms['second']);

    final url = Uri.parse("$host/$predict/");

    parms.addAll(infos['data']);

    final data = {
      '위치': parms['위치'].toString(),
      '장소': parms['장소'].toString(),
      '요일': parms['요일'].toString(),
      '시간대': parms['시간대'].toString(),
      '인구수': parms['인구수'].toString(),
    };
    // log("$data");
    final body = jsonEncode(data);
    log(body);
    final response = await http.post(
      url,
      headers: _headers,
      body: body,
    );
    if (response.statusCode == 200) {
      var decodedMap = jsonDecode(response.body);

      return CrimeModel.fromJson(decodedMap['data']);
    } else {
      throw Error();
    }
  }

  Future<CrimeModel> getSearch(
      String firstDistrict, String secondDistrict, String year) async {
    final data = {
      "도.특별시.광역시": firstDistrict,
      "시.군.구": secondDistrict,
      "연도": year
    };
    final body = jsonEncode(data);

    final url = Uri.parse("$host/$search/");
    final response = await http.post(
      url,
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonPopMap = jsonDecode(response.body);
      return CrimeModel.fromJson(jsonPopMap['data']);
    } else {
      throw Error();
    }
  }

  Future<List<String>> getPlaceList() async {
    List<String> placeInstances = [];

    final url = Uri.parse("$host/$place");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonPlace = jsonDecode(response.body);
      for (var place in jsonPlace['data']) {
        placeInstances.add(place);
      }
      return placeInstances;
    } else {
      throw Error();
    }
  }

  Future<List<String>> getDayList() async {
    List<String> dayInstances = [];

    final url = Uri.parse("$host/$day");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonDay = jsonDecode(response.body);
      for (var day in jsonDay['data']) {
        dayInstances.add(day);
      }
      return dayInstances;
    } else {
      throw Error();
    }
  }

  Future<List<String>> getTimeList() async {
    List<String> timeInstances = [];

    final url = Uri.parse("$host/$time");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonTime = jsonDecode(response.body);
      for (var time in jsonTime['data']) {
        timeInstances.add(time);
      }
      return timeInstances;
    } else {
      throw Error();
    }
  }

  Future<List<String>> getYearList() async {
    List<String> yearInstances = [];

    final url = Uri.parse("$host/$year");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonYear = jsonDecode(response.body);
      for (var year in jsonYear['data']) {
        yearInstances.add(year);
      }
      return yearInstances;
    } else {
      throw Error();
    }
  }
}
