import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PaymentDone extends StatefulWidget {
  PaymentDone({this.numberPlate});

  final String numberPlate;

  @override
  _PaymentDoneState createState() => _PaymentDoneState();
}

class _PaymentDoneState extends State<PaymentDone> {
  Timer _timer;
  int _start = 4;
  bool _isOk = false;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (this.mounted)
        setState(
          () {
            if (_start < 1) {
              timer.cancel();
              _isOk = true;
            } else {
              _start = _start - 1;
            }
          },
        );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    if (_start == 0) {
      _timer?.cancel();
      // Timer(Duration(seconds: 1), () => Navigator.pop(context));
    }
    if (_isOk) {
      print("xCV");
      Timer(Duration(seconds: 1), () => Navigator.pop(context));
    }
    double height = MediaQuery.of(context).size.height / 2;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false),
        body: Column(
          children: [
            Container(
              height: height,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SpinKitWave(
                    color: Colors.black, type: SpinKitWaveType.start),
              ),
            ),
            Text("Processing your Payment in $_start seconds."),
          ],
        ));
  }
}
