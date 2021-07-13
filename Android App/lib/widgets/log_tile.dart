import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Models/user.dart';
import 'package:minor_project/Pages/payment.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:uuid/uuid.dart';

class LogTile extends StatefulWidget {
  LogTile(
      {this.numberPlate,
        this.place,
        this.exitTimestamp,
        this.entryTimestamp,
        this.paid});

  final String numberPlate;
  final String place;
  final String exitTimestamp;
  final String entryTimestamp;
  final String paid;

  @override
  _LogTileState createState() => _LogTileState();
}

class _LogTileState extends State<LogTile> {
  double _payRate = 30;
  double basePay = 50;
  double calChg = 0;
  bool _notParked = true;
  Razorpay razorpay;
  User us = new User();
  String parkingPlace = "";

  @override
  void initState() {
    super.initState();
    getPayRates();
    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  getPayRates() async {
    await FirebaseFirestore.instance
        .collection('logs')
        .doc(user.id)
        .collection("logs")
        .doc('Q12w' + widget.numberPlate)
        .get()
        .then((documentSnapshot) {
      Map plateData = documentSnapshot.data();
      print(plateData['place']);
      parkingPlace = plateData['place'];
    });

    await FirebaseFirestore.instance
        .collection('admin_panel')
        .doc(parkingPlace)
        .get()
        .then((documentSnapshot) {
      Map adminData = documentSnapshot.data();
      if (adminData != null) {
        print("68");
        print(adminData);
        print(adminData['Base_Pay']);
        print(adminData['Cost_per_Hour']);
        basePay = double.parse(adminData['Base_Pay']);
        _payRate = double.parse(adminData['Cost_per_Hour']);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void handlerPaymentSuccess() {
    print("Pament success");
    FirebaseFirestore.instance
        .collection('logs')
        .doc(user.id)
        .collection("logs")
        .doc('Q12w' + widget.numberPlate)
        .update({'paid': 'paid'});
    Toast.show("Pament success", context);
  }

  void handlerErrorFailure() {
    print("Pament error");
    Toast.show("Pament error", context);
  }

  void handlerExternalWallet() {
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  void openPaymentGateway(double amountCharge) {
    var options = {
      "key": "rzp_test_blz8Zlo4PPZtB3",
      "amount": amountCharge * 100,
      "name": "Complete Your Parking Payment",
      "description": "${widget.numberPlate}, ${widget.place}",
      "prefill": {"contact": "8860037713", "email": "${user.email}"},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    String entry = widget.entryTimestamp;
    print("*******************$entry");

    int entryHr = int.parse(entry.substring(11, 13));
    int entryMn = int.parse(entry.substring(14, 16));
    String exit = "";
    int exitHr = 0;
    int exitMn = 0;
    try {
      exit = widget.exitTimestamp;
      exitHr = int.parse(exit.substring(11, 13));
      exitMn = int.parse(exit.substring(14, 16));
      calChg = double.parse(((exitHr - entryHr) * _payRate +
          ((exitMn - entryMn) * (_payRate / 60)) +
          basePay)
          .toStringAsFixed(2));
      print("Charge : $calChg");
      _notParked = true;
    } catch (e) {
      print(e);
      exit = "Vehicle in Parking";
      _notParked = false;
    }
    return GestureDetector(
      onTap: () async {
        if (_notParked && widget.paid == "" && widget.paid.isEmpty) {
          String parkingPlace = '';
          Map logAdminData = {};
          String messageId = Uuid().v4();

          final logMobileData = FirebaseFirestore.instance
              .collection('logs')
              .doc(user.id)
              .collection("logs")
              .doc('Q12w' + widget.numberPlate);

          await logMobileData.update({'paid': 'paid'});

          await logMobileData.get().then((documentSnapshot) {
            logAdminData = documentSnapshot.data();
            print(logAdminData['place']);
            parkingPlace = logAdminData['place'];
          });

          await FirebaseFirestore.instance
              .collection('logs')
              .doc(user.id)
              .collection(widget.numberPlate)
              .doc(messageId)
              .set(logAdminData)
              .whenComplete(() => print("Log is created in mobile"));

          final adminMaterial = FirebaseFirestore.instance
              .collection('admin_panel')
              .doc(parkingPlace)
              .collection("parking")
              .doc('Park' + widget.numberPlate);

          await adminMaterial.update({'paid': 'paid'});

          await FirebaseFirestore.instance
              .collection('admin_panel')
              .doc(parkingPlace)
              .collection('history')
              .doc(messageId)
              .set(logAdminData)
              .whenComplete(() {
            print("Log is created in Admin");
          });

          final updateAdminData = FirebaseFirestore.instance
              .collection('admin_panel')
              .doc(parkingPlace);

          await updateAdminData.get().then((documentSnapshot) {
            Map adminData = documentSnapshot.data();
            adminData.forEach((key, value) async {
              if (key == "Available_Space" && value != "0")
                await updateAdminData
                    .update({'Available_Space': '${int.parse(value) + 1}'});
              if (key == "Total_Cars_Parked" && value != "0")
                await updateAdminData
                    .update({'Total_Cars_Parked': '${int.parse(value) - 1}'});
            });
          }).whenComplete(() {
            print("Updated Admin data");
            openPaymentGateway(calChg);
          });

          // adminMaterial.get().then((documentSnapshot) {
          //   Map logData = documentSnapshot.data();
          //   print(logData);
          //
          // });

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => CreditCardPage(
          //               amountCharge: calChg,
          //               numberPlate: widget.numberPlate,
          //             )));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width / 2,
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 15.0, right: 15.0, bottom: 15.0, left: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 3,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                '${widget.numberPlate}',
                                // '${document["place"]}',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 5,
                            decoration: BoxDecoration(
                                color: (widget.paid.isNotEmpty &&
                                    widget.paid != "")
                                    ? Colors.green
                                    : Colors.redAccent,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                (widget.paid.isNotEmpty && widget.paid != "")
                                    ? "Paid"
                                    : "Not Paid",
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _notParked
                          ? Row(
                        children: [
                          Text(
                            '₹',
                            style: TextStyle(color: Colors.green),
                          ),
                          Text(
                            "$calChg",
                            style: TextStyle(color: Colors.green),
                          )
                        ],
                      )
                          : Container(
                        height: 0.0,
                        width: 0.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        'Place: ${widget.place}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        "Entry Timestamp:",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        "Date: ${entry.substring(0, 10)}    Time: ${entry.substring(11, 19)}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Exit Timestamp:',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  _notParked
                      ? Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        "Date: ${exit?.substring(0, 10)}    Time: ${exit?.substring(11, 19)}",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        exit,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  _notParked
                      ? Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Parked for: ${exitHr - entryHr} hr. and ${exitMn - entryMn} min.",
                      style: TextStyle(
                        color: Colors.green.shade900,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : Container(
                    height: 0.0,
                    width: 0.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
