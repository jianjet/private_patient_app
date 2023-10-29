import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../errorpage.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender_uid;
  final bool sentByMe;
  final String ChatId;
  final int time;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.sender_uid,
      required this.sentByMe,
      required this.ChatId,
      required this.time})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentByMe ? 0 : 24,
        right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding:
            const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.sentByMe
                ? Colors.blue[200]
                : Colors.grey[200]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<DocumentSnapshot?>(
              stream: FirebaseFirestore.instance.collection('message_server').doc(widget.ChatId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if (snapshot.hasError){
                  return const ErrorPage();
                }
                else {
                  final DocumentSnapshot<Object?>? documentSnapshot = snapshot.data;
                  final String patient_id = documentSnapshot!['patient'];
                  final String sender_name;
                  if (widget.sender_uid==patient_id){
                    sender_name = documentSnapshot['patient_name'];
                  } else {
                    sender_name = documentSnapshot['doctor_name'];
                  }
                  return Text(
                    sender_name,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: -0.5),
                  );
                }
              },
            ),
            const SizedBox(height: 6),
            Text(widget.message,
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 16, color: Colors.black)
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy  h:mm a').format(DateTime.fromMillisecondsSinceEpoch(widget.time)),
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 112, 112, 112),
                  letterSpacing: -0.5),
            ),
          ],
        ),
      ),
    );
  }
}