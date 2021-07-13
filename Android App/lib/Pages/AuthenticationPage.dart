import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor_project/Pages/Services.dart';
import 'package:minor_project/Pages/create_account.dart';
import 'package:custom_bottom_navigation_bar/custom_bottom_navigation_bar.dart';
import 'package:custom_bottom_navigation_bar/custom_bottom_navigation_bar_item.dart';
import 'package:minor_project/Pages/logs.dart';
import 'package:minor_project/Pages/parking.dart';
import 'package:minor_project/Pages/profile.dart';
import 'package:minor_project/widgets/drawer.dart';

import 'ParkingLocator.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final usersRef = FirebaseFirestore.instance.collection('users');
final DateTime timestamp = DateTime.now();
final GoogleSignIn googleSignIn = GoogleSignIn();
final GoogleSignInAccount user = googleSignIn.currentUser;


class _LoginState extends State<Login> {
  bool isAuth = false;
  PageController _pageController = PageController();

  // bool isShow = false;

  @override
  void initState() {
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });
    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
    // Timer(
    //     Duration(
    //       seconds: 3,
    //     ), () {
    //   if (this.mounted)
    //     setState(() {
    //       isShow = true;
    //     });
    // });
    super.initState();
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      final mapData = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      String username = mapData["username"];
      String phoneNumber = mapData["phoneNumber"];

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "phoneNumber": phoneNumber,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "timestamp": timestamp
      });

      doc = await usersRef.doc(user.id).get();
    }

    // currentUser = User.fromDocument(doc);
  }

  handleSignIn(GoogleSignInAccount account) async {
    if (account != null) {
      await createUserInFirestore();
      if (this.mounted)
        setState(() {
          isAuth = true;
        });
    } else {
      if (this.mounted)
        setState(() {
          isAuth = false;
          // isShow = true;
        });
    }
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  Scaffold buildAuthScreen({double width, double height}) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              color: Colors.grey,
              child: Image.asset(
                "assets/images/parking.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: height * 0.2,
              left: width * 0.15,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 120,
                    width: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: ClipOval(
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            "assets/images/simplyParkLogoSmall.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    '    Automated', textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '    Parking',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Positioned(
              top: height * 0.65,
              child: Container(
                width: width,
                height: height * 0.35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          login();
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 20),
                              Container(
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                    "assets/images/google_logo.jpg"),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                'Continue with Google',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 20),
                              Icon(
                                MdiIcons.facebook,
                                color: Colors.white,
                                size: 30,
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                'Continue with Facebook',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Scaffold buildAuthScreen2({double width, double height}) {
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Container(
              width: width,
              height: height,
              color: Colors.grey,
              child: Image.asset(
                "assets/images/parking.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: height * 0.2,
              left: width * 0.15,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 120,
                    width: 140,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: ClipOval(
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            "assets/images/simplyParkLogoSmall.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'SimplyParking',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold homeScreen() {
    return Scaffold(
      appBar: AppBar(
        //2F2F74
        //003051
        backgroundColor: Colors.black,
        title: Text("Automated Parking"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  logout();
                  setState(() {
                    isAuth = false;
                  });
                },
                child: Icon(
                  Icons.logout,
                  size: 30.0,
                )),
          )
        ],
      ),
      drawer: NavigationDrawer(),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          ParkingLocator(),
          Parking(),
          Logs(),
          Services(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        backgroundColor: Colors.black,
        itemBackgroudnColor: Colors.black,
        items: [
          CustomBottomNavigationBarItem(
            icon: Icons.location_on,
            title: "Nearby",
          ),
          CustomBottomNavigationBarItem(
            icon: Icons.car_repair,
            title: "Parking",
          ),
          CustomBottomNavigationBarItem(
            icon: Icons.book,
            title: "Logs",
          ),
          CustomBottomNavigationBarItem(
            icon: Icons.home_repair_service,
            title: "Services",
          ),
        ],
        onTap: (index) {
          _pageController.animateToPage(index,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 600),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Are you sure you want to quit?'),
          actions: <Widget>[
            FlatButton(
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.of(context).pop(true)),
            FlatButton(
                child: Text('No', style: TextStyle(color: Colors.black)),
                onPressed: () => Navigator.of(context).pop(false)),
          ],
        ),
      ),
      child: isAuth
          ? homeScreen()
          :
          // : isShow ?
          buildAuthScreen(width: width, height: height),
    );
    // : buildAuthScreen2(width: width, height: height);
  }
}
