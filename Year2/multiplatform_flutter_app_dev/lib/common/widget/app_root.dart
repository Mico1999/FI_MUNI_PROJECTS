import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:movie_catalog/common/util/shared_constants.dart';
import 'package:movie_catalog/common/widget/app_wrapper.dart';

final ValueNotifier selectedIndexGlobal = ValueNotifier(HOME_PAGE_INDEX);

class WidgetScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Catalog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AppWrapper(),
      scrollBehavior: WidgetScrollBehaviour(),
    );
  }
}
