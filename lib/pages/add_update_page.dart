import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_panic_government/constants.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = Firestore.instance;

class AddUpdate extends StatefulWidget {
  AddUpdate({@required this.id, @required this.updates});
  final String id;
  final List<dynamic> updates;
  @override
  _AddUpdateState createState() => _AddUpdateState();
}

class _AddUpdateState extends State<AddUpdate> {
  String newUpdate = '';
  void addUp(String new_str) {
    var newUpdates = new List<dynamic>.from(widget.updates);

    newUpdates.add(new_str);
    _firestore.collection('calamities').document(widget.id).updateData({
      'updates': newUpdates,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        onPressed: () {
          Alert(
            context: context,
            title: 'Add update.',
            content: ListTile(
              title: TextField(
                onChanged: (value) {
                  setState(() {
                    newUpdate = value;
                  });
                },
              ),
            ),
            buttons: [
              DialogButton(
                color: mainColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              DialogButton(
                onPressed: () {
                  if (newUpdate != null && newUpdate != '') {
                    addUp(newUpdate);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Text('Okay'),
              ),
            ],
          ).show();
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('Add updates'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.updates.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Text(widget.updates[index].toString()),
            ),
          );
        },
      ),
    );
  }
}
