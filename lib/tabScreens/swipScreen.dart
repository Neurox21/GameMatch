import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gamematch/Controlers/profile-controller.dart';
import 'package:gamematch/global.dart';
import 'package:gamematch/tabScreens/user_detailsScreen.dart';
import 'package:gamematch/tabScreens/ChatScreen.dart'; // Importe a nova tela de chat
import 'package:get/get.dart';

class SwipScreen extends StatefulWidget {
  const SwipScreen({super.key});

  @override
  State<SwipScreen> createState() => _SwipScreenState();
}

class _SwipScreenState extends State<SwipScreen> {
  ProfileController profileController = Get.put(ProfileController());
  String senderName = "";

  applyFilter() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Matching Filter"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("who lives in:"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DropdownButton<String>(
                      hint: const Text('Select country'),
                      value: chosenCountry,
                      underline: Container(),
                      items: [
                        'Portugal', 'Spain', 'France', 'Germany', 'United Kingdom',
                        'USA', 'Canada', 'Australia', 'Rome', 'Ukraine',
                      ].map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          chosenCountry = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                  const Text("who's age is equal to or above:"),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DropdownButton<String>(
                      hint: const Text('Select age'),
                      value: chosenAge,
                      underline: Container(),
                      items: [
                        '18', '20', '25', '30', '35', '40',
                        '45', '50', '55',
                      ].map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          chosenAge = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    profileController.getResults();
                  },
                  child: const Text("Done")
                )
              ],
            );
          },
        );
      },
    );
  }

  readcurrentUserData() async {
    await FirebaseFirestore.instance.collection("Users").doc(currentUserID).get().then((dataSnapshot) {
      setState(() {
        senderName = dataSnapshot.data()!["name"].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readcurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return PageView.builder(
          itemCount: profileController.allUsersProfileList.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final eachProfileInfo = profileController.allUsersProfileList[index];
            return DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    eachProfileInfo.imageProfile.toString(),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Filter Icon Button
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: IconButton(
                          onPressed: () {
                            applyFilter();
                          },
                          icon: const Icon(
                            Icons.filter_list,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // User Data
                    GestureDetector(
                      onTap: () {
                        profileController.ViewSentRecived(eachProfileInfo.uid.toString(), senderName);
                        // send user to profile person userDetailScreen
                        Get.to(UserDetailsScreen(userID: eachProfileInfo.uid,));
                      },
                      child: Column(
                        children: [
                          // name
                          Text(
                            eachProfileInfo.name.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // age
                          Text(
                            eachProfileInfo.age.toString() + ' ◉ ' + eachProfileInfo.country.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 4,
                            ),
                          ),

                          // Games
                          Text(
                            eachProfileInfo.games.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 4,
                            ),
                          ),

                          // image buttons - favorites - chat - like
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // favorite
                              GestureDetector(
                                onTap: () {
                                  profileController.favoriteSentRecived(
                                    eachProfileInfo.uid.toString(),
                                    senderName,
                                  );
                                },
                                child: Image.asset(
                                  "images/Favorite.png",
                                  width: 60,
                                ),
                              ),
                              // chat
                              GestureDetector(
                                onTap: () {
                                  Get.to(ChatScreen(
                                    recipientId: eachProfileInfo.uid.toString(),
                                    recipientName: eachProfileInfo.name.toString(),
                                    senderName: senderName,  // Passe o senderName aqui
                                    currentUserID: currentUserID,  // Passe o currentUserID aqui
                                  ));
                                },
                                child: Image.asset(
                                  "images/chat.png",
                                  width: 80,
                                ),
                              ),
                              // like
                              GestureDetector(
                                onTap: () {
                                  profileController.LikeSentRecived(
                                    eachProfileInfo.uid.toString(),
                                    senderName,
                                  );
                                },
                                child: Image.asset(
                                  "images/like.png",
                                  width: 60,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}