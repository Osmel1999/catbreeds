import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class API with ChangeNotifier {
  List? data = [];
  List busqueda = [];

  Future<void> fetchData() async {
    final url = Uri.parse('https://api.thecatapi.com/v1/breeds');
    const String apikey =
        'ive_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr';

    final response = await http.get(
      url,
      headers: {
        'x-api-key': apikey,
      },
    );

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print(data);
    } else {
      print('Error: ${response.statusCode}');
      data = null;
    }
    notifyListeners();
  }

  searcCat(String query) {
    data!.forEach((e) {
      if (e['name'].contains(query)) {
        busqueda!.add(e);
      }
    });
    notifyListeners();
  }
}

String getQuality(String query) {
  String quality = '';
  for (int i = 0; i < query.length; i++) {
    if (query[i] != ',') {
      quality = quality + query[i];
    }else{
      i = query.length;
    }
  }
  return quality;
}
