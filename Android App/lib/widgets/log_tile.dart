import 'package:flutter/material.dart';
import 'package:minor_project/Models/user.dart';
import 'package:minor_project/Pages/payment.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';

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
  int _payRate = 30;
  double calChg = 0;
  bool _notParked = true;
  Razorpay razorpay;
  User us = new User();

  @override
  void initState() {
    super.initState();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    razorpay.clear();
  }

  void handlerPaymentSuccess(){
    print("Pament success");
    Toast.show("Pament success", context);
  }

  void handlerErrorFailure(){
    print("Pament error");
    Toast.show("Pament error", context);
  }

  void handlerExternalWallet(){
    print("External Wallet");
    Toast.show("External Wallet", context);
  }

  void openPaymentGateway(){
    var options = {
      "key" : "rzp_test_blz8Zlo4PPZtB3",
      "amount" : 500,
      "name" : "Complete Your Payment",
      "description" : "${widget.numberPlate}, ${widget.place}",
      "prefill" : {
        "contact" : "8860037713",
        "email" : "${user.email}"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);

    }catch(e){
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
      calChg = (exitHr - entryHr) * _payRate +
          ((exitMn - entryMn) * (_payRate / 60));
      print("Charge : $calChg");
      _notParked = true;
    } catch (e) {
      print(e);
      exit = "Vehicle in Parking";
      _notParked = false;
    }
    return GestureDetector(
      onTap: () {
        // if (_notParked && widget.paid == "" && widget.paid.isEmpty) {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => CreditCardPage(
        //                 amountCharge: calChg,
        //                 numberPlate: widget.numberPlate,
        //               )));
        // }
        openPaymentGateway();
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
