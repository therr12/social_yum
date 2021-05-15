import 'package:flutter/material.dart';
import 'package:social_yum/share_url.dart';

class Wheel extends StatelessWidget {
  Wheel({Key key, this.title}) : super(key: key);

  final String title;

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
            Text("You got..."),
            Text(
              "Chik Fil A",
              style: Theme.of(context).textTheme.headline3,
            ),
            ShareURL(url: 'https://www.chick-fil-a.com/'),
          ],
        ),
      ),
    );
  }
}
