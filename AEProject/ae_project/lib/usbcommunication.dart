import 'dart:ffi';
import 'dart:typed_data';

import 'package:ae_project/debug_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:number_system/number_system.dart';

import 'main.dart';

class Usbcommunication extends StatefulWidget {
  const Usbcommunication({super.key});

  @override
  State<Usbcommunication> createState() => _UsbCommunication();
}

List<String> availablePorts = SerialPort.availablePorts;
//print(availablePorts);
SerialPort port1 = SerialPort('COM3');

class _UsbCommunication extends State<Usbcommunication> {
  @override
  Widget build(BuildContext context) {
    if (debug) {
      debugCommunication();
    } else {
      prechargeCommunication();
    }

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 10.0,
        ),
      ),
    );
  }

  void debugCommunication() async {
    usbinitcomm();
    sendMessage(debug);
    collectSamples();
    separateSamples_charge();
    separateSamples_type();

    await Future.delayed(const Duration(seconds: 2));

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DebugPage();
    }));
  }

  void prechargeCommunication() async {
    usbinitcomm();
    sendMessage(debug);
    collectSamples();
    separateSamples_type();

    await Future.delayed(const Duration(seconds: 2));

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DebugPage();
    }));
  }

  void usbinitcomm() {
    try {
      port1.openReadWrite();
      final config = SerialPortConfig();
      config.baudRate = 115200;
      port1.config = config;
    } on SerialPortError catch (err, _) {
      print(SerialPort.lastError);
    }
  }

  void sendMessage(bool debug) {
    if (debug) {
      //message
      String message = '#1';
      print(_byteToUint8List(message.hexToDEC()));
      port1.write(_byteToUint8List(message.hexToDEC()));
    } else {
      //message
      String message = '#2';
      port1.write(_byteToUint8List(message.hexToDEC()));
      //message
    }
  }

  void collectSamples() {}
  void separateSamples_charge() {}
  void separateSamples_type() {}

  Uint8List _stringToUint8List(String data) {
    List<int> codeUnits = data.codeUnits;
    Uint8List uint8list = Uint8List.fromList(codeUnits);
    return uint8list;
  }

  Uint8List _byteToUint8List(int data) {
    List<int> dataunit = [];
    dataunit.add(data);
    Uint8List uint8list = Uint8List.fromList(dataunit);
    return uint8list;
  }
}
