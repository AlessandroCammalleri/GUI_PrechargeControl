// ignore_for_file: prefer_const_constructors, avoid_function_literals_in_foreach_calls, use_build_context_synchronously, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables, unused_import

import 'package:flutter/material.dart';
import 'dart:convert';
import 'main.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 10.0,
        ),
      ),
    );
  }
}
