import 'package:flutter/material.dart';
import 'sig.dart';
import 'kem.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      child: Text("Kem Example"),
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (context) => KemApp()))),
                  TextButton(child: Text("Signature Example"), onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SigApp())))
                ])));
  }
}

