import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_yum/inheritedData.dart';
import 'package:social_yum/quiz.dart';
import 'package:social_yum/share_screen.dart';
import 'package:social_yum/utils.dart';

class CreateJoin extends StatelessWidget {
  CreateJoin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = InheritedDataProvider.of(context)!.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/logo.png'),
                  )),
              Text(
                "Hey " +
                    (data.googleUser == null ||
                            data.googleUser!.displayName == null
                        ? "there"
                        : data.googleUser!.displayName!.split(' ')[0]) +
                    '!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        var url = Uri.parse(
                            'https://api.chowwow.app/api/v1/chowwow?token=' +
                                data.token!);
                        // // for creating a chowwow: http.put uid=token
                        // // for joining a chowwow: http.patch cid=id&uid=token
                        var response = await http.put(url);
                        InheritedDataProvider.of(context)!.data.chowwow =
                            jsonDecode(response.body)["id"];
                        InheritedDataProvider.of(context)!.data.isHost = true;

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ShareScreen();
                          }),
                        );
                      },
                      child: Text("Create new Chowwow")),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border(
                        top: BorderSide(width: 2.0, color: Colors.grey),
                        left: BorderSide(width: 2.0, color: Colors.grey),
                        right: BorderSide(width: 2.0, color: Colors.grey),
                        bottom: BorderSide(width: 2.0, color: Colors.grey),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter Chowwow ID'),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                                onPressed: () async {
                                  String chowwow =
                                      'ovugMxE82xEIMNYWjuSN'; // comes from the chowwow
                                  var url = Uri.parse(
                                      'https://api.chowwow.app/api/v1/chowwow?id=' +
                                          chowwow +
                                          '&token=' +
                                          data.token!);
                                  // // for creating a chowwow: http.put uid=token
                                  // // for joining a chowwow: http.patch cid=id&uid=token
                                  var response = await http.patch(url);
                                  print(response.body);
                                  print(response.headers);
                                  print(response.statusCode);
                                  if (response.statusCode == 200) {
                                    InheritedDataProvider.of(context)!
                                        .data
                                        .isHost = false;
                                    InheritedDataProvider.of(context)!
                                        .data
                                        .chowwow = chowwow;
                                    List questions =
                                        await getQuizQuestions(data);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return Quiz(questions);
                                      }),
                                    );
                                  } else {
                                    print(
                                        'error'); // todo figure out how to make this better
                                  }
                                },
                                child: Text("Join Existing Chowwow")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
