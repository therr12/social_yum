import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_yum/quiz.dart';
import 'package:social_yum/share_url.dart';

class ShareScreen extends StatelessWidget {
  ShareScreen({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final GoogleSignInAccount user;

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
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Text(
                "Hey " + user.displayName.split(' ')[0] + '!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
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
