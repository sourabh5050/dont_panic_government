import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email='';
  String password='';
  String uid;
  final _auth = FirebaseAuth.instance;
  //final _firestore = Firestore.instance;
  FirebaseUser loggedInUser;
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.blue
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Government login'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      email=value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Email',
                    contentPadding: EdgeInsets.only(top: 4.0, left: 44.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: TextField(
                  onChanged: (value){
                    setState(() {
                      password=value;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: 'password',
                    contentPadding: EdgeInsets.only(top: 4.0, left: 44.0),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              RaisedButton(

                onPressed: () async{
                  try {
                    print('email:'+email+"   "+password);
                    final firebaseUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (firebaseUser != null) {
                      final currentFirebaseUser = await _auth.currentUser();
                      loggedInUser = currentFirebaseUser;
                      email = loggedInUser.email;
                      uid = loggedInUser.uid;
                      Navigator.pushNamed(context,'/homepage');
                      print(loggedInUser.email+' logged in!!');
                    }
                  } catch (e) {
                    print(e);
                  }

                },
                child: Text('Sign in'),

              ),

            ],
          ),
        ),
      ),
    );
  }
}