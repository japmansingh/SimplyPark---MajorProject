import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:minor_project/Models/newNumberPlateDetails.dart';
import 'package:minor_project/Models/numberPlateDetails.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:minor_project/widgets/progress.dart';
import 'package:toast/toast.dart';
import 'package:xml/xml.dart';

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
  NumberPlateData _numberPlateDetails = NumberPlateData();

  // Future<void> _getNumberPlateDetails() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   print("Making get request");
  //   // HR29AB3211
  //   String url =
  //       'http://shrouded-falls-48764.herokuapp.com/vehicle-info/$numberPlate';
  //   Map<String, String> headers = {
  //     "API-Key": "df81c10a960344fa87c287296b4f5c47"
  //   };
  //   print(url);
  //   String newUrl =
  //       'https://www.regcheck.org.uk/api/reg.asmx/CheckIndia?RegistrationNumber=DL8CW4134&username=japman';
  //   try {
  //     Response response = await get(url, headers: headers);
  //     int statusCode = response.statusCode;
  //     Map<String, dynamic> data = json.decode(response.body);
  //     _numberPlateDetails = NumberPlateDetails.fromJson(data);
  //     print(response.body);
  //     print(_numberPlateDetails.ownerName);
  //     switch (statusCode) {
  //       case 200:
  //         print("LIST OF USER FILTERS ${_numberPlateDetails.ownerName}");
  //         if (_numberPlateDetails.ownerName.isNotEmpty) {
  //           final DateTime timestamp = DateTime.now();
  //           //navigate to other screen
  //           numberPlateDocRef.set({"$numberPlate": "$numberPlate"});
  //           numberPlateRef.doc(numberPlate).set({
  //             "numberPlateNumber": numberPlate,
  //             "userid": user.id,
  //             "ownername": _numberPlateDetails.ownerName,
  //             "username": user.displayName,
  //             "registerationNumber": _numberPlateDetails.registerationNumber,
  //             "model": _numberPlateDetails.model,
  //             "vehicleClass": _numberPlateDetails.vehicleClass,
  //             "fuelType": _numberPlateDetails.fuelType,
  //             "regDate": _numberPlateDetails.fuelType,
  //             "chassisNumber": _numberPlateDetails.chassisNumber,
  //             "engineNumber": _numberPlateDetails.engineNumber,
  //             "fitnessUpto": _numberPlateDetails.fitnessUpto,
  //             "insuranceExpiry": _numberPlateDetails.insuranceExpiry,
  //             "registeringAuthority": _numberPlateDetails.registeringAuthority,
  //             "timestamp": timestamp
  //           }).whenComplete(() {
  //             Navigator.pop(context, numberPlate);
  //           });
  //         }
  //         break;
  //       default:
  //         Navigator.pop(context, numberPlate);
  //     }
  //   } catch (e) {
  //     print(e);
  //     Navigator.pop(context, numberPlate);
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // _getLatestNumberPlateDetails();
  //   _getCreditScore();
  // }

  _getCreditScore() async {
    bool creditBool = false;
    String validName = '';
    List<String> _validNames = [
      'tarun',
      'japmansingh',
      'jaskaran',
      'jsk',
      // 'kawatra',
      // 'gtbit',
      // 'majorproject',
    ];
    for (String i in _validNames) {
      print('Names List at $i');
      String _url =
          'http://www.regcheck.org.uk/ajax/getcredits.aspx?username=$i';
      try {
        Response response = await get(_url);
        int _credit = int.parse(response.body);
        print('credit score $_credit');
        if (_credit >= 1) {
          print('valid $_url');
          print(response.body);
          creditBool = true;
          validName = i;
          break;
        }
      } catch (e) {
        print('Error : $e');
      }
    }
    if (creditBool) _getLatestNumberPlateDetails(validName);
  }

  Future<void> _getLatestNumberPlateDetails(String validName) async {
    Map<String, dynamic> numberPlateMap = {};
    setState(() {
      isLoading = true;
    });
    print("Making get request");
    // HR29AB3211
    String url =
        'https://www.regcheck.org.uk/api/reg.asmx/CheckIndia?RegistrationNumber=$numberPlate&username=$validName';

    try {
      Response response = await get(url);
      int statusCode = response.statusCode;
      var storeDocument = XmlDocument.parse(response.body);
      print("vehicleJson get request");
      print(storeDocument.findAllElements('vehicleJson'));
      var d = storeDocument.findAllElements('vehicleJson');
      d.forEach((element) {
        var _plate = element.firstChild.toString();
        numberPlateMap = json.decode(_plate);
        _numberPlateDetails = numberPlateDataFromJson(_plate);
      });
      // int statusCode = 200;
      switch (statusCode) {
        case 200:
          final DateTime timestamp = DateTime.now();
          numberPlateDocRef.set({"$numberPlate": "$numberPlate"});
          numberPlateRef.doc(numberPlate).set({
            "numberPlateNumber": numberPlate,
            "userid": user.id,
            "ownername": _numberPlateDetails.owner,
            "username": user.displayName,
            "model": _numberPlateDetails.modelDescription.currentTextValue,
            "vehicleClass": _numberPlateDetails.vehicleType,
            "fuelType": _numberPlateDetails.fuelType.currentTextValue,
            "regDate": _numberPlateDetails.registrationDate,
            "chassisNumber": _numberPlateDetails.vechileIdentificationNumber,
            "engineNumber": _numberPlateDetails.engineNumber,
            "fitnessUpto": _numberPlateDetails.fitness,
            "insuranceExpiry": _numberPlateDetails.insurance,
            "registeringAuthority": _numberPlateDetails.location,
            "numberOfSeats": _numberPlateDetails.numberOfSeats.currentTextValue,
            "imageUrl": _numberPlateDetails.imageUrl,
            "variant": _numberPlateDetails.variant,
            "currentTextValue": _numberPlateDetails.carMake.currentTextValue,
            "carModel": _numberPlateDetails.carModel.currentTextValue,
            "engineSize": _numberPlateDetails.engineSize.currentTextValue,
            "PUCC": _numberPlateDetails.pucc,
            "timestamp": timestamp
          }).whenComplete(() {
            Toast.show("NumberPlate added!", context);
            //
            Navigator.pop(context, numberPlate);
          });
          break;
        default:
          Toast.show("Something went wrong!", context);
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
        // backgroundColor: Color(0XFF003051),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/addNumberPlate2.jpg',
                ),
                fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              isLoading
                  ? Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: circularProgress())
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
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  hintText: 'Number Plate',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 6.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(20.0),
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
                                      _getCreditScore();
                                      // _getLatestNumberPlateDetails();
                                    }
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.green),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
