import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InheritedDataProvider extends InheritedWidget {
  final Data data;
  InheritedDataProvider({
    Widget child,
    this.data,
  }) : super(child: child);
  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) =>
      data != oldWidget.data;
  static InheritedDataProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedDataProvider>();
}

class Data {
  GoogleSignInAccount googleUser;
  final String title;
  String chowwow;
  String token;
  final String base_url = 'chowwow.app';
  Data({this.googleUser, this.title, this.chowwow, this.token});
  String getGroupURL() {
    return base_url + '/' + chowwow;
  }
}

// class InheritedDataWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final data = InheritedDataProvider.of(context).data;
//     return Container(
//       child: Column(
//         children: <Widget>[
//           Text('Parent'),
//           Text('${data.text}'),
//           InheritedDataWidgetChild()
//         ],
//       ),
//     );
//   }
// }

// class InheritedDataWidgetChild extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final data = InheritedDataProvider.of(context).data;
//     return Container(
//       child: Column(
//         children: <Widget>[
//           Divider(),
//           Text('Child'),
//           Text('${data.text}'),
//           InheritedDataWidgetGrandchild()
//         ],
//       ),
//     );
//   }
// }
