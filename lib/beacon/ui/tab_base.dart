import 'dart:async';

import 'package:beacon_module/beacon/beacons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'header.dart';

abstract class ListTab extends StatefulWidget {

  const ListTab({Key key, this.title}) : super(key: key);

  final String title;

  Stream<ListTabResult> stream(BeaconRegion region);

  @override
  _ListTabState createState() => new _ListTabState();
}

class ListTabData {}

class _ListTabState extends State<ListTab> {
  List<ListTabResult> _result = [];
  StreamSubscription<ListTabResult> _subscription;
  int _subscriptionStartedTimeStamp;
  bool _running = false;

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  void _onStart(BeaconRegion region) {
    setState(() {
      _running = true;
    });

    _subscriptionStartedTimeStamp = new DateTime.now().millisecondsSinceEpoch;
    _subscription = widget.stream(region).listen((result) {
      result.elaspedTimeSeconds = (new DateTime.now().millisecondsSinceEpoch -
          _subscriptionStartedTimeStamp) ~/ 1000;

      setState(() {
        _result.insert(0, result);
      });
    });

    _subscription.onDone(() {
      setState(() {
        _running = false;
      });
    });
  }

  void _onStop() {
    setState(() {
      _running = false;
    });

    _subscription.cancel();
    _subscriptionStartedTimeStamp = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Header(
            regionIdentifier: 'test',
            running: _running,
            onStart: _onStart,
            onStop: _onStop,
          )
        ],
      )
    );
  }
}

class ListTabResult {
  ListTabResult({
    @required this.text,
    @required this.isSuccessful,
});

  final String text;
  final bool isSuccessful;
  int elaspedTimeSeconds;
}