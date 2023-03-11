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

    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
      fontWeight: FontWeight.w900,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window
          // is too narrow.
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  upperFirstLetter(word.first),
                  style: style.copyWith(fontWeight: FontWeight.w200, letterSpacing: -2),
                ),
                Text(
                  upperFirstLetter(word.second),
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String upperFirstLetter(String word) {
  var letterList = word.split("");
  return letterList.first.toUpperCase() + letterList.sublist(1).join("");
}
