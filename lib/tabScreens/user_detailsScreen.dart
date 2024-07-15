import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gamematch/global.dart';
import 'package:gamematch/tabScreens/ChatListeScreen.dart';
import 'package:get/get.dart';

@immutable
class UserDetailsScreen extends StatefulWidget {
  String? userID;

  UserDetailsScreen({Key? key, this.userID}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  // Perfil
  String name = "";
  String age = "";
  String country = "";
  String aboutme = "";
  String profileImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/gamematch-f4787.appspot.com/o/Place%20Holder%2FGameMatch.png?alt=media&token=82a7760e-f572-4da1-b55d-f6cab7d049c9";
  String games = ""; // Lista para armazenar os jogos

  retriveUserInfo() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.userID)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        if (snapshot.data()!["imageProfile"] != null) {
          setState(() {
            profileImageUrl = snapshot.data()!["imageProfile"];
          });
        }

        setState(() {
          name = snapshot.data()!["name"];
          age = snapshot.data()!["age"].toString();
          country = snapshot.data()!["country"];
          aboutme = snapshot.data()!["aboutme"];
          // Carregar os jogos do usuário
          if (snapshot.data()!["games"] != null) {
            games = snapshot.data()!["games"];
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    retriveUserInfo();
  }

  Future<bool> _onWillPop() async {
    if (widget.userID == currentUserID) {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Do you really want to log out?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: widget.userID == currentUserID ? false : true,
          actions: [
            if (widget.userID == currentUserID)
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navegar para a tela de lista de chats
                      Get.to(ChatListScreen(
                        currentUserID: currentUserID,
                        senderName: name,
                      ));
                    },
                    icon: const Icon(Icons.message, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout, size: 30),
                  ),
                ],
              ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                // Imagem
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image.network(profileImageUrl, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Informações pessoais título
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Personal Info:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                  thickness: 2,
                ),

                // DADOS DE INFORMAÇÃO PESSOAL
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(20.0),
                  child: Table(
                    children: [
                      // Nome
                      TableRow(
                        children: [
                          const Text(
                            "Name: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      // Espaço
                      const TableRow(
                        children: [
                          Text(""),
                          Text(""),
                        ],
                      ),

                      // Idade
                      TableRow(
                        children: [
                          const Text(
                            "Age: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            age,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      // Espaço
                      const TableRow(
                        children: [
                          Text(""),
                          Text(""),
                        ],
                      ),

                      // País
                      TableRow(
                        children: [
                          const Text(
                            "Country: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            country,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      // Espaço
                      const TableRow(
                        children: [
                          Text(""),
                          Text(""),
                        ],
                      ),

                      // Sobre mim
                      TableRow(
                        children: [
                          const Text(
                            "About Me: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            aboutme,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),

                      // Espaço
                      const TableRow(
                        children: [
                          Text(""),
                          Text(""),
                        ],
                      ),

                      // Jogos
                      TableRow(
                        children: [
                          const Text(
                            "Game: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            games,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
