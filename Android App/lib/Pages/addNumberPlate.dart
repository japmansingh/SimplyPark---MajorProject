import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:minor_project/Models/numberPlateDetails.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:minor_project/widgets/progress.dart';

class AddNumberPlate extends StatefulWidget {
  @override
  _AddNumberPlateState createState() => _AddNumberPlateState();
}

class _AddNumberPlateState extends State<AddNumberPlate> {
  final numberPlateRef = FirebaseFirestore.instance
      .collection('number_plate')
      .doc(user.id)
      .collection("number_plate");
  final numberPlateDocRef =
      FirebaseFirestore.instance.collection('number_plate').doc(user.id);
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String numberPlate;
  NumberPlateDetails _numberPlateDetails = NumberPlateDetails();

  Future<void> _getNumberPlateDetails() async {
    setState(() {
      isLoading = true;
    });
    print("Making get request");
    // HR29AB3211
    String url =
        'http://shrouded-falls-48764.herokuapp.com/vehicle-info/$numberPlate';
    Map<String, String> headers = {
      "API-Key": "df81c10a960344fa87c287296b4f5c47"
    };
    print(url);
    try {
      Response response = await get(url, headers: headers);
      int statusCode = response.statusCode;
      Map<String, dynamic> data = json.decode(response.body);
      _numberPlateDetails = NumberPlateDetails.fromJson(data);
      print(response.body);
      print(_numberPlateDetails.ownerName);
      switch (statusCode) {
        case 200:
          print("LIST OF USER FILTERS ${_numberPlateDetails.ownerName}");
          if (_numberPlateDetails.ownerName.isNotEmpty) {
            final DateTime timestamp = DateTime.now();
            //navigate to other screen
            numberPlateDocRef.set({"$numberPlate": "$numberPlate"});
            numberPlateRef.doc(numberPlate).set({
              "numberPlateNumber": numberPlate,
              "userid": user.id,
              "ownername": _numberPlateDetails.ownerName,
              "username": user.displayName,
              "registerationNumber": _numberPlateDetails.registerationNumber,
              "model": _numberPlateDetails.model,
              "vehicleClass": _numberPlateDetails.vehicleClass,
              "fuelType": _numberPlateDetails.fuelType,
              "regDate": _numberPlateDetails.fuelType,
              "chassisNumber": _numberPlateDetails.chassisNumber,
              "engineNumber": _numberPlateDetails.engineNumber,
              "fitnessUpto": _numberPlateDetails.fitnessUpto,
              "insuranceExpiry": _numberPlateDetails.insuranceExpiry,
              "registeringAuthority": _numberPlateDetails.registeringAuthority,
              "timestamp": timestamp
            }).whenComplete(() {
              Navigator.pop(context, numberPlate);
            });
          }
          break;
        default:
          Navigator.pop(context, numberPlate);
      }
    } catch (e) {
      print(e);
      Navigator.pop(context, numberPlate);
    }
  }

  _showDialogForRelevance(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Number Plate'),
          backgroundColor: Color(0XFF003051),
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/addNumberPlate2.jpg'),
              ),
            ),
            isLoading
                ? circularProgress()
                : Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              validator: (val) {
                                if (val.trim().length < 3 || val.isEmpty) {
                                  return "Number Plate too short";
                                } else if (val.trim().length > 12) {
                                  return "Number Plate too long";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (val) => numberPlate = val,
                              autofocus: false,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.black),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                hintText: 'Number Plate',
                                filled: true,
                                fillColor: Colors.grey[200],
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 6.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                child: RaisedButton(
                                  color: Colors.green,
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      _getNumberPlateDetails();
                                    }
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.green)),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
          ],
        ));
  }
}
