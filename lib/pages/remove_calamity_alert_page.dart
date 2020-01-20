import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_panic_government/constants.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;

class RemoveCalamityAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Remove Calamity'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('calamities').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: mainColor,
              ),
            );
          }
          final docs = snapshot.data.documents;
          List<Widget> cals = [];
          for (var doc in docs) {
            GeoPoint gp = doc.data['geoLocation'];
            cals.add(Card(
              child: ListTile(
                //isThreeLine: true,
                trailing: GestureDetector(
                  onTap: () async {
                    QuerySnapshot qs = await _firestore
                        .collection('calamities')
                        .where('id', isEqualTo: doc.data['id'])
                        .getDocuments();
                    final docs = qs.documents;
                    for (var doc in docs) {
                      doc.reference.delete();
                    }
                  },
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
                title: Text(
                    'calamity code: ' + doc.data['calamity code'].toString()),
                subtitle: Text(
                  '(' +
                      num.parse(gp.latitude.toStringAsFixed(2)).toString() +
                      ',' +
                      num.parse(gp.longitude.toStringAsFixed(2)).toString() +
                      ')',
                ),
              ),
            ));
          }
          return ListView(
            children: cals,
          );
        },
      ),
    );
  }
}
