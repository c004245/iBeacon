import 'dart:async';

import 'package:beacon_module/beacon/beacons.dart';

import 'tab_base.dart';
class RangingTab extends ListTab {
  RangingTab() : super(title: 'Ranging');

  @override
  Stream<ListTabResult> stream(BeaconRegion region) {
    return Beacons
        .ranging(
      region: region,
      inBackground: false,
    )
      .map((result) {
      String text;
      if (result.isSuccessful) {
        text = result.beacons.isNotEmpty
            ? 'RSSI: ${result.beacons.first.ids[1]} ${result.beacons.first.ids[2]}'
            : 'No beacon in range';
      } else {
        text = result.error.toString();
      }
      return new ListTabResult(text: text, isSuccessful: result.isSuccessful);
      });
    }
  }