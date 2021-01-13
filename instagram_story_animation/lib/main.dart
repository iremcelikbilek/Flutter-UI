import 'package:flutter/material.dart';
import 'package:instagram_story_animation/database/database_helper.dart';
import 'package:instagram_story_animation/screens/animation_page.dart';
import 'package:instagram_story_animation/utils/format_photo.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: DatabaseHelper()),
        ChangeNotifierProvider.value(value: FormatPhoto()),
      ],
      child: AnimationScreen(),
    ),
  ));
}
