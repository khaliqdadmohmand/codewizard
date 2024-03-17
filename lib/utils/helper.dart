import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:code_wizard/models/countries.dart';
import 'package:code_wizard/models/coutries_by_barcode.dart';

class Helper {
  Future<List<Countries>> loadCountrieFromsJsonData() async {
    String jsonData = await rootBundle.loadString('assets/countries.json');
    List<dynamic> data = json.decode(jsonData);
    List<Countries> countries =
        data.map((json) => Countries.fromJson(json)).toList();

    return countries;
  }

  Future<List<CountriesByBarCode>> loadCountrieByBarcodeFromsJsonData() async {
    String jsonData =
        await rootBundle.loadString('assets/country-by-barcode-prefix.json');
    List<dynamic> data = json.decode(jsonData);
    List<CountriesByBarCode> countries =
        data.map((json) => CountriesByBarCode.fromJson(json)).toList();

    return countries;
  }

  bool isBarURL(String input) {
    final urlPattern = RegExp(
        r'^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-zA-Z0-9]+([\-\.]{1}[a-zA-Z0-9]+)*\.[a-zA-Z]{2,5}(:[0-9]{1,5})?(\/.*)?$');
    return urlPattern.hasMatch(input);
  }

  bool isBarNumeric(String input) {
    if (input == null) {
      return false;
    }
    return double.tryParse(input) != null;
  }

  bool isBarText(String value) {
    final RegExp textRegExp = RegExp(r'^[A-Za-z\s]+$');
    return textRegExp.hasMatch(value);
  }

  String getFirstThreeDigits(String number) {
    String firstThreeDigits = number.substring(0, 3);
    return firstThreeDigits;
  }
}
