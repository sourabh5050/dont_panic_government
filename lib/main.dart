import 'package:dont_panic_government/pages/homepage.dart';
import 'package:dont_panic_government/pages/loginpage.dart';
import 'package:dont_panic_government/pages/ngo_registration_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) =>NgoRegistration(),
        
      },
    );
  }
}

