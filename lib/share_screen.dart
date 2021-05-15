import 'package:flutter/material.dart';
import 'package:social_yum/quiz.dart';
import 'package:social_yum/share_url.dart';

class ShareScreen extends StatelessWidget {
  ShareScreen({Key key, this.title}) : super(key: key);

  final String title;

  final String url = 'www.google.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Invite friends to Chowwow",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            ShareURL(url: url),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Quiz(title: this.title)),
                );
              },
              child: Text(
                "Begin Food Preference Survey",
                style: Theme.of(context).textTheme.headline4,
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
    );
  }
}
