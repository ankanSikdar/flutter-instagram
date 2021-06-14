import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String content;

  const ErrorDialog({
    Key key,
    this.title = 'ERROR',
    @required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? _showAndroidDialog(context)
        : _showiOSDialog(context);
  }

  AlertDialog _showAndroidDialog(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Ok'),
        ),
      ],
    );
  }

  CupertinoAlertDialog _showiOSDialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
