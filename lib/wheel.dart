import 'package:flutter/material.dart';
import 'package:social_yum/inheritedData.dart';
import 'package:social_yum/share_url.dart';

class Wheel extends StatelessWidget {
  Wheel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = InheritedDataProvider.of(context)!.data;
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
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
