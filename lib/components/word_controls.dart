import 'package:flutter/material.dart';

class WordControls extends StatelessWidget {
  const WordControls({
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