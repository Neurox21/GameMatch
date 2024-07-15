import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gamematch/global.dart';
import 'package:gamematch/models/person.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);
  List<Person> get allUsersProfileList => usersProfileList.value;

  getResults(){
    onInit();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    
    if (chosenCountry == null || chosenAge == null){
      usersProfileList.bindStream(
        FirebaseFirestore.instance.collection("Users").where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots().map((QuerySnapshot queryDataSnapshot){
          List<Person> profileList = [];

          for(var eachProfile in queryDataSnapshot.docs){
            profileList.add(Person.fromDataSnapshot(eachProfile));
          }

          return profileList;
        })
      );
    } else {
      usersProfileList.bindStream(
        FirebaseFirestore.instance.collection("Users").where("age", isGreaterThanOrEqualTo: int.parse(chosenAge.toString()))
        .where("country", isEqualTo: chosenCountry.toString()).snapshots().map((QuerySnapshot queryDataSnapshot){
          List<Person> profileList = [];

          for(var eachProfile in queryDataSnapshot.docs){
            profileList.add(Person.fromDataSnapshot(eachProfile));
          }

          return profileList;
        })
      );
    }
    
  }

  favoriteSentRecived(String toUserID, String senderName) async{
    var document = FirebaseFirestore.instance.collection("Users").doc(toUserID).collection("favoriteReceived").doc(currentUserID);

    var docSnapshot = await document.get();
    //remove the favorite from database
    if (docSnapshot.exists) {
      //remove currentuser from the favoriteReceived list of that profile person
      await FirebaseFirestore.instance.collection("Users").doc(toUserID).collection("favoriteReceived").doc(currentUserID).delete();

      //remove profile person from the favoriteSent list of the correntuser
      await FirebaseFirestore.instance.collection("Users").doc(currentUserID).collection("favoriteSemt").doc(toUserID).delete();

    }else{ //mark as favorite in database
      //add currentuser to the favoriteReceived list 
      await FirebaseFirestore.instance.collection("Users").doc(toUserID).collection("favoriteReceived").doc(currentUserID).set({});

      //add profile person to the favoriteSent list
      await FirebaseFirestore.instance.collection("Users").doc(currentUserID).collection("favoriteSemt").doc(toUserID).set({});

    //  sendNotificationToUser(toUserID, "favorite", senderName);
    }

    update();
  }

  LikeSentRecived(String toUserID, String senderName) async{
    var document = FirebaseFirestore.instance.collection("Users").doc(toUserID).collection("likeReceived").doc(currentUserID);

    var docSnapshot = await document.get();
    //remove the like from database
    if (docSnapshot.exists) {
      //remove currentuser from the likeReceived list of that profile person
      await FirebaseFirestore.instance.collection("Users").doc(toUserID).collection("likeReceived").doc(currentUserID).delete();

      //remove profile person from the likeSent list of the correntuser
      await FirebaseFirestore.instance.collection("Users").doc(currentUserID).collection("likeSent").doc(toUserID).delete();

    }else{ //mark as like in database
      //add currentuser to the likeReceived list 
      await FirebaseFirestore.instance.collection("Users").doc(toUserID).collection("likeReceived").doc(currentUserID).set({});

      //add profile person to the likeSent list
      await FirebaseFirestore.instance.collection("Users").doc(currentUserID).collection("likeSent").doc(toUserID).set({});

    //  sendNotificationToUser(toUserID, "like", senderName);
    }

    update();
  }

  ViewSentRecived(String toUserID, String senderName) async{
    var document = FirebaseFirestore.instance.collection("Users").doc(toUserID).collection("viewReceived").doc(currentUserID);

    var docSnapshot = await document.get();
    //remove the view from database
    if (docSnapshot.exists) {
      
      print("already in view list");

    }else{ //mark as like in database
      //add currentuser to the viewReceived list 
      await FirebaseFirestore.instance.collection("Users").doc(toUserID).collection("viewReceived").doc(currentUserID).set({});

      //add profile person to the viewSent list
      await FirebaseFirestore.instance.collection("Users").doc(currentUserID).collection("viewSent").doc(toUserID).set({});

    //  sendNotificationToUser(toUserID, "view", senderName);
    }

    update();
  }

  //sendNotificationToUser(receiverID, featureType, senderName) async{
  //  String userDeviceToken = "";
  //  await FirebaseFirestore.instance.collection("users").doc(receiverID).get().then((snapshot){
  //    if(snapshot.data()!["userDeviceToken"] != null){
  //      userDeviceToken = snapshot.data()!["userDeviceToken"].toString();
  //   }
  //  });

  //  notificationFormat(userDeviceToken, receiverID, featureType, senderName);
  //}

  //notificationFormat(userDeviceToken, receiverID, featureType, senderName){
  //  Map<String, String> headerNotification = {
  //    "Content-Type" : "application/json",
  //    "Authorization" : 
  //  }
  //}
}