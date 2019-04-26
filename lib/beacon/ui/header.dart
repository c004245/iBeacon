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
  TextEditingController _id1Controller;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _formType = Platform.isIOS ? FormType.iBeacon : FormType.generic;

    _id1Controller = TextEditingController(
      text: _formType == FormType.iBeacon
          ? '7c364ba4-b23f-43ba-80ab-49e05ef02cdb'
          : '7c364ba4-b23f-43ba-80ab-49e05ef02cdb',
    );

    debugPrint('formType ---> $_formType');
  }

  void _onFormTypeChanged(FormType value) {
    setState(() {
      _formType = value;
    });
  }

  void _onTapSubmit() {
    debugPrint('Tab SubMit...');

    if (widget.running) {
      widget.onStop();
    } else {
      if (!_formKey.currentState.validate()) {
        return;
      }

      List<dynamic> ids = [];
      if (_id1Controller.value.text.isNotEmpty) {
        ids.add(_id1Controller.value.text);
      }

      BeaconRegion region =
          BeaconRegion(identifier: widget.regionIdentifier, ids: ids);


      switch (_formType) {
        case FormType.iBeacon:
          region = BeaconRegionIBeacon.from(region);
          break;
        case FormType.generic:
          // TODO: Handle this case.
          break;
      }

      widget.onStart(region);
    }

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
            Form(
              key: _formKey,
              child: _formType == FormType.generic
                ? null
                : new _FormIBeacon(
                    running: widget.running,
                    id1Controller: _id1Controller,
              ),
            ),
        SizedBox(
          height: 10.0,
        ),
        _Button(
          running: widget.running,
          onTap: _onTapSubmit,
        )
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

//Form IBeacon
class _FormIBeacon extends StatelessWidget {
  const _FormIBeacon(
  {Key key,
  this.running,
  this.id1Controller})
  : super(key: key);

  final bool running;
  final TextEditingController id1Controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          enabled: !running,
          validator: (String value) {
            if (value.isEmpty) {
              return 'required';
            }
          },
          controller: id1Controller,
          decoration: const _TextFieldDecoration().copyWith(hintText: 'UUID'),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new SizedBox(
              width: 10.0,
            )
          ],
        )
      ],
    );
  }
}

class _TextFieldDecoration extends InputDecoration {
  const _TextFieldDecoration()
    : super(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        border: const OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
          borderSide: const BorderSide(
            color: Colors.green,
            width: 1.0,
          )
        )
  );
}

enum FormType {
  generic, iBeacon
}