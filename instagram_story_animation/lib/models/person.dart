import "package:flutter/material.dart";

class Person {
  int personID;
  String personDisplayName;
  String personPhoneNumber;
  String personPhoto;
  //
  //
  String imgPath;
  Color cardColor;

  Person({
    this.personDisplayName,
    this.personPhoneNumber,
    this.personPhoto,
  });

  Person.withID(
      {this.personID,
        this.personDisplayName,
        this.personPhoneNumber,
        this.personPhoto});

  Map<String, dynamic> personToMap() {
    var personMap = Map<String, dynamic>();
    personMap["personID"] = this.personID;
    personMap["personDisplayName"] = this.personDisplayName;
    personMap["personPhoneNumber"] = this.personPhoneNumber;
    personMap["personPhoto"] = this.personPhoto;

    return personMap;
  }

  Person.fromMap(Map<String, dynamic> sourcePersonMap) {
    this.personID = sourcePersonMap["personID"];
    this.personDisplayName = sourcePersonMap["personDisplayName"];
    this.personPhoneNumber = sourcePersonMap["personPhoneNumber"];
    this.personPhoto = sourcePersonMap["personPhoto"];
  }
}
