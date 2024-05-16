import 'package:flutter/material.dart';
import 'package:movie_catalog/common/navigation/home_page_navigator.dart';
import 'package:movie_catalog/page/search_page.dart';

class SearchPageNavigator extends HomePageNavigator {
  const SearchPageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return commonRoutes(settings, SearchPage());
            });
      },
    );
  }
}
