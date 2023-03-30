import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  void backToPreviousScreen(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => backToPreviousScreen(context),
            icon: Icon(
              Icons.dashboard,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Not found...',
              style: TextStyle(
                color: colorScheme.onSecondaryContainer,
                fontSize: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
