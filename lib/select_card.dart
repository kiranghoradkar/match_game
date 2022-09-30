import 'package:flutter/material.dart';
import 'package:memory_game/choice_model.dart';
import 'package:memory_game/home.dart';

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.headline4;
    return Visibility(
      visible: choice.visibility != VisibleState.GONE,
      child: Card(
          color: Colors.orange,
          child: Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: choice.visibility == VisibleState.VISIBLE,
            child: Center(
              child: Text(choice.title, style: textStyle),
            ),
          )),
    );
  }
}