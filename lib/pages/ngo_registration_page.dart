import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_panic_government/components.dart/ngo_tile.dart';
import 'package:dont_panic_government/constants.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;

class NgoRegistration extends StatefulWidget {
  @override
  _NgoRegistrationState createState() => _NgoRegistrationState();
}

class _NgoRegistrationState extends State<NgoRegistration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text('NGO Verification Page'),
      ),
      body: StreamBuilder(
          stream: _firestore.collection('newAccountRequests').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('NO DATA'));
            }
            final documents = snapshot.data.documents;
            List<NgoInfo> ngoRequesrList = [];
            for (var doc in documents) {
              print(doc.data['name']);
              ngoRequesrList.add(
                NgoInfo(
                  name: doc.data['name'],
                  id: doc.data['id'],
                  email: doc.data['email'],
                  desc: doc.data['desc'],
                  phone: doc.data['phone'],
                ),
              );
            }
            return ListView(
              children: ngoRequesrList,
            );
          }),
    );
  }
}
