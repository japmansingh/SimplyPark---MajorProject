import 'package:flutter/material.dart';

Widget circularProgress() {
  return Center(
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.purple),
          )),
    );
}

Widget linearProgress() {
  return Scaffold(
    body: Container(
      padding: EdgeInsets.only(bottom: 10.0),
      child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.purple),
      ),
    ),
  );
}