import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:social_yum/inheritedData.dart';
import 'package:social_yum/share_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return MaterialApp(
            title: 'error',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return InheritedDataProvider(
              child: MaterialApp(
                title: 'chow.wow',
                theme: ThemeData(
                  primarySwatch: Colors.orange,
                ),
                home: MyHomePage(),
              ),
              data: Data(
                  googleUser: null,
                  title: 'chow.wow',
                  chowwow: null,
                  token: null));
        } else {
          return MaterialApp(
            title: 'loading',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: Text("Loading"),
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png'),
            Container(
              padding: EdgeInsets.only(right: 50, left: 50),
              child: Column(
                children: <Widget>[
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.orangeAccent),
                      overlayColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered))
                            return Colors.orangeAccent.withOpacity(0.04);
                          if (states.contains(MaterialState.focused) ||
                              states.contains(MaterialState.pressed))
                            return Colors.orangeAccent.withOpacity(0.12);
                          return null; // Defer to the widget's default.
                        },
                      ),
                    ),
                    onPressed: () async {
                      UserCredential googleUserCredential;
                      if (kIsWeb) {
                        GoogleAuthProvider googleProvider =
                            GoogleAuthProvider();
                        // Once signed in, return the UserCredential
                        googleUserCredential = await FirebaseAuth.instance
                            .signInWithPopup(googleProvider);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShareScreen()),
                        );
                      } else {
                        final GoogleSignInAccount googleUser =
                            await GoogleSignIn().signIn();
                        if (googleUser != null) {
                          InheritedDataProvider.of(context).data.googleUser =
                              googleUser;
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;
                          // Create a new credential.
                          final GoogleAuthCredential googleCredential =
                              GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );
                          // Sign in to Firebase with the Google [UserCredential].
                          googleUserCredential = await FirebaseAuth.instance
                              .signInWithCredential(googleCredential);
                          final token = await FirebaseAuth.instance.currentUser
                              .getIdToken();
                          var url = Uri.parse(
                              'https://api.chowwow.app/api/v1/chowwow?token=' +
                                  token);
                          // // for creating a chowwow: http.put uid=token
                          // // for joining a chowwow: http.patch cid=id&uid=token
                          var response = await http.put(url);
                          print('Response status: ${response.statusCode}');
                          print('Response body: ${response.body}');
                          InheritedDataProvider.of(context).data.chowwow =
                              jsonDecode(response.body)["id"];
                          InheritedDataProvider.of(context).data.token = token;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return ShareScreen();
                            }),
                          );
                        }
                      }
                    },
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(height: 1, fontSize: 24),
                          ),
                          Text(
                            '(Requires Google Account)',
                            style: TextStyle(height: 1, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
          child: Text('Logout!'),
        ),
      ),
    );
  }
}
