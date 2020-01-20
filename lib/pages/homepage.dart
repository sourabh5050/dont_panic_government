import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_panic_government/constants.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestore = Firestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkForPermissions();
  }

  void checkForPermissions() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    ServiceStatus serviceStatus =
        await LocationPermissions().checkServiceStatus();
    PermissionStatus p;
    if (permission == PermissionStatus.unknown) {
      p = await LocationPermissions().requestPermissions();
    }
    if (serviceStatus == ServiceStatus.disabled) {
      Alert(
          context: context,
          title: 'Please enable your location services',
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Okay'),
            ),
          ]).show();
    }
    if (permission == PermissionStatus.denied) {
      Alert(
          context: context,
          title:
              'Please give us permission in application\'s settings to get your location to deliver your clothes right to you.',
          buttons: [
            DialogButton(
              onPressed: () async {
                bool isOpened = await LocationPermissions().openAppSettings();
              },
              child: Text('Open settings'),
            ),
          ]).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text('DON\'T PANIC GOV'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: FlareActor(
                "assets/flares/HelloAnim.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "idle",
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Divider(
                height: 2,
                thickness: 2,
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ngo_verification_page');
                },
                child: ListTile(
                  title: Text(
                    'NGO Verification',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: MediaQuery.of(context).size.height / 40,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/ngo_verified_list');
                },
                child: ListTile(
                  title: Text(
                    'Verified NGO List',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: MediaQuery.of(context).size.height / 40,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/add_calamity_page');
                },
                child: ListTile(
                  title: Text(
                    'Add Calamity Alert',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: MediaQuery.of(context).size.height / 40,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/add_calamity_update_page');
                },
                child: ListTile(
                  title: Text(
                    'Calamity Updates',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: MediaQuery.of(context).size.height / 40,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/remove_calamity_update_page');
                },
                child: ListTile(
                  title: Text(
                    'Remove Calamity Alert',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: MediaQuery.of(context).size.height / 40,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: MediaQuery.of(context).size.height / 40,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
