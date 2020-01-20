import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class VerifiedNgoList extends StatelessWidget {
  VerifiedNgoList({
    @required this.name,
    @required this.email,
    @required this.phone,
    @required this.desc,
    @required this.id,
  });
  final String name;
  final String phone;
  final String email;
  final String desc;
  final String id;
  final Uuid uuid = Uuid();

  void declineRequest() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('newAccountRequests')
        .where('id', isEqualTo: id)
        .getDocuments();
    for (var doc in querySnapshot.documents) {
      doc.reference.delete();
    }
    /*final Email declineEmail = Email(
      body: 'Sorry,\nYou have not been verified for the application.\n',
      subject: 'Verified as NGO for Don\'t panic application DECLINED',
      recipients: [email],
      isHTML: false,
    );*/
    //await FlutterEmailSender.send(declineEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            isThreeLine: true,
            title: Text(name),
            subtitle: Text(desc),
          ),
          ListTile(
            title: Text(email),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: MediaQuery.of(context).size.height / 30,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
