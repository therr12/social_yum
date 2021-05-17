import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_yum/CreateJoin.dart';
import 'package:social_yum/inheritedData.dart';

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
                token: null,
                isHost: null,
              ));
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
  MyHomePage({Key? key}) : super(key: key);

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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('assets/images/logo.png'),
            ),
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
                          return Theme.of(context).buttonColor;
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
                      } else {
                        final GoogleSignInAccount? googleUser =
                            await GoogleSignIn().signIn();
                        if (googleUser != null) {
                          InheritedDataProvider.of(context)!.data.googleUser =
                              googleUser;
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;
                          // Create a new credential.
                          final OAuthCredential googleCredential =
                              GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );
                          // Sign in to Firebase with the Google [UserCredential].
                          googleUserCredential = await FirebaseAuth.instance
                              .signInWithCredential(googleCredential);
                        }
                      }

                      final token =
                          await FirebaseAuth.instance.currentUser!.getIdToken();
                      InheritedDataProvider.of(context)!.data.token = token;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return CreateJoin();
                        }),
                      );
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
