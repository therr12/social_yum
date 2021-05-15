import 'package:flutter/material.dart';
import 'package:social_yum/share_url.dart';
import 'package:social_yum/wheel.dart';

class Campfire extends StatelessWidget {
  Campfire({Key key, this.title}) : super(key: key);

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
            Image.asset('assets/images/logo.png'),
            Text(
              "Invite friends to Chowwow",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            ShareURL(url: url),
            Text(
                "Once everybody is ready, let Chowwow select your restaurant!"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Wheel(title: this.title)),
                );
              },
              child: Text(
                "Select a Restaurant",
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
