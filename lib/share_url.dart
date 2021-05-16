import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareURL extends StatelessWidget {
  const ShareURL({
    Key? key,
    required this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border(
            top: BorderSide(width: 5.0, color: Colors.grey),
            left: BorderSide(width: 5.0, color: Colors.grey),
            right: BorderSide(width: 5.0, color: Colors.grey),
            bottom: BorderSide(width: 5.0, color: Colors.grey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                url,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: url));
                },
                child: Icon(
                  Icons.content_copy_rounded,
                  color: Colors.orange,
                  size: 20.0,
                ),
                // content_copy_rounded
              ),
            ),
          ],
        ),
      ),
    );
  }
}
