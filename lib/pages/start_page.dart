import 'package:islamic_chat/pages/login_page.dart';
import 'package:islamic_chat/pages/signup_page.dart';
import 'package:islamic_chat/views/raised_gradient_button.dart';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue,
              Colors.purple,
            ],
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              width: 150,
              height: 150,
            ),
            Text(
              "Chat App",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(padding: EdgeInsets.only(bottom: 15.0)),
            RaisedGradientButton(
              // padding: EdgeInsets.all(15.0),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.purple,
                ],
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage(),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 8.0)),
            RaisedGradientButton(
              // padding: EdgeInsets.all(15.0),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.purple,
                ],
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => SignupPage(),
                ),
              ),
              child: Text(
                "Signup",
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
