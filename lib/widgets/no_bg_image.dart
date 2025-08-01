import 'package:flutter/material.dart';

import 'frosted_container.dart';

class NoBgImage extends StatelessWidget {
  final String title;
  const NoBgImage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.45), BlendMode.darken),
          image: const AssetImage('assets/images/santidade.png'),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: FrostedContainer(title: title),
      ),
    );
  }
}