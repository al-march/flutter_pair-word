import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class WordCard extends StatelessWidget {
  const WordCard({
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