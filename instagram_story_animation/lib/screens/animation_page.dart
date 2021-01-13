import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:instagram_story_animation/database/contact_process.dart';
import 'package:instagram_story_animation/database/database_helper.dart';
import 'package:instagram_story_animation/models/person.dart';
import 'package:instagram_story_animation/utils/format_photo.dart';
import 'package:provider/provider.dart';

import 'add_contact_page.dart';

class AnimationScreen extends StatefulWidget {
  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashed Circle"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MultiProvider(providers: [
                          ChangeNotifierProvider.value(value: DatabaseHelper()),
                          ChangeNotifierProvider.value(value: FormatPhoto()),
                          ChangeNotifierProvider.value(value: ContactProcess()),
                        ], child: AddContactPage())));
              })
        ],
      ),
      body: AnimationPage(),
    );
  }
}

class AnimationPage extends StatefulWidget {
  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  List<Person> allPersonList;

  Animation dGap;
  Animation dBase;
  Animation dReverse;
  Animation<Color> dColorAnimation;
  AnimationController dController;
  bool isChange = false;

  @override
  void initState() {
    super.initState();
    animateDashedCircle();
  }

  @override
  void dispose() {
    dController.dispose();
    super.dispose();
  }

  void animateDashedCircle() {
    dController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    dBase = CurvedAnimation(parent: dController, curve: Curves.ease);
    dReverse = Tween<double>(begin: 0.0, end: -1.0).animate(dBase);
    dColorAnimation = ColorTween(begin: Colors.deepOrange, end: Colors.deepPurple).animate(dController);
    dGap = Tween<double>(begin: 3.0, end: 0.0).animate(dBase);
    dController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<DatabaseHelper>(context).getAllPersonsList(),
        builder: (context, AsyncSnapshot<List<Person>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            allPersonList = snapshot.data;
            return PageView.builder(
                              itemCount: allPersonList.length,
                itemBuilder: (context, index) {
                  animateDashedCircle();
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotationTransition(
                        turns: dReverse,
                        child: DashedCircle(
                          gapSize: dGap.value,
                          dashes: 30,
                          color: dColorAnimation.value,
                          child: RotationTransition(
                            turns: dBase,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircleAvatar(
                                //radius: 90,
                                radius: MediaQuery.of(context).size.width / 7,
                                backgroundImage: (allPersonList[index].personPhoto != null)
                                ? Provider.of<FormatPhoto>(context).memoryImageFromBase64String(allPersonList[index].personPhoto)
                                    : AssetImage("assets/blue_avatar.png"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(allPersonList[index].personDisplayName),
                      Text(allPersonList[index].personPhoneNumber),
                    ],
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
