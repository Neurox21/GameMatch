import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chatscreen.dart';

class ChatListScreen extends StatefulWidget {
  final String currentUserID;
  final String senderName;

  ChatListScreen({required this.currentUserID, required this.senderName});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Chats'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .where('participants', arrayContains: widget.currentUserID)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          Set<String> participantIds = {};

          if (snapshot.hasData) {
            snapshot.data!.docs.forEach((doc) {
              var data = doc.data() as Map<String, dynamic>?;
              if (data != null && data.containsKey('participants')) {
                List<dynamic> participants = data['participants'];
                participants.forEach((participantId) {
                  if (participantId != widget.currentUserID) {
                    participantIds.add(participantId);
                  }
                });
              }
            });
          }

          if (participantIds.isEmpty) {
            return Center(child: Text('No chats available'));
          }

          return ListView(
            children: participantIds.map((participantId) {
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection('Users').doc(participantId).get(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text('Loading...'),
                    );
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error loading user: ${userSnapshot.error}'),
                    );
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return ListTile(
                      title: Text('User not found'),
                    );
                  }

                  String participantName = userSnapshot.data!.get('name');
                  return ListTile(
                    title: Text(participantName),
                    onTap: () {
                      Get.to(ChatScreen(
                        recipientId: participantId,
                        recipientName: participantName,
                        senderName: widget.senderName,
                        currentUserID: widget.currentUserID,
                      ));
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}