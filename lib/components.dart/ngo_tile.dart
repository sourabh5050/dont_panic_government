import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:uuid/uuid.dart';

final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class NgoInfo extends StatelessWidget {
  NgoInfo({
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
  void _sendSMS(String message, List<String> recipents) async {
    String _result =
        await FlutterSms.sendSMS(message: message, recipients: recipents)
            .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  void acceptRequest() async {
    final pass = uuid.v1().split('-').join().toString();
    final new_id = uuid.v1().split('-').join().toString();
    final firebaseUser = await _auth.createUserWithEmailAndPassword(
        email: email, password: pass);
    _sendSMS(
      'Congratulations,\nYou have been verified for the DON\'T PANIC application.\nYour password is $pass.Please don\'t share it with anyone.',
      [phone.toString()],
    );
    if (firebaseUser != null) {
      QuerySnapshot querySnapshot = await _firestore
          .collection('newAccountRequests')
          .where('id', isEqualTo: id)
          .getDocuments();
      for (var doc in querySnapshot.documents) {
        doc.reference.delete();
      }
      _firestore.collection('verifiedNgos').document().setData({
        'id': new_id,
        'name': name,
        'desc': desc,
        'email': email,
        'phone': phone,
      });
    }
  }

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
                    onPressed: () {
                      declineRequest();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: IconButton(
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: MediaQuery.of(context).size.height / 30,
                    ),
                    onPressed: () {
                      acceptRequest();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
