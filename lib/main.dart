import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/word_controls.dart';
import 'components/liked_word.dart';
import 'components/word_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var word = WordPair.random();

  void getNext() {
    word = WordPair.random();
    notifyListeners();
  }

  void selectWord(WordPair updatedWord) {
    word = updatedWord;
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorits(WordPair word) {
    if (favorites.contains(word)) {
      favorites.remove(word);
    } else {
      favorites.add(word);
    }
    notifyListeners();
  }

  void resetFavorits() {
    favorites = <WordPair>[];
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  void toMain() {
    setState(() {
      selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();
    var favorites = state.favorites;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = LikedWordsPage(toMain: toMain);
        break;
      default:
        page = NotFoundPage(goHome: toMain);
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Badge(
                      label: Text(favorites.length.toString()),
                      child: Icon(Icons.favorite),
                    ),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var word = appState.word;
    var favorites = appState.favorites;

    void onNext() {
      appState.getNext();
    }

    void onLike() {
      appState.toggleFavorits(word);
    }

    bool isLiked() {
      return favorites.contains(word);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WordCard(word: word),
          SizedBox(height: 20),
          WordControls(
            onLike: onLike,
            onNext: onNext,
            isLiked: isLiked(),
          ),
        ],
      ),
    );
  }
}

class LikedWordsPage extends StatelessWidget {
  const LikedWordsPage({super.key, required this.toMain});

  final void Function() toMain;

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();
    var word = state.word;
    var favorites = state.favorites;

    void selectWord(WordPair w) {}

    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No favorites"),
            ElevatedButton(
              onPressed: toMain,
              child: Text("Return"),
            )
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: favorites
                .map((w) => LikedWord(
                      word: w,
                      isActive: w == word,
                      onClick: () => selectWord(w),
                    ))
                .toList(),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => state.resetFavorits(),
            child: Text("Reset"),
          )
        ],
      ),
    );
  }
}

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({
    super.key,
    required this.goHome,
  });

  final void Function() goHome;

  @override
  Widget build(BuildContext _) {
    return Column(
      children: [
        Text("Page not found"),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: goHome,
          child: Text("Main page"),
        )
      ],
    );
  }
}
