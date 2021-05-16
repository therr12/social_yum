import 'package:flutter/material.dart';
import 'package:social_yum/inheritedData.dart';
import 'package:social_yum/share_url.dart';
import 'package:social_yum/wheel.dart';

class Campfire extends StatelessWidget {
  Campfire({Key key}) : super(key: key);

  final String url = 'www.google.com';
  final bool isHost = true;

  @override
  Widget build(BuildContext context) {
    if (isHost) {
      return CampfireHost(url: url);
    } else {
      return CampfireGuest(url: url);
    }
  }
}

class CampfireHost extends StatelessWidget {
  const CampfireHost({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    final data = InheritedDataProvider.of(context).data;
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Thank you for submitting your food preferences!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            Tents(),
            Text(
              "A restaurant decision will be made once you're done accepting group preferences!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Wheel(title: data.title)),
                  );
                },
                child: Text(
                  "Ready to make a decision!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            ShareURL(url: url),
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

class CampfireGuest extends StatelessWidget {
  const CampfireGuest({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    final data = InheritedDataProvider.of(context).data;
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Thank you for submitting your food preferences!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            Tents(),
            Text(
              "A restaurant decision will be made once your group host is ready!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5,
            ),
            // ),
          ],
        ),
      ),
    );
  }
}

class Tents extends StatelessWidget {
  const Tents({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo.png');
  }
}
