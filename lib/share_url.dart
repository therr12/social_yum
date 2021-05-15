import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareURL extends StatelessWidget {
  const ShareURL({
    Key key,
    @required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            url,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url));
              },
              child: Text("copy")),
        ),
      ],
    );
  }
}
