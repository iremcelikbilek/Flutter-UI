import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactProcess with ChangeNotifier{
  List<Contact> _contacts = [];


  List<Contact> get contacts => _contacts;

  set contacts(List<Contact> value) {
    _contacts = value;
    notifyListeners();
  }



  Future<List<Contact>> getAllContacts() async {
    if (await Permission.contacts.request().isGranted) {
      _contacts = (await ContactsService.getContacts(withThumbnails: true, photoHighResolution: false)).toList();
    }
    return _contacts;
  }

}