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
  var favorites = <WordPair>[];
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    addToHistory(word);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    word = WordPair.random();
    notifyListeners();
  }

  void selectWord(WordPair updatedWord) {
    word = updatedWord;
    notifyListeners();
  }

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

  void addToHistory(WordPair w) {
    history.insert(0, w);
    notifyListeners();
  }

  WordPair getFromHistory(int index) {
    return history[index];
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
    var colorScheme = Theme.of(context).colorScheme;
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

    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
      ),
    );

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
            Expanded(child: mainArea),
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
          Expanded(
            flex: 3,
            child: HistoryList(),
          ),
          SizedBox(height: 10),
          WordCard(word: word),
          SizedBox(height: 10),
          WordControls(
            onLike: onLike,
            onNext: onNext,
            isLiked: isLiked(),
          ),
          Spacer(flex: 2),
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

    void selectWord(WordPair w) {
      state.selectWord(w);
      toMain();
    }

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
          Text("You have ${favorites.length} favorities"),
          SizedBox(height: 15),
          Column(
            children: [
              for (var w in favorites)
                LikedWord(
                  word: w,
                  isActive: w == word,
                  onClick: () => selectWord(w),
                ),
            ],
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

class HistoryList extends StatefulWidget {
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var state = context.watch<MyAppState>();
    state.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) =>
          HistoryList._maskingGradient.createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
          key: _key,
          reverse: true,
          padding: EdgeInsets.only(top: 100),
          initialItemCount: state.history.length,
          itemBuilder: (context, index, animation) {
            var word = state.getFromHistory(index);

            return SizeTransition(
              sizeFactor: animation,
              child: Center(
                child: TextButton.icon(
                  onPressed: () {
                    state.toggleFavorits(word);
                  },
                  icon: state.favorites.contains(word)
                      ? Icon(Icons.favorite, size: 12)
                      : SizedBox(),
                  label: Text(
                    word.asLowerCase,
                    semanticsLabel: word.asPascalCase,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
