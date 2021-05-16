import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_yum/share_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
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
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'chow.wow',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            home: MyHomePage(title: 'chow.wow'),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          title: 'loading',
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: Text("Loading"),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

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
                      final GoogleSignInAccount googleUser =
                          await GoogleSignIn().signIn();
                      if (googleUser != null) {
                        final GoogleSignInAuthentication googleAuth =
                            await googleUser.authentication;
                        // Create a new credential.
                        final GoogleAuthCredential googleCredential =
                            GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        // Sign in to Firebase with the Google [UserCredential].
                        final UserCredential googleUserCredential =
                            await FirebaseAuth.instance
                                .signInWithCredential(googleCredential);
                        // final token = await FirebaseAuth.instance.currentUser
                        //     .getIdToken();
                        // var url = Uri.parse(
                        //     'https://api.chowwow.app/api/v1/chowwow?uid=' +
                        //         token);
                        // // for creating a chowwow: http.put uid=token
                        // // for joining a chowwow: http.patch cid=id&uid=token
                        // var response = await http.put(url);
                        // print('Response status: ${response.statusCode}');
                        // print('Response body: ${response.body}');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShareScreen(
                                  title: widget.title, user: googleUser)),
                        );
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
