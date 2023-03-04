import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class GameFinishedScreen extends StatelessWidget {
  const GameFinishedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // todo: layout for this screen
    return Scaffold(
      appBar: AppBar(
        title: Text("Results"),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
