import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class MyHomePage extends StatelessWidget {
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

    void selectWord(word) {
      appState.selectWord(word);
    }

    bool isLiked() {
      return favorites.contains(word);
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Word(word: word),
            SizedBox(height: 20),
            Controls(
              onLike: onLike,
              onNext: onNext,
              isLiked: isLiked(),
            ),
            SizedBox(height: 60),
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
              onPressed: () => appState.resetFavorits(),
              child: Text("Reset"),
            )
          ],
        ),
      ),
    );
  }
}

class LikedWord extends StatelessWidget {
  const LikedWord({
    super.key,
    required this.word,
    required this.isActive,
    required this.onClick,
  });

  final WordPair word;
  final bool isActive;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var bg = isActive ? theme.colorScheme.primary : theme.colorScheme.secondary;

    return SizedBox(
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
            ),
            onPressed: onClick,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(word.asCamelCase,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                  )),
            )),
      ),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.onLike,
    required this.onNext,
    required this.isLiked,
  });

  final void Function() onLike;
  final void Function() onNext;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (isLiked) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: onLike,
          icon: Icon(icon),
          label: Text('Like'),
        ),
        SizedBox(width: 15.0),
        ElevatedButton(
          onPressed: onNext,
          child: Text('Next'),
        ),
      ],
    );
  }
}

class Word extends StatelessWidget {
  const Word({
    super.key,
    required this.word,
  });

  final WordPair word;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var textStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.w900,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          word.asCamelCase,
          style: textStyle,
          semanticsLabel: "${word.first} ${word.second}",
        ),
      ),
    );
  }
}
