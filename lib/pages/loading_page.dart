import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat/pages/home_page.dart';
import 'package:islamic_chat/pages/start_page.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage();

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool isLoading = true, therError = false;
  String errorMessage;

  void init() {
    Firebase.initializeApp().onError((error, stackTrace) {
      setState(() {
        isLoading = false;
        therError = true;
        errorMessage = error.toString();
      });
      return;
    }).whenComplete(() {
      setState(() {
        isLoading = false;
        therError = false;
      });
    });
  }

  void startApp() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => FirebaseAuth.instance.currentUser != null
              ? HomePage()
              : StartPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Material(
      child: InkWell(
        onTap: isLoading || therError ? null : startApp,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                width: 150,
                height: 150,
              ),
              Text("Chat App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 55.0,
                      fontWeight: FontWeight.bold)),
              Text("Powred By Abdo Pr",
                  style: TextStyle(color: Colors.white, fontSize: 22.0)),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      therError ? errorMessage : "Tap to start app",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
