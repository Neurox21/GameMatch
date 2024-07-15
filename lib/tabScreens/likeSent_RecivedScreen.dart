import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gamematch/global.dart';

class LikeSentRecivedScreen extends StatefulWidget {
  const LikeSentRecivedScreen({super.key});

  @override
  State<LikeSentRecivedScreen> createState() => _LikeSentRecivedScreenState();
}

class _LikeSentRecivedScreenState extends State<LikeSentRecivedScreen> {
  bool isLikeSentClicked = true;
  List<String> likeSentList = [];
  List<String> likeReceivedList = [];
  List<Map<String, dynamic>> likeList = [];

  getLikeListKeys() async{

    if(isLikeSentClicked){
      var favoriteSemtDocument = await FirebaseFirestore.instance.collection("Users").doc(currentUserID.toString()).collection("likeSent").get();

      for(int i=0; i<favoriteSemtDocument.docs.length; i++){
        likeSentList.add(favoriteSemtDocument.docs[i].id);
      }

      print("likeSentList = " + likeSentList.toString());
      getKeyDataFromUserCollection(likeSentList);
    }else{
      var favoriteRecivedDocument = await FirebaseFirestore.instance.collection("Users").doc(currentUserID.toString()).collection("likeReceived").get();

      for(int i=0; i<favoriteRecivedDocument.docs.length; i++){
        likeReceivedList.add(favoriteRecivedDocument.docs[i].id);
      }

      print("likeReceivedList = " + likeReceivedList.toString());
      getKeyDataFromUserCollection(likeReceivedList);
    }
  }

  getKeyDataFromUserCollection(List<String> keysList) async{
    var allUsersDocument = await FirebaseFirestore.instance.collection("Users").get();

    for(int i=0; i<allUsersDocument.docs.length; i++){
      for(int k=0; k<keysList.length; k++){
        if(((allUsersDocument.docs[i].data() as dynamic)["uid"]) == keysList[k]){
          likeList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      likeList;
    });

    print("likeList = " + likeList.toString());

    @override
    void initState(){
      super.initState();

      getLikeListKeys();
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
                likeSentList.clear();
                likeSentList = [];
                likeReceivedList.clear();
                likeReceivedList = [];
                likeList.clear();
                likeList = [];

                setState(() {
                  isLikeSentClicked = true;
                });

                getLikeListKeys();
              },
              child: Text(
                "My Likes",
                style: TextStyle(
                  color: isLikeSentClicked ? Colors.white : Colors.grey,
                  fontWeight: isLikeSentClicked ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),

            const Text("   |   ", style: TextStyle(color: Colors.grey,),),

            TextButton(
              onPressed: (){
                likeSentList.clear();
                likeSentList = [];
                likeReceivedList.clear();
                likeReceivedList = [];
                likeList.clear();
                likeList = [];

                setState(() {
                  isLikeSentClicked = false;
                });

                getLikeListKeys();
              },
              child: Text(
                "Liked Me",
                style: TextStyle(
                  color: isLikeSentClicked ? Colors.grey : Colors.white,
                  fontWeight: isLikeSentClicked ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: likeList.isEmpty 
        ? const Center(
          child: Icon(Icons.person_off_sharp, color: Colors.white, size: 60,),
        ) 
        : GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(8),
          children: List.generate(likeList.length, (index){
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
                          image: NetworkImage(likeList[index]["imageProfile"],),
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
                                child: Text(likeList[index]["name"].toString() + " | " + likeList[index]["age"].toString(),
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