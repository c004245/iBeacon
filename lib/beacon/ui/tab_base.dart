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
  List<ListTabResult> _results = [];
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
        _results.insert(0, result);
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
          //Header 구성
          Header(
            regionIdentifier: 'test',
            running: _running,
            onStart: _onStart,
            onStop: _onStop,
          ),
          Expanded(
            child: ListView(
              children: ListTile
                  .divideTiles(
                    context: context,
                tiles: _results
                  .map((location) => new _Item(result: location))
                  .toList(),
              ).toList(),
            )
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

class _Item extends StatelessWidget {
  _Item({@required this.result});

  final ListTabResult result;

  @override
  Widget build(BuildContext context) {
    final String text = result.text;
    final String status = result.isSuccessful ? 'success' : 'failure';
    final Color color = result.isSuccessful ? Colors.green : Colors.red;

    final List<Widget> content = <Widget> [
      Text(
        text,
        style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(
        height: 3.0,
      )
    ];

    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 56.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: content,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: new BorderRadius.circular(6.0),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  )
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}