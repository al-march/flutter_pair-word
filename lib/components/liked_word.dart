import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

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
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: theme.colorScheme.onPrimary,
                    size: 12,
                  ),
                  SizedBox(width: 10),
                  Text(
                    word.asCamelCase,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
