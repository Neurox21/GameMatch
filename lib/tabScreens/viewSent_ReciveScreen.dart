import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gamematch/global.dart';

class ViewSentRecivedScreen extends StatefulWidget {
  const ViewSentRecivedScreen({super.key});

  @override
  State<ViewSentRecivedScreen> createState() => _ViewSentRecivedScreenState();
}

class _ViewSentRecivedScreenState extends State<ViewSentRecivedScreen> {
  bool isViewSentClicked = true; 
  List<String> viewSentList = [];
  List<String> viewReceivedList = [];
  List<Map<String, dynamic>> viewList = [];

  getviewListKeys() async{

    if(isViewSentClicked){
      var favoriteSemtDocument = await FirebaseFirestore.instance.collection("Users").doc(currentUserID.toString()).collection("viewSent").get();

      for(int i=0; i<favoriteSemtDocument.docs.length; i++){
        viewSentList.add(favoriteSemtDocument.docs[i].id);
      }

      print("viewSentList = " + viewSentList.toString());
      getKeyDataFromUserCollection(viewSentList);
    }else{
      var favoriteRecivedDocument = await FirebaseFirestore.instance.collection("Users").doc(currentUserID.toString()).collection("viewReceived").get();

      for(int i=0; i<favoriteRecivedDocument.docs.length; i++){
        viewReceivedList.add(favoriteRecivedDocument.docs[i].id);
      }

      print("viewReceivedList = " + viewReceivedList.toString());
      getKeyDataFromUserCollection(viewReceivedList);
    }
  }

  getKeyDataFromUserCollection(List<String> keysList) async{
    var allUsersDocument = await FirebaseFirestore.instance.collection("Users").get();

    for(int i=0; i<allUsersDocument.docs.length; i++){
      for(int k=0; k<keysList.length; k++){
        if(((allUsersDocument.docs[i].data() as dynamic)["uid"]) == keysList[k]){
          viewList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      viewList;
    });

    print("viewList = " + viewList.toString());

    @override
    void initState(){
      super.initState();

      getviewListKeys();
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
                viewSentList.clear();
                viewSentList = [];
                viewReceivedList.clear();
                viewReceivedList = [];
                viewList.clear();
                viewList = [];

                setState(() {
                  isViewSentClicked = true;
                });

                getviewListKeys();
              },
              child: Text(
                "My Views",
                style: TextStyle(
                  color: isViewSentClicked ? Colors.white : Colors.grey,
                  fontWeight: isViewSentClicked ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),

            const Text("   |   ", style: TextStyle(color: Colors.grey,),),

            TextButton(
              onPressed: (){
                viewSentList.clear();
                viewSentList = [];
                viewReceivedList.clear();
                viewReceivedList = [];
                viewList.clear();
                viewList = [];

                setState(() {
                  isViewSentClicked = false;
                });

                getviewListKeys();
              },
              child: Text(
                "Viewed Me",
                style: TextStyle(
                  color: isViewSentClicked ? Colors.grey : Colors.white,
                  fontWeight: isViewSentClicked ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: viewList.isEmpty 
        ? const Center(
          child: Icon(Icons.person_off_sharp, color: Colors.white, size: 60,),
        ) 
        : GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(8),
          children: List.generate(viewList.length, (index){
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
                          image: NetworkImage(viewList[index]["imageProfile"],),
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
                                child: Text(viewList[index]["name"].toString() + " | " + viewList[index]["age"].toString(),
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