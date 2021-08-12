import 'package:flutter/material.dart';

class ShowMyDialog {
  ShowMyDialog(
      {BuildContext context,
      String title,
      String message,
      List<String> actions,
      Function(String value) onPressed,
      bool pop}) {
    actions = actions != null ? actions : ["Ok"];

    List<Widget> buttons = <Widget>[];
    for (String action in actions) {
      buttons.add(TextButton(
        child: Text(action),
        onPressed: () {
          if (onPressed != null) onPressed(action);
          if (pop == null || pop) Navigator.of(context).pop();
        },
      ));
    }

    AlertDialog alert = AlertDialog(
      title: Text(title ?? ""),
      content: Text(message ?? ""),
      actions: buttons,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class ShowLoadingDialog {
  ShowLoadingDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
