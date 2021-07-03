import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'AuthenticationPage.dart';
import 'recentLogs.dart';

class DetailedNumPltSrn extends StatefulWidget {
  DetailedNumPltSrn(this.data);

  final Map data;

  @override
  _DetailedNumPltSrnState createState() => _DetailedNumPltSrnState();
}

class _DetailedNumPltSrnState extends State<DetailedNumPltSrn> {
  @override
  Widget build(BuildContext context) {
    print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.data['numberPlateNumber']}'),
        backgroundColor: Color(0XFF003051),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('number_plate')
                    .doc(user.id)
                    .collection("number_plate")
                    .doc(widget.data['numberPlateNumber'])
                    .delete();

                FirebaseFirestore.instance
                    .collection('logs')
                    .doc(user.id)
                    .collection("logs")
                    .doc('Q12w' + widget.data['numberPlateNumber'])
                    .delete();

                FirebaseFirestore.instance
                    .collection('logs')
                    .doc(user.id)
                    .collection(widget.data['numberPlateNumber'])
                    .get()
                    .then((snapshot) {
                  for (DocumentSnapshot ds in snapshot.docs) {
                    ds.reference.delete();
                  }
                });

                // final delNumPlate = FirebaseFirestore.instance
                //     .collection('logs')
                //     .doc(user.id)
                //     .collection(widget.data['numberPlateNumber'])
                //     .where("number_plate",
                //         isEqualTo: widget.data['numberPlateNumber'])
                //     .snapshots();
                // delNumPlate.forEach((ele) {
                //   print(ele.docs);
                //   ele.docs.forEach((element) {
                //     print(element.id);
                //     FirebaseFirestore.instance
                //         .collection('logs')
                //         .doc(user.id)
                //         .collection("logs")
                //         .doc(element.id)
                //         .delete();
                //   });
                // });
                Navigator.pop(context);
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Material(
            elevation: 5.0,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Engine Number : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["engineNumber"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Fuel Type : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["fuelType"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Owner Name : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["ownername"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Fitness Up-to : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["fitnessUpto"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Chassis Number : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["chassisNumber"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Registration Date : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["regDate"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Vehicle Class : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["vehicleClass"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Registration Number : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["registerationNumber"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Fitness Up-to : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["fitnessUpto"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Insurance Expiry : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["insuranceExpiry"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Registering Authority : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["registeringAuthority"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
                SizedBox(
                  height: 7,
                  width: 10.0,
                ),
                RichText(
                    text: TextSpan(
                        text: "Model : ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                      TextSpan(
                        text: widget.data["model"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                      )
                    ])),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecentLogs(
                        numberPlate: widget.data['numberPlateNumber'],
                      )));
        },
        child: Icon(Icons.update),
        backgroundColor: Color(0XFF003051),
      ),
    );
  }
}
