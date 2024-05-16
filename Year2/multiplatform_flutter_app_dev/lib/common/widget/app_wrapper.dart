import 'package:flutter/material.dart';
import 'package:movie_catalog/common/navigation/profile_page_navigator.dart';
import 'package:movie_catalog/common/navigation/search_page_navigator.dart';
import 'package:movie_catalog/common/util/shared_constants.dart';

import 'package:movie_catalog/common/navigation/home_page_navigator.dart';
import 'package:movie_catalog/common/widget/app_root.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: selectedIndexGlobal,
        builder: (context, val, child) {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: BOTTOM_NAVIGATION_BAR_ITEMS,
              currentIndex: selectedIndexGlobal.value,
              onTap: (index) => {selectedIndexGlobal.value = index},
            ),
            body: SafeArea(
              top: false,
              child: IndexedStack(
                index: selectedIndexGlobal.value,
                children: const [
                  HomePageNavigator(),
                  SearchPageNavigator(),
                  ProfilePageNavigator()
                ],
              ),
            ),
          );
        });
  }
}
