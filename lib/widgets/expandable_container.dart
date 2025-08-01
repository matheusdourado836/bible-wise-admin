import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../models/devocional.dart';

class ExpandableContainer extends StatelessWidget {
  final String header;
  final String expandedText;
  final Devocional? devocional;
  final bool verCompleto;
  const ExpandableContainer({super.key, required this.header, required this.expandedText, required this.verCompleto, this.devocional});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      color: Theme.of(context).cardTheme.color,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            iconColor: Colors.white,
            iconPadding: EdgeInsets.zero
        ),
        header: Text(header, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        collapsed: Container(),
        expanded: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(expandedText, maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify, style: Theme.of(context).textTheme.titleSmall!.copyWith(height: 1.8, color: Colors.white)),
              const SizedBox(height: 6),
              (verCompleto)
                  ? ElevatedButton(
                  onPressed: (() => Navigator.pushNamed(context, 'devocional_selected', arguments: {"devocional": devocional})),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(191, 170, 140, 1),
                      foregroundColor: Colors.white,
                      fixedSize: const Size(100, 40),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),
                  child: const Text('Ver completo')
              )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}