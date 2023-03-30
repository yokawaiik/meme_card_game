import 'package:flutter/material.dart';

class FullErrorWidget extends StatelessWidget {
  const FullErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Something went wrong..."),
      ),
    );
  }
}
