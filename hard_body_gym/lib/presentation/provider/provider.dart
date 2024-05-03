import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hard_body_gym/models/person.dart';
import 'package:hard_body_gym/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class DataService extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  set user(User? value) {
    _user = value;
    notifyListeners();
  }

  List<Person> persons = [];

  Person? _person;
  Person? get person => _person;
  set person(Person? value) {
    _person = value;
    notifyListeners();
  }

  final ImagePicker _picker = ImagePicker();

  int get random => Random().nextInt(999) + 100;

  Future<XFile?> pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<String?> uploadImage(final File? file) async {
    if (file == null) return null;
    final user = this.user;
    if (user == null) return null;
    final date = DateTime.now().microsecondsSinceEpoch;

    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance.ref().child('persons').child('/$random-${user.idUser}-$date.jpg');
    await ref.putFile(file);
    final value = await ref.getDownloadURL();
    print(value);
    return value;
  }
}
