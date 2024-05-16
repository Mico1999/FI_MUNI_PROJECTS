import 'package:flutter/material.dart';
import 'package:movie_catalog/common/widget/page_template.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageTemplate(
      title: "Page not found",
      child: Center(
        child: Text("Ups something went wrong....Not existing route!"),
      ),
    );
  }
}
