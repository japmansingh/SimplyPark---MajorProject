import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:uuid/uuid.dart';
import 'package:timeago/timeago.dart' as timeago;

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  String messageId = Uuid().v4();
  TextEditingController messageController = TextEditingController();
  final messagingRef = FirebaseFirestore.instance.collection('support').doc(user.id);

  addMessage() {
    final DateTime timestampChat = DateTime.now();
    print(timestampChat);
    messagingRef
        .collection("chats")
        .doc(messageId)
        .set({
      "message": messageController.text.trim(),
      "timestamp": timestampChat,
      "ownerId": user.id,
    }, SetOptions(merge: true));
    messageId = Uuid().v4();
    messageController.clear();
  }

  buildMessages() {
    return StreamBuilder(
        stream: messagingRef
            .collection('chats')
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          List<Message> messages = [];
          snapshot.data.documents.forEach((doc) {
            messages.add(Message.fromDocument(doc));
          });
          return ListView(
            reverse: true,
            children: messages,
          );
        });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: buildMessages(),
          ),
          Divider(),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListTile(
              title: TextFormField(
                controller: messageController,
                decoration: InputDecoration(labelText: "Type a message..."),
              ),
              trailing: OutlineButton(
                onPressed: addMessage,
                borderSide: BorderSide.none,
                child: Icon(Icons.send),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message extends StatelessWidget {
  final String ownerId;
  final String message;
  final Timestamp timestamp;

  Message({
    this.ownerId,
    this.message,
    this.timestamp,
  });

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      ownerId: doc['ownerId'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isOwner = user.id == ownerId;
    return Container(
      width: MediaQuery.of(context).size.width/2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isOwner ?MainAxisAlignment.end:MainAxisAlignment.start,
        crossAxisAlignment: isOwner ?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0),),
              color: isOwner ? Colors.blueGrey : Colors.blueGrey.shade100,
              elevation: 5.0,
              child: Container(
                width: MediaQuery.of(context).size.width/2.0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: isOwner ?MainAxisAlignment.end:MainAxisAlignment.start,
                    crossAxisAlignment: isOwner ?CrossAxisAlignment.end:CrossAxisAlignment.start,
                    children: <Widget>[
                      // isOwner ? Text("") : Text(message),
                      // isOwner ? Text(message,style: TextStyle(color: Colors. white),) : Text(""),
                      isOwner
                          ? Text(
                        message,
                        style: TextStyle(color: Colors.white),
                      )
                          : Text(message),
                      SizedBox(height: 3.0,),
                      Text(
                        timeago.format(timestamp.toDate()),
                        textAlign: isOwner ? TextAlign.left : TextAlign.right,
                        style: TextStyle( color: isOwner ? Colors.white : Color(0XFF003051),
                            fontStyle: FontStyle.italic,fontSize:12.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

