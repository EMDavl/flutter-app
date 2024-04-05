import 'package:app/view/favorites_view.dart';
import 'package:app/view/video_view.dart';
import 'package:flutter/material.dart';

import '../repository/media_repository.dart';
import '../repository/post_repository.dart';
import 'feed_view.dart';

class HomeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _currentIndex = 1;

  late final List<Widget?> _screens = [
    VideoView(),
    FeedView(),
    FavoritesView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.video_call), label: "video"),
          BottomNavigationBarItem(
              icon: Icon(Icons.dynamic_feed_rounded), label: "feed"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "favorites"),
        ],
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.red,
        onTap: (idx) {
          if (idx == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => _screens[idx]! , maintainState: false));
            // TODO Починить переходы, чтобы при возвращении вкладка на которой были обновлялась
          } else {
            setState(() {
              _currentIndex = idx;
            });
          }
        },
      ),
    );
  }
}
