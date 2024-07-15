import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamematch/tabScreens/favoriteSent_ReciveScreen.dart';
import 'package:gamematch/tabScreens/likeSent_RecivedScreen.dart';
import 'package:gamematch/tabScreens/swipScreen.dart';
import 'package:gamematch/tabScreens/user_detailsScreen.dart';
import 'package:gamematch/tabScreens/viewSent_ReciveScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;

  List tabScreensList = [SwipScreen(),ViewSentRecivedScreen(),FavoriteSentRecivedScreen(),LikeSentRecivedScreen(),UserDetailsScreen(userID: FirebaseAuth.instance.currentUser!.uid,)];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (indexNumber){
          setState(() {
            screenIndex = indexNumber;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white24,
        currentIndex: screenIndex,
        items: const [
          //SwipScreen
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size:30),
            label: "",
          ),

          //ViewSentRecivedScreen
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye, size:30),
            label: "",
          ),

          //FavoriteSentRecivedScreen
          BottomNavigationBarItem(
            icon: Icon(Icons.star, size:30),
            label: "",
          ),

          //LikeSentRecivedScreen
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size:30),
            label: "",
          ),

          //UserDetailScreen
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size:30),
            label: "",
          ),
        ],
      ),

      body: tabScreensList[screenIndex],
    );
  }
}