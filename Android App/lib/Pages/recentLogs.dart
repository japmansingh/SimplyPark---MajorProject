import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/widgets/log_tile.dart';
import 'AuthenticationPage.dart';

class RecentLogs extends StatefulWidget {
  RecentLogs({this.numberPlate});

  final String numberPlate;

  @override
  _RecentLogsState createState() => _RecentLogsState();
}

class _RecentLogsState extends State<RecentLogs> {
  Widget ListItem(BuildContext context, DocumentSnapshot document) {
    String entry = document["entry_timestamp"];
    String exit = document["exit_timestamp"];
    return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          height: 190,
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
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 3,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          '${document["number_plate"]}',
                          // '${document["place"]}',
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
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
                      'Place: ${document["place"]}',
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
                Padding(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logsRef = FirebaseFirestore.instance
        .collection('logs')
        .doc(user.id)
        .collection(widget.numberPlate);
    return Scaffold(
        appBar: AppBar(
          title: Text('Recent Logs'),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream:
              logsRef.orderBy('entry_timestamp', descending: true)?.snapshots(),
          builder: (context, snapshot) {
            print(
                "***************************************entered snapshot $snapshot");
            if (!snapshot.hasData) {
              return Center(
                child: Text("Loading Recent Logs....."),
              );
            }
            return Scaffold(
              body: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data.documents[index];

                    return LogTile(
                      entryTimestamp: document["entry_timestamp"],
                      exitTimestamp: document['exit_timestamp'],
                      numberPlate: document["number_plate"],
                      place: document['place'],
                      paid: document['paid'] ?? '',
                    );
                  }),
            );
          },
        ));
  }
}
