import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String senderName;
  final String currentUserID;

  ChatScreen({
    required this.recipientId,
    required this.recipientName,
    required this.senderName,
    required this.currentUserID,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection("Messages").add({
        'senderId': widget.currentUserID,
        'senderName': widget.senderName,
        'recipientId': widget.recipientId,
        'recipientName': widget.recipientName,
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'participants': [widget.currentUserID, widget.recipientId]
      });
      _messageController.clear();
    } catch (e) {
      print("Error sending message: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recipientName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Messages")
                  .where('participants', arrayContains: widget.currentUserID)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }

                List<DocumentSnapshot> messageDocs = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>?;
                  return data != null && ((data['senderId'] == widget.currentUserID && data['recipientId'] == widget.recipientId) || 
                                          (data['senderId'] == widget.recipientId && data['recipientId'] == widget.currentUserID));
                }).toList();

                return ListView.builder(
                  itemCount: messageDocs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = messageDocs[index];
                    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

                    if (data == null || !data.containsKey('message') || !data.containsKey('senderName')) {
                      return Container(); // Tratamento para documento sem os campos necessários
                    }

                    String message = data['message'];
                    String senderName = data['senderName'];

                    return ListTile(
                      title: Text(message),
                      subtitle: Text('Sent by: $senderName'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
