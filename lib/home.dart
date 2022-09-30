import 'package:flutter/material.dart';
import 'package:memory_game/choice_model.dart';
import 'package:memory_game/select_card.dart';

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

  // To generate A to H chars list
  List<Choice> generateAtoHList() {
    final choiceList = List.generate(
        8, (index) => Choice(title: String.fromCharCode(index + 65)));
    return choiceList;
  }

  // To generate shuffled list
  List<Choice> shuffleList() {
    List<Choice> list = [...generateAtoHList(), ...generateAtoHList()];
    list.shuffle();
    return list;
  }


  void gameLogic(int index) {

    if (pair.length < 2) {
      choices[index].visibility = VisibleState.VISIBLE; // Visible card on tap
      pair.add(choices[index]); // Add grid item in pair on tap of card
      setState(() {});
    }

    if (pair.length == 2) {
      if (enableTap) {
        enableTap = false; // Disable tap for 3 seconds to avoid multiple taps in between delay
        Future.delayed(const Duration(seconds: 3), () {
          if (pair[0].title == pair[1].title) { // if pair of card is matched then hide both paired cards
            pair[0].visibility = VisibleState.GONE;
            pair[1].visibility = VisibleState.GONE;
            matchCount++; // Total Matches
          } else {
            pair[0].visibility = VisibleState.INVISIBLE;
            pair[1].visibility = VisibleState.INVISIBLE;
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

// GONE is for hide card
// VISIBLE is for show character
// INVISIABLE is for hide character
enum VisibleState { GONE, VISIBLE, INVISIBLE }




