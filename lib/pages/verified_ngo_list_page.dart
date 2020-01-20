import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_panic_government/components.dart/verified_ngo_list.dart';
import 'package:dont_panic_government/constants.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;

class VerifiedNgoPage extends StatefulWidget {
  @override
  _VerifiedNgoPageState createState() => _VerifiedNgoPageState();
}

class _VerifiedNgoPageState extends State<VerifiedNgoPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text('Verified NGOs'),
      ),
      body: StreamBuilder(
          stream: _firestore.collection('verifiedNgos').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('NO DATA'));
            }
            final documents = snapshot.data.documents;
            List<VerifiedNgoList> ngoRequesrList = [];
            for (var doc in documents) {
              print(doc.data['name']);
              ngoRequesrList.add(
                VerifiedNgoList(
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
