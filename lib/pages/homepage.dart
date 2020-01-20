import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(onPressed: (){
             firestore.collection('calamities').document('chennai').updateData({
               'calamitie': 1,
             });
            },
             child: Text('Earthquake'),),
              RaisedButton(onPressed: (){
                firestore.collection('calamities').document('chennai').updateData({
                  'calamitie': 2,
                });
              },
                child: Text('Flood'),),
              RaisedButton(onPressed: (){
                firestore.collection('calamities').document('chennai').updateData({
                  'calamitie': 3,
                });
              },
                child: Text('Cyclone'),),
              RaisedButton(onPressed: (){
                firestore.collection('calamities').document('chennai').updateData({
                'calamitie': 4,
                });
                },
                child: Text('Volcano'),),
          ],
        ),
      ),
    );
  }
}
