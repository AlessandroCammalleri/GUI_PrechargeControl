import 'dart:ffi';
import 'dart:typed_data';

import 'package:ae_project/debug_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:number_system/number_system.dart';

import 'main.dart';

String frame = '';

SerialPort port1 = SerialPort("COM3");
List<String> availablePort = SerialPort.availablePorts;
var config = SerialPortConfig()
  ..baudRate = 115200
  ..bits = 8
  ..parity = SerialPortParity.none
  ..stopBits = 1
  ..xonXoff = 0
  ..rts = 1
  ..cts = 0
  ..dsr = 0
  ..dtr = 1;

SerialPortReader reader = SerialPortReader(port1);
Stream<String> upcomingdata = reader.stream.map((data) {
  return String.fromCharCodes(data);
});

class Usbcommunication extends StatefulWidget {
  const Usbcommunication({super.key});

  @override
  State<Usbcommunication> createState() => _UsbCommunication();
}

class _UsbCommunication extends State<Usbcommunication> {
  @override
  Widget build(BuildContext context) {
    print(availablePort);

    port1.config = config;
    print(port1.openReadWrite());

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
    sendMessage(debug);
    receiveMessage();

    await Future.delayed(const Duration(seconds: 5));

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DebugPage();
    }));
  }

  void prechargeCommunication() async {
    sendMessage(debug);
    receiveMessage();

    await Future.delayed(const Duration(seconds: 5));

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DebugPage();
    }));
  }

  void sendMessage(bool debug) async {
    if (debug) {
      try {
        //message sent to the MicroController
        print(port1.write(_stringToUint8List('Message in hexadecimal form')));
      } on SerialPort catch (err, _) {
        print(SerialPort.lastError);
      }
    } else {
      String message = '#2';
    }
  }

  void receiveMessage() async {
    try {
      upcomingdata.listen((data) {
        print('Read Data: $data');
        frame += data;
      });
    } on SerialPort catch (err, _) {
      print(SerialPort.lastError);
    }
  }

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
