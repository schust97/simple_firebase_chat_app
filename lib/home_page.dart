import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

final _firestore = FirebaseFirestore.instance;

final User? user = Auth().currentUser;

Widget _userId() {
  return Text(user?.email ?? 'User email');
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _firestore = FirebaseFirestore.instance;

  var messageText = TextEditingController();

  // final User? user = Auth().currentUser;

  //
  Future<void> signOut() async {
    await Auth().signOut();
  }

  // Widget _title() {

  Widget _signOutButton() {
    return ElevatedButton(onPressed: signOut, child: Text("sign out"));
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }
  // void messagesStreams() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String? _errorMessage = "";
    return Scaffold(
      drawer: Drawer(
          child: Container(
              height: double.infinity,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_signOutButton()],
              ))),
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Row(
          children: [
            Icon(
              Icons.apple,
              size: 30,
            ),
            Text('IMessage')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _signOutButton();
              // getMessages();
              // add here logout function
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    left: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    top: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageText,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          hintText: 'Write your message here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          _firestore.collection("messages").add({
                            'text': messageText.text,
                            'sender': user!.email,
                            'time': FieldValue.serverTimestamp(),
                          });
                          messageText.clear();
                        } catch (e) {
                          setState(() {
                            _errorMessage = e.toString();
                          });
                        }
                      },
                      child: Text(
                        'send',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSendor = message.get('sender');
          final currentUser = user!.email;

          if (currentUser == messageSendor) {
            //the code of the message from  the signed in user

          }
          final messageWidget = MessageLine(
            sender: messageSendor,
            text: messageText,
            isMe: currentUser == messageSendor,
          );
          messageWidgets.add(messageWidget);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageLine extends StatelessWidget {
  final String? sender;
  final String? text;
  final bool isMe;
  const MessageLine(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
          Material(
              elevation: 5,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              color: isMe ? Colors.grey[900] : Colors.green[600],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
