import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';

class MovieStoryLine extends StatelessWidget {
  final String storyLine;

  const MovieStoryLine({super.key, required this.storyLine});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Story line',
          style: textTheme.titleMedium,
        ),
        const SizedBox(height: 8.0),
        ExpandableText(
          storyLine,
          expandText: "show more",
          collapseText: "show less",
          maxLines: 3,
          linkColor: Colors.deepOrange,
          style: textTheme.titleMedium,
        )
      ]),
    );
  }
}
