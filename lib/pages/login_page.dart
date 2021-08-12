import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:islamic_chat/pages/home_page.dart';
import 'package:islamic_chat/pages/signup_page.dart';
import 'package:islamic_chat/pkgs/show_dialog.dart';
import 'package:islamic_chat/views/my_container.dart';
import 'package:islamic_chat/views/raised_gradient_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool hidePassword = true;

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login(BuildContext context) async {
    ShowLoadingDialog(context);
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Navigator.pop(context);
      ShowMyDialog(
          context: context,
          title: 'Login Error',
          message: 'Please fill all data.');
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (error) {
        Navigator.pop(context);
        print(error);
        ShowMyDialog(
            context: context, title: 'Login Error', message: error.message);
      } catch (error) {
        Navigator.pop(context);
        ShowMyDialog(
            context: context, title: 'Login Error', message: error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: BackButton(color: Colors.blue)),
            Image.asset(
              "assets/images/logo.png",
              width: 125,
              height: 125,
            ),
            Text(
              "Login",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 20.0)),
            MyContainer(
              padding: EdgeInsets.all(0),
              child: TextFormField(
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.white)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                ),
                controller: emailController,
              ),
            ),
            MyContainer(
              padding: EdgeInsets.all(0),
              child: TextFormField(
                obscureText: hidePassword,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                      icon: Icon(hidePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() {
                            hidePassword = !hidePassword;
                          })),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(width: 0)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                ),
                controller: passwordController,
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 5.0)),
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
              onPressed: () => login(context),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
            Row(
              children: <Widget>[
                Text("Are you ", style: TextStyle(color: Colors.blue[900])),
                TextButton(
                  onPressed: () {},
                  child: Text("fourget password?"),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text("If you don't have an account,",
                    style: TextStyle(color: Colors.blue[900])),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => SignupPage(),
                    ),
                  ),
                  child: Text("Signup?"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
