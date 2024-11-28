import 'package:ae_project/debug_page.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Usbcommunication extends StatefulWidget {
  const Usbcommunication({super.key});

  @override
  State<Usbcommunication> createState() => _UsbCommunication();
}

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

    await Future.delayed(const Duration(seconds: 10));

    Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) {
      return DebugPage();
    }));
  }

  void usbinitcomm() {}
  void sendMessage(bool debug) {
    if (debug) {
      //message
    } else {
      //message
    }
  }

  void collectSamples() {}
  void separateSamples_charge() {}
  void separateSamples_type() {}
}
