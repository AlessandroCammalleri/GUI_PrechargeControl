import 'package:flutter/material.dart';
import 'main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:typed_data';

import 'usbcommunication.dart';

String id_message = frame.substring(0, 8);
String dlc_message = frame.substring(8, 10);
String payload = frame.substring(10);

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    print('Id Message: $id_message');
    print('Dlc: $dlc_message');
    print('Payload: $payload');

    reader.close();
    port1.dispose();

    checkdlc();

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
                            isCurved: false,
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
                            isCurved: false,
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



  void checkdlc(){
     }
}
