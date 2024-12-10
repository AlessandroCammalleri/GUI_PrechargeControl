import 'package:flutter/material.dart';
import 'main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:typed_data';

import 'usbcommunication.dart';
import 'package:ae_project/samples/current_samples.dart';
import 'package:ae_project/samples/voltage_samples.dart';

String id_message = frame.substring(0, 8);
String dlc_message = frame.substring(8, 10);
String payload = frame.substring(10);

List<CurrentSamples> currentsamples = [];
List<VoltageSamples> voltagesamples = [];

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    print(frame.length);
    print('Id Message: $id_message');
    print('Dlc: $dlc_message');
    print('Payload: $payload');

    reader.close();
    port1.dispose();

    checkdlc();
    messagecontent();

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("PreCharge Graphs"),
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const MyApp();
                    },
                  ));
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
              actions: [
                PopupMenuButton(
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Precharge 1"),
                            value: 1,
                            onTap: () {
                              setState(() {});
                            },
                          ),
                          PopupMenuItem(
                            child: Text("Precharge 2"),
                            value: 2,
                            onTap: () {
                              setState(() {});
                            },
                          ),
                          PopupMenuItem(
                            child: Text("Precharge 3"),
                            value: 3,
                            onTap: () {
                              setState(() {});
                            },
                          )
                        ])
              ],
            ),
            body: Column(
              children: [
                Flexible(
                  flex: 5,
                  child: Center(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: voltagesamples.map((point) => FlSpot(point.microseconds, point.millivolt))
                              .toList(),
                            isCurved: true,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Center(
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: currentsamples.map((point) => FlSpot(point.microseconds, point.milliampere))
                              .toList(),
                            isCurved: true,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }

  void checkdlc() {}

  void messagecontent() {
    switch (id_message) {
      case 'A3F4A3F4':
        print('Current and voltages values');
        collectsamples();
        break;
      default:
        break;
    }
  }

  void collectsamples() {
    print(payload.runes.length);
    String message = payload.substring(0, (payload.length - 4));
    print(payload);
    print(message);

    String currentsamples_string =
        message.substring(0, ((message.length / 2) + 1).round() - 1);
    String voltagesamples_string =
        message.substring(((message.length / 2) + 1).round() - 1);

    print('Currents : $currentsamples_string');
    print('Voltages : $voltagesamples_string');

    print(message.length);
    int samplenumber = (currentsamples_string.length / 3).round();
    print(samplenumber);

    double milliseconds = 0;
    double frequency = 25;

    for (var i = 0; i < samplenumber; i++) {
      print(i);
      //String str = '0x';
      String str1 = currentsamples_string.substring(0, 3);
      String str2 = voltagesamples_string.substring(0, 3);
      print(str1);
      final number1 = int.parse(str1, radix: 16);
      final number2 = int.parse(str2, radix: 16);
      print(number1);

      //create sample
      currentsamples.add(CurrentSamples(
          microseconds: milliseconds, milliampere: number1 / 100));
      voltagesamples.add(VoltageSamples(
          microseconds: milliseconds, millivolt: number2 / 100));

      milliseconds += frequency;

      currentsamples_string = currentsamples_string.substring(3);
      voltagesamples_string = voltagesamples_string.substring(3);
    }
  }
}
