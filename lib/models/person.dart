import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  // Personal Info
  String? uid;
  String? imageProfile;
  String? email;
  String? password;
  String? name;
  int? age;
  String? country;
  String? aboutme;

  // Games
  String? games;

  Person({
    this.uid,
    this.imageProfile,
    this.email,
    this.password,
    this.name,
    this.age,
    this.country,
    this.aboutme,
    this.games,
  });

  // Method to create a Person object from a DocumentSnapshot
  static Person fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;

    return Person(
      uid: dataSnapshot["uid"],
      imageProfile: dataSnapshot["imageProfile"],
      email: dataSnapshot["email"],
      password: dataSnapshot["password"],
      name: dataSnapshot["name"],
      age: dataSnapshot["age"],
      country: dataSnapshot["country"],
      aboutme: dataSnapshot["aboutme"],
      games: dataSnapshot["games"],
    );
  }

  // Method to convert Person object to JSON
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "imageProfile": imageProfile,
        "email": email,
        "password": password,
        "name": name,
        "age": age,
        "country": country,
        "aboutme": aboutme,
        "games": games,
      };
}
