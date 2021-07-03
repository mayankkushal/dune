import 'package:flutter/material.dart';

class TabBarItem extends StatelessWidget {
  const TabBarItem(
    this.text, {
    Key? key,
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
          height: double.infinity,
          width: 100,
          alignment: Alignment.center,
          child: Text(text)),
    );
  }
}
