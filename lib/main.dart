import 'package:flutter/material.dart';
import 'package:spotify_favorites/ui/screens/home_page.dart';
import 'package:spotify_favorites/utils/theme.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Favorites',
      debugShowCheckedModeBanner: false,
      theme: mainTheme(),
      home: HomePage(),
    );
  }
}
