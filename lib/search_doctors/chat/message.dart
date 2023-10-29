import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/search_doctors/chat/message_tile.dart';

class Message extends StatefulWidget {
  String ChatId;
  String doctor_name;
  String doctor_uid;
  Message({
    required this.ChatId,
    required this.doctor_name,
    required this.doctor_uid,
    Key? key
  }) : super(key: key);
  @override
  MessageState createState() => MessageState();
}

class MessageState extends State<Message> {

  Stream<QuerySnapshot>? _chats;
  TextEditingController _messageController = TextEditingController();
  final CollectionReference messageServerCollection = FirebaseFirestore.instance.collection("message_server");
  final user = FirebaseAuth.instance.currentUser!;
  late String name;

  @override
  void initState(){
    _getChat();
    //_getName();
    super.initState();
  }

  _getChatsForPatient(String groupId) async {
    return messageServerCollection
      .doc(groupId)
      .collection("messages")
      .orderBy("time", descending: true)
      .snapshots();
  }

  Future<String> _getName() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('patient_users').doc(user.uid).get();

    if (snapshot.exists) {
      // the document exists, retrieve the value of a specific field
      name = snapshot.get('Name');
      return name;
    }
    else {
      return "anonymous user";
    }
  }

  void _getChat(){
    _getChatsForPatient(widget.ChatId).then((val){
      setState(() {
        _chats=val;
      });
    });
  }

  PreferredSizeWidget _customAppBar(){
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue[100],
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back,color: Colors.black,),
              ),
              const SizedBox(width: 2,),
              const CircleAvatar(
                backgroundImage: AssetImage("./image/girl_icon.png"),
                maxRadius: 20,
              ),
              const SizedBox(width: 12,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.doctor_name,style: const TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                    const SizedBox(height: 6,),
                    //Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _type(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.grey[100]
        ),
        padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            // GestureDetector(
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder: ((context) => const Others())));
            //   },
            //   child: Container(
            //     height: 30,
            //     width: 30,
            //     decoration: BoxDecoration(
            //       color: Colors.lightBlue,
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //     child: const Icon(Icons.add, color: Colors.white, size: 20, ),
            //   ),
            // ),
            const SizedBox(width: 15,),
            Expanded(
              child: TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none
                ),
              ),
            ),
            const SizedBox(width: 15,),
            FloatingActionButton(
              onPressed: (){
                _sendMessage();
              },
              backgroundColor: Colors.blue,
              elevation: 0,
              child: const Icon(Icons.send,color: Colors.white,size: 18,),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chatList(){
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream:  _chats,
            builder: (context, AsyncSnapshot snapshot){
              return snapshot.hasData 
              ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'], 
                    sender_uid: snapshot.data.docs[index]['sender'],
                    sentByMe: user.uid==snapshot.data.docs[index]['sender'],
                    ChatId: widget.ChatId,
                    time: snapshot.data.docs[index]['time'],
                  );
                },
              )
              : Container();
            }
          )
        ),
        const SizedBox(
          height: 80,
        )
      ],
    );
  }

  _sendMessageToServer(String groupId, Map<String, dynamic> chatMessageData) async {
    messageServerCollection.doc(groupId).collection("messages").add(chatMessageData);
  }

  _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": _messageController.text,
        "sender": user.uid,
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      _sendMessageToServer(widget.ChatId, chatMessageMap);
      setState(() {
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: Stack(
        children: [
          _chatList(),
          _type()
        ],
      )
    );
  }
}