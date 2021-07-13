import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minor_project/Pages/AuthenticationPage.dart';
import 'package:minor_project/widgets/log_tile.dart';

class PendingPayments extends StatefulWidget {
  @override
  _PendingPaymentsState createState() => _PendingPaymentsState();
}

class _PendingPaymentsState extends State<PendingPayments> {
  final logsRef = FirebaseFirestore.instance
      .collection('logs')
      .doc(user.id)
      .collection("logs");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Pending Payments"),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: logsRef.orderBy('entry_timestamp', descending: true)?.snapshots(),
          builder: (context, snapshot) {
            print(
                "***************************************entered snapshot $snapshot");
            if (!snapshot.hasData) {
              return Center(
                child: Text("Loading Logs....."),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data.documents[index];
                  return document['paid'] != 'paid' ? LogTile(
                    entryTimestamp: document["entry_timestamp"],
                    exitTimestamp: document['exit_timestamp'],
                    numberPlate: document["number_plate"],
                    place: document['place'],
                    paid: document['paid'] ?? '',
                  ): Container();
                });
          },
        ));
  }
}
