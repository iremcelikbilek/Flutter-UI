import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:instagram_story_animation/database/contact_process.dart';
import 'package:instagram_story_animation/database/database_helper.dart';
import 'package:instagram_story_animation/models/person.dart';
import 'package:instagram_story_animation/utils/format_photo.dart';
import 'package:provider/provider.dart';

class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
      ),
      body: BodyPart(),
    );
  }
}

class BodyPart extends StatelessWidget {
  List<Contact> myContact;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ContactProcess>(context).getAllContacts(),
        builder: (context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            myContact = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: myContact.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Uint8List uInt8ListAvatarImage =
                              myContact[index].avatar;
                          try {
                            Provider.of<DatabaseHelper>(context, listen: false)
                                .addPersonToPersonTableAtDb(Person(
                                    personDisplayName:
                                        myContact[index].displayName,
                                    personPhoneNumber: myContact[index]
                                        .phones
                                        .elementAt(0)
                                        .value,
                                    personPhoto: (uInt8ListAvatarImage != null)
                                        ? Provider.of<FormatPhoto>(context,
                                                listen: false)
                                            .base64String(uInt8ListAvatarImage)
                                        : ""));
                          } catch (error) {
                            print("Catch error bloğundayım");
                            print('Database error : $error');
                          }

                          Navigator.of(context).pop();
                        },
                        child: (myContact[index].avatar != null)
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage: MemoryImage(myContact[index].avatar))
                            : CircleAvatar(
                                radius: 60,
                                child: Text(myContact[index].initials(),
                                  style: TextStyle(color: Colors.black,),
                                ),
                              ),
                      ),
                      Text(
                        myContact[index].displayName == null
                            ? "No Name"
                            : myContact[index].displayName,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                       myContact[index].phones.length == 0
                            ? "No Phone"
                            : (myContact[index].phones.elementAt(0).value),
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        myContact[index].emails.isEmpty
                            ? "No Email"
                            : myContact[index].emails.elementAt(0).value,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
