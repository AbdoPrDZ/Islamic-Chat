import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:islamic_chat/models/user_model.dart';
import 'package:islamic_chat/pages/home_page.dart';
import 'package:islamic_chat/pages/login_page.dart';
import 'package:islamic_chat/pkgs/show_dialog.dart';
import 'package:islamic_chat/views/my_container.dart';
import 'package:islamic_chat/views/raised_gradient_button.dart';

class SignupPage extends StatefulWidget {
  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController brithDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DateTime brithDateTime = DateTime(2002, 1, 15);
  String gender = "Male";
  bool hidePassword = true;

  final FirebaseAuth auth = FirebaseAuth.instance;
  // final DatabaseReference refrence = FirebaseDatabase.instance.reference();
  final FirebaseFirestore refrence = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    brithDateController.text = DateFormat("dd-MM-yyyy").format(brithDateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: brithDateTime,
        firstDate: DateTime(1800, 0, 0),
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        brithDateTime = picked;
        brithDateController.text = DateFormat("dd-MM-yyyy").format(picked);
      });
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    brithDateController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  void signup(BuildContext context) async {
    ShowLoadingDialog(context);

    if (firstnameController.text.isEmpty ||
        lastnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Navigator.pop(context);
      ShowMyDialog(
          context: context,
          title: 'Signup Error',
          message: 'Please fill all data.');
    } else if (passwordController.text.length < 8) {
      Navigator.pop(context);
      ShowMyDialog(
          context: context,
          title: 'Signup Error',
          message: 'The password must be more than 8 characters.');
    } else {
      try {
        var authReusalt = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        String userId = authReusalt.user.uid;
        // try {
        //   refrence.child("users").child(userId).set({
        //     "id": userId,
        //     "firstname": firstnameController.text,
        //     "lastname": lastnameController.text,
        //     "email": emailController.text,
        //   });
        // } on FirebaseException catch (error) {
        //   print(error.message);
        // } catch (error) {
        //   print(error);
        // }
        try {
          UserModel userModel = UserModel(
            id: userId,
            username: firstnameController.text + " " + lastnameController.text,
            casesSearch:
                (firstnameController.text + " " + lastnameController.text)
                    .toLowerCase()
                    .split(" "),
            brithDate: Timestamp.fromDate(brithDateTime),
            imagePath: "assets/images/logo.png",
            gender: gender,
            email: emailController.text,
            phone: phoneController.text,
            chats: <String>[],
            frands: <String>[],
          );
          refrence.collection("users").doc(userId).set(userModel.toMap());

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        } on FirebaseException catch (error) {
          Navigator.pop(context);
          ShowMyDialog(
              context: context, title: 'Signup Error', message: error.message);
        } catch (error) {
          Navigator.pop(context);
          ShowMyDialog(
              context: context,
              title: 'Signup Error',
              message: error.toString());
        }
      } on FirebaseAuthException catch (error) {
        Navigator.pop(context);
        ShowMyDialog(
            context: context, title: 'Signup Error', message: error.message);
      } catch (error) {
        Navigator.pop(context);
        ShowMyDialog(
            context: context, title: 'Signup Error', message: error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(color: Colors.blue)),
              Image.asset(
                "assets/images/logo.png",
                width: 100,
                height: 100,
              ),
              Text(
                "Signup",
                style: TextStyle(
                  fontSize: 40,
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
                    hintText: "Firstname",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.white)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  ),
                  controller: firstnameController,
                ),
              ),
              MyContainer(
                padding: EdgeInsets.all(0),
                child: TextFormField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Lastname",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.white)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  ),
                  controller: lastnameController,
                ),
              ),
              MyContainer(
                padding: EdgeInsets.all(0),
                child: TextFormField(
                  onTap: () => _selectDate(context),
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Brith Date",
                    prefixIcon: Icon(Icons.calendar_today),
                    suffixIcon: IconButton(
                      onPressed: null,
                      // onPressed: () => _selectDate(context),
                      icon: Icon(Icons.edit),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.white)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  ),
                  controller: brithDateController,
                ),
              ),
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
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "Phone",
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.white)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                  ),
                  controller: phoneController,
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
              MyContainer(
                child: Row(
                  children: <Widget>[
                    Text(
                      "Gender:",
                      style: TextStyle(fontSize: 18),
                    ),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    RaisedButton(
                      color: Colors.blue,
                      child:
                          Text("Male", style: TextStyle(color: Colors.white)),
                      onPressed: gender != "Male"
                          ? () {
                              setState(() {
                                gender = "Male";
                              });
                            }
                          : null,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      child:
                          Text("Female", style: TextStyle(color: Colors.white)),
                      onPressed: gender != "Female"
                          ? () {
                              setState(() {
                                gender = "Female";
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 5.0)),
              RaisedGradientButton(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
                onPressed: () => signup(context),
                child: Text(
                  "Signup",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 5)),
              Row(
                children: <Widget>[
                  Text("If you already have an account,",
                      style: TextStyle(color: Colors.blue[900])),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage(),
                      ),
                    ),
                    child: Text("login"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
