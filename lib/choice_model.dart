import 'package:memory_game/home.dart';

class Choice {
  final String title;
  VisibleState visibility;

  Choice({required this.title, this.visibility = VisibleState.INVISIBLE});
}