import 'package:flutter/material.dart';

class NoBgUser extends StatelessWidget {
  const NoBgUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey,
      ),
      child: const Icon(Icons.person, size: 26),
    );
  }
}