import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:social_yum/inheritedData.dart';

Future<List> getQuizQuestions(Data data) async {
  var url = Uri.parse('https://api.chowwow.app/api/v1/chowwow/' +
      data.chowwow! +
      '/survey?token=' +
      data.token!);
  var response = await http.post(url);

  List<dynamic> questions = jsonDecode(response.body)["questions"];
  return questions;
}
