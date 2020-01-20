import 'package:cloud_firestore/cloud_firestore.dart';
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
      body:  StreamBuilder(
      stream: _firestore.collection('newAcountRequest').snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Text('NO DATA');
        }
        final documents=snapshot.data.documents;
        List<ListTile> ngoRequesrList=[];
        for(var doc in documents){
          ngoRequesrList.add(ListTile(
            title: Text(doc.data['Email']),
            subtitle:Text(doc.data['Phone']) ,
            trailing: RaisedButton(onPressed: null),
          ));
        }
        return  ListView(
          children: ngoRequesrList,
        );
      }


        ),
    );
  }
}