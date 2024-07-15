import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gamematch/global.dart';

class FavoriteSentRecivedScreen extends StatefulWidget {
  const FavoriteSentRecivedScreen({super.key});

  @override
  State<FavoriteSentRecivedScreen> createState() => _FavoriteSentRecivedScreenState();
}

class _FavoriteSentRecivedScreenState extends State<FavoriteSentRecivedScreen> {
  bool isFavoriteSentClicked = true;
  List<String> favoriteSentList = [];
  List<String> favoriteReceivedList = [];
  List<Map<String, dynamic>> favoriteList = [];

  getFavoriteListKeys() async{

    if(isFavoriteSentClicked){
      var favoriteSemtDocument = await FirebaseFirestore.instance.collection("Users").doc(currentUserID.toString()).collection("favoriteSemt").get();

      for(int i=0; i<favoriteSemtDocument.docs.length; i++){
        favoriteSentList.add(favoriteSemtDocument.docs[i].id);
      }

      print("favoriteSentList = " + favoriteSentList.toString());
      getKeyDataFromUserCollection(favoriteSentList);
    }else{
      var favoriteRecivedDocument = await FirebaseFirestore.instance.collection("Users").doc(currentUserID.toString()).collection("favoriteReceived").get();

      for(int i=0; i<favoriteRecivedDocument.docs.length; i++){
        favoriteReceivedList.add(favoriteRecivedDocument.docs[i].id);
      }

      print("favoriteReceivedList = " + favoriteReceivedList.toString());
      getKeyDataFromUserCollection(favoriteReceivedList);
    }
  }

  getKeyDataFromUserCollection(List<String> keysList) async{
    var allUsersDocument = await FirebaseFirestore.instance.collection("Users").get();

    for(int i=0; i<allUsersDocument.docs.length; i++){
      for(int k=0; k<keysList.length; k++){
        if(((allUsersDocument.docs[i].data() as dynamic)["uid"]) == keysList[k]){
          favoriteList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      favoriteList;
    });

    print("favoriteList = " + favoriteList.toString());

    @override
    void initState(){
      super.initState();

      getFavoriteListKeys();
    };

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){
                favoriteSentList.clear();
                favoriteSentList = [];
                favoriteReceivedList.clear();
                favoriteReceivedList = [];
                favoriteList.clear();
                favoriteList = [];

                setState(() {
                  isFavoriteSentClicked = true;
                });

                getFavoriteListKeys();
              },
              child: Text(
                "My Favorites",
                style: TextStyle(
                  color: isFavoriteSentClicked ? Colors.white : Colors.grey,
                  fontWeight: isFavoriteSentClicked ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),

            const Text("   |   ", style: TextStyle(color: Colors.grey,),),

            TextButton(
              onPressed: (){
                favoriteSentList.clear();
                favoriteSentList = [];
                favoriteReceivedList.clear();
                favoriteReceivedList = [];
                favoriteList.clear();
                favoriteList = [];

                setState(() {
                  isFavoriteSentClicked = false;
                });

                getFavoriteListKeys();
              },
              child: Text(
                "Im there Faavorite",
                style: TextStyle(
                  color: isFavoriteSentClicked ? Colors.grey : Colors.white,
                  fontWeight: isFavoriteSentClicked ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: favoriteList.isEmpty 
        ? const Center(
          child: Icon(Icons.person_off_sharp, color: Colors.white, size: 60,),
        ) 
        : GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(8),
          children: List.generate(favoriteList.length, (index){
            return GridTile(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
                  color: Colors.blue.shade200,
                  child: GestureDetector(
                    onTap: (){

                    },
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(favoriteList[index]["imageProfile"],),
                          fit: BoxFit.cover,
                        )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(favoriteList[index]["name"].toString() + " | " + favoriteList[index]["age"].toString(),
                                style: TextStyle(overflow: TextOverflow.ellipsis, color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),
                                ),
                              ),  

                              const SizedBox(height: 4,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
    );
  }
}