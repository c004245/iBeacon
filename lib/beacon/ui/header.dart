import 'package:beacon_module/beacon/beacons.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:io';

class Header extends StatefulWidget {
  const Header({Key key, this.regionIdentifier, this.running, this.onStart, this.onStop}) : super(key: key);

  final String regionIdentifier;
  final bool running;
  final ValueChanged<BeaconRegion> onStart;
  final VoidCallback onStop;

  @override
  _HeaderState createState() => new _HeaderState();
}

class _HeaderState extends State<Header> {
  FormType _formType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _formType = Platform.isIOS ? FormType.iBeacon : FormType.generic;

    debugPrint('formType ---> $_formType');
  }

  void _onFormTypeChanged(FormType value) {
    setState(() {
      _formType = value;
    });
  }

  void _onTapSubmit() {

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                    'Beacon format',
                style: Theme.of(context).textTheme.title,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: new RadioListTile(
                      value: FormType.generic,
                      groupValue: _formType,
                      onChanged: widget.running
                          ? null
                          : (Platform.isAndroid ? _onFormTypeChanged : null),
                      title : Text(Platform.isAndroid
                          ? 'Generic'
                          : 'Generic (not supported on iOS'),
                  )
                ),
                Flexible(
                  child: new RadioListTile(
                  value: FormType.iBeacon,
                  groupValue: _formType,
                  onChanged: widget.running ? null : _onFormTypeChanged,
                  title : const Text('iBeacon'),
                )),
              ],
            ),
        /*    Form(
              key: _formKey,
              child: _formType == FormType.generic
                  ? _FormGeneric(
                running: widget.running,
              )
                  : _FormIBeacon(
                running: widget.running,
              ),
            ),*/
            new SizedBox(
              height: 10.0,
            ),
            new _Button(
              running: widget.running,
              onTap: _onTapSubmit,
            ),
          ],
        ),
    );
  }
}

class _Button extends StatelessWidget {
  _Button({
    @required this.running,
    @required this.onTap,
  });

  final bool running;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          decoration: BoxDecoration(
            color: running ? Colors.deepOrange : Colors.teal,
            borderRadius: BorderRadius.all(
              Radius.circular(6.0),
            )
          ),
          child: Text(
            running ? 'Stop' : 'Start',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

enum FormType {
  generic, iBeacon
}