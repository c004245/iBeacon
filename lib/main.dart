import 'package:flutter/material.dart';
import 'package:beacon_module/beacon/beacons.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'beacon/ui/tab_ranging.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    Beacons.loggingEnabled = true;

//    Beacons.configure(BeaconsSettings(
//      android: BeaconsSettingsAndroid(
//        logs: BeaconsSettingsAndroidLogs.info,
//      )
//    ));
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to indi                                                                                 vidually change instances of widgets.
    return MaterialApp(
      home: CupertinoTabScaffold(
          tabBar: new CupertinoTabBar(
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                title: new Text('Track'),
                icon: new Icon(Icons.location_searching),
              ),
              new BottomNavigationBarItem(
                title: new Text('Monitoring'),
                icon: new Icon(Icons.settings_remote),
              ),
              new BottomNavigationBarItem(
                title: new Text('Settings'),
                icon: new Icon(Icons.settings_input_antenna),
              ),
            ],
          ),
        tabBuilder: (BuildContext context, int index) {
            return CupertinoTabView(
              builder: (BuildContext context) {
                switch (index) {
                  case 0:
                    debugPrint('RangingTab....');
                    return RangingTab();
                }
              }
            );
        }
        )
    );
  }
}
