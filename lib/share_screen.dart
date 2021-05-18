import 'package:flutter/material.dart';
import 'package:social_yum/inheritedData.dart';
import 'package:social_yum/quiz.dart';
import 'package:social_yum/share_url.dart';
import 'package:social_yum/utils.dart';

class ShareScreen extends StatelessWidget {
  ShareScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = InheritedDataProvider.of(context)!.data;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 6, child: Image.asset('assets/images/logo.png')),
              Text(
                "Invite friends to Chowwow",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              Expanded(flex: 1, child: ShareURL(url: data.chowwow!)),
              Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      List questions = await getQuizQuestions(data);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Quiz(questions)),
                      );
                    },
                    child: Text(
                      "Begin Food\nPreference Survey",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
              // TextField(
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'test',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
