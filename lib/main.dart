import 'package:dont_panic_government/pages/add_calamity_alert_page.dart';
import 'package:dont_panic_government/pages/calamity_updates_page.dart';
import 'package:dont_panic_government/pages/homepage.dart';
import 'package:dont_panic_government/pages/ngo_registration_page.dart';
import 'package:dont_panic_government/pages/remove_calamity_alert_page.dart';
import 'package:dont_panic_government/pages/verified_ngo_list_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => HomePage(),
        '/ngo_verification_page': (context) => NgoRegistration(),
        '/ngo_verified_list': (context) => VerifiedNgoPage(),
        '/add_calamity_page': (context) => AddCalamityList(),
        '/add_calamity_update_page': (context) => CalamityUpdates(),
        '/remove_calamity_update_page': (context) => RemoveCalamityAlert(),
      },
    );
  }
}
