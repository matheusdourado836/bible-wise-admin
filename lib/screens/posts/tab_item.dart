import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String title;
  final int count;
  const TabItem({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12),),
          count > 0
              ? Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(50)
            ),
            child: Text(
              count > 100 ? '100+' : count.toString(),
              style: const TextStyle(
                  fontSize: 10,
                color: Colors.white
              ),
            ),
          )
              : const SizedBox()
        ],
      ),
    );
  }
}