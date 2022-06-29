import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'dart:core';

final _firestore = FirebaseFirestore.instance;
User
    loggedInUser; // just use User after the new update firebaseuser is not included in the android studios

class ChatScreen extends StatefulWidget {
  static const String chat_id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    getCurrentuser();
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  final methodTextController = TextEditingController();
  String chats;
  void getCurrentuser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessage()async
  // {
  //   final message = await _firestore.collection('messages').get();//message is a snapshot and message.document conatain a list of all key value pair in our collection
  //   for(var i in message.docs)
  //     {
  //       print(i.data());
  //     }
  // }
  // void messageStream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var i in snapshot.docs) {
  //       print(i.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                // getMessage();
                // messageStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: methodTextController,
                      onChanged: (value) {
                        chats = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      methodTextController.clear();
                      _firestore.collection('messages').add({
                        'text': chats,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context,snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data.docs.reversed;
          List<Messagebubble> messageWidgets = [];
          for (var message in messages) {
            final messaageText =message['text'];
            final messageSender = message['sender'];
            final currentUser = loggedInUser.email;
            final messageWidget = Messagebubble(
              text: messaageText,
              sender: messageSender,
              itsMe: currentUser == messageSender,
            );
            messageWidgets.add(messageWidget);
          }
          return Expanded(
              child: ListView(
                reverse: true,
            children: messageWidgets,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          ));
        });
  }
}

class Messagebubble extends StatelessWidget {
  String text;
  String sender;
  bool itsMe;
  Messagebubble({this.text, this.sender, this.itsMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:itsMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          Material(
            elevation: 5.0,
            borderRadius:itsMe? BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)):BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)),
            color:itsMe? Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(fontSize: 15.0, color: itsMe?Colors.white:Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
