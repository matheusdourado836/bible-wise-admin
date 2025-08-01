import 'package:bible_wise_admin/provider/devocional_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RejectedReasonDialog extends StatefulWidget {
  final String devocionalId;
  const RejectedReasonDialog({super.key, required this.devocionalId});

  @override
  State<RejectedReasonDialog> createState() => _RejectedReasonDialogState();
}

class _RejectedReasonDialogState extends State<RejectedReasonDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Motivo'),
      content: SizedBox(
        height: 100,
        child: TextField(
          controller: _controller,
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final devocionalProvider = Provider.of<DevocionalProvider>(context, listen: false);
            devocionalProvider.updateUserData(widget.devocionalId, {"status": 2, "rejectReason": _controller.text}).whenComplete(() => Navigator.pop(context, true));
          },
          child: const Text('Enviar')
        )
      ],
    );
  }
}
