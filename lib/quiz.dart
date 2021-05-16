import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_yum/campfire.dart';
import 'package:social_yum/inheritedData.dart';

class Quiz extends StatefulWidget {
  Quiz(this.questions, {Key? key}) : super(key: key);
  List<dynamic> questions;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _QuizState createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int _questionNumber = 0;
  List<String> answers = [];
  Data? data;

  void _answerQuestion(String answer) async {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      answers.add(answer);
      _questionNumber++;
    });
    if (_questionNumber == widget.questions.length) {
      String encodedAnswers = Uri.encodeComponent(jsonEncode(answers));
      var url = Uri.parse('https://api.chowwow.app/api/v1/chowwow/' +
          data!.chowwow! +
          '/survey?token=' +
          data!.token! +
          '&responses=' +
          encodedAnswers);
      var response = await http.patch(url);
      print(response.body);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Campfire(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    this.data = InheritedDataProvider.of(context)!.data;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('test'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Question(
                onAnswered: _answerQuestion,
                questionText: widget.questions[
                        min(_questionNumber, widget.questions.length - 1)]
                    ["question"],
                choices: widget.questions[
                        min(_questionNumber, widget.questions.length - 1)]
                        ["choices"]
                    .cast<String>()),
          ),
          Text("$_questionNumber"),
          Text("$answers"),
        ],
      ),
    );
  }
}

class Question extends StatelessWidget {
  final void Function(String) onAnswered;
  final String questionText;
  final List<String> choices;

  const Question({
    Key? key,
    required void Function(String) onAnswered,
    required String questionText,
    required List<String> choices,
  })   : this.onAnswered = onAnswered,
        this.questionText = questionText,
        this.choices = choices,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String answer = 'blah';
    var responseButtons = this
        .choices
        .map((answer) => ResponseButton(onAnswered: onAnswered, answer: answer))
        .toList();

    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            questionText,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
          Column(
            children: responseButtons,
          )
          // Container(
          //   height: 300,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       Expanded(
          //         child: Container(
          //           height: 200,
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: ElevatedButton(
          //               onPressed: () {
          //                 onAnswered(0);
          //               },
          //               child: Text(
          //                 choiceLeft,
          //                 style: Theme.of(context).textTheme.headline4,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Container(
          //           height: 200,
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: ElevatedButton(
          //               onPressed: () {
          //                 onAnswered(1);
          //               },
          //               child: Text(
          //                 choiceRight,
          //                 style: Theme.of(context).textTheme.headline4,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ResponseButton extends StatelessWidget {
  const ResponseButton({
    Key? key,
    required this.onAnswered,
    required this.answer,
  }) : super(key: key);

  final void Function(String p1) onAnswered;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          onAnswered(answer);
        },
        child: Text(answer));
  }
}
