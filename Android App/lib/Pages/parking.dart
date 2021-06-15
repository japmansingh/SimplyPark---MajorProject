import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:minor_project/Pages/addNumberPlate.dart';
import 'package:minor_project/Pages/detailedNumberPlate.dart';

class Parking extends StatefulWidget {
  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  final numberPlateRef = FirebaseFirestore.instance
      .collection('number_plate')
      .doc(user.id)
      .collection("number_plate");
  String numberPlate;

  Widget listItem(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          height: 130,
          width: MediaQuery.of(context).size.width / 2,
          color: Colors.grey[200],
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailedNumPltSrn(document.data())),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15.0, right: 15.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width / 3,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              '${document["numberPlateNumber"]}',
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Text(
                            "Owner: ${document["ownername"]}",
                            style: TextStyle(
                              fontSize: 17,
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.18,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Text(
                            'Car Model: ${document["model"]}',
                            style: TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            numberPlate = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddNumberPlate()));
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0XFF003051),
        ),
        body: StreamBuilder(
          stream: numberPlateRef
              .orderBy('timestamp', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Loading....."),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return listItem(context, snapshot.data.documents[index]);
                });
          },
        ));
  }
}
