import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_panic_government/pages/add_update_page.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

final _firestore = Firestore.instance;

class CalamityUpdates extends StatefulWidget {
  @override
  _CalamityUpdatesState createState() => _CalamityUpdatesState();
}

class _CalamityUpdatesState extends State<CalamityUpdates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Calamity Updates'),
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
            cals.add(
              Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUpdate(
                          id: doc.data['id'],
                          updates: doc.data['updates'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.arrow_forward_ios,
                      color: mainColor,
                    ),
                    title: Text('calamity code: ' +
                        doc.data['calamity code'].toString()),
                    trailing: Text(
                      '(' +
                          num.parse(gp.latitude.toStringAsFixed(2)).toString() +
                          ',' +
                          num.parse(gp.longitude.toStringAsFixed(2))
                              .toString() +
                          ')',
                    ),
                  ),
                ),
              ),
            );
          }
          return ListView(
            children: cals,
          );
        },
      ),
    );
  }
}
