import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red[100],
      child: Text(
        message,
        style: TextStyle(color: Colors.red[900]),
      ),
    );
  }
}
