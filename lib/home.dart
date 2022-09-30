import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Choice> choices;
  List<Choice> pair = [];
  bool enableTap = true;
  int matchCount = 0;
  int attemptCount = 0;

  @override
  void initState() {
    choices = shuffleList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          GridView.builder(
            // primary: false,
            shrinkWrap: true,
            itemCount: 16,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {
                    gameLogic(index);
                  },
                  child: SelectCard(choice: choices[index]));
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Attempts: $attemptCount',
                    style: const TextStyle(fontSize: 22)),
                Text('Matches: $matchCount',
                    style: const TextStyle(fontSize: 22))
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Choice> generateAtoHList() {
    final choiceList = List.generate(
        8, (index) => Choice(title: String.fromCharCode(index + 65)));
    return choiceList;
  }

  List<Choice> shuffleList() {
    List<Choice> list = [...generateAtoHList(), ...generateAtoHList()];
    list.shuffle();
    return list;
  }

  void gameLogic(int index) {
    if (pair.length < 2) {
      choices[index].visibility = VisibleState.VISIABLE;
      pair.add(choices[index]);
      setState(() {});
    }

    if (pair.length == 2) {
      if (enableTap) {
        enableTap = false; // Disable tap for 3 seconds to avoid multiple taps in between delay
        Future.delayed(const Duration(seconds: 3), () {
          if (pair[0].title == pair[1].title) {
            pair[0].visibility = VisibleState.GONE;
            pair[1].visibility = VisibleState.GONE;
            matchCount++; // Total Matches
          } else {
            pair[0].visibility = VisibleState.INVISIABLE;
            pair[1].visibility = VisibleState.INVISIABLE;
          }
          attemptCount++; // Total Attempts
          pair.clear(); // If pair is full then clear it
          setState(() {});
          enableTap = true; // Enable tap after delay
        });
      }
    }
  }
}

enum VisibleState { GONE, VISIABLE, INVISIABLE }

class Choice {
  final String title;
  VisibleState visibility;

  Choice({required this.title, this.visibility = VisibleState.INVISIABLE});
}

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
            visible: choice.visibility == VisibleState.VISIABLE,
            child: Center(
              child: Text(choice.title, style: textStyle),
            ),
          )),
    );
  }
}
