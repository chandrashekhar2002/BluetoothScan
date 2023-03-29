import 'dart:async';
import 'dart:math';

import 'package:ble_scan/commappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(blueTooth());
}

class blueTooth extends StatefulWidget {
  const blueTooth({Key? key}) : super(key: key);

  @override
  State<blueTooth> createState() => _blueToothState();
}

class _blueToothState extends State<blueTooth> {
  bool _isScanning = false;
  bool _isconnected = false;
  final List<ScanResult> _devices = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var conn;
    return MaterialApp(
      home: Scaffold(
        appBar: commonAppBar(title: 'BLUETOOTH'),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              const Text('Bluetooth Search'),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isScanning = true;
                    _devices.clear();
                  });
                  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
                  flutterBlue.scanResults.listen((List<ScanResult> results) {
                    for (ScanResult result in results) {
                      setState(() {
                        _devices.add(result);
                      });
                    }
                  });
                  await flutterBlue.startScan(timeout: const Duration(seconds: 10));
                  setState(() {
                    _isScanning = false;
                  });
                  flutterBlue.stopScan();
                },
                child: const Text('Start Scanning for Devices'),
              ),
              const Divider(
                color: Colors.black,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: _devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    ScanResult device = _devices[index];
                    return GestureDetector(
                      onTap: () {
                        _isconnected = !_isconnected;
                        setState(()  {
                          ScanResult _device = _devices[index];
                          print('rssi : ${_device.rssi}');
                          print('rssi : ${_device.advertisementData}');
                          print('rssi : ${_device.device}');
                          print('rssi : ${_device.timeStamp}');

                          print('discover services : ${_device.device.discoverServices()}');
                          if(_isconnected == false)
                             conn = _device.device.connect();

                          else
                            conn = _device.device.disconnect();

                          print('connection : ${conn}');
                        });
                      },
                      child: Container(
                        child: ListTile(
                          title: Text(device.device.name ?? 'Unknown Device'),
                          subtitle: Text(device.device.id.toString()),
                          trailing: const Icon(Icons.bluetooth),
                        ),
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: Colors.grey,);
                },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
