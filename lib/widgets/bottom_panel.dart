import 'package:flutter/material.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final String lastText;
  const PanelWidget({super.key, required this.controller, required this.lastText});

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          buildHeaderButton(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.lastText.isEmpty ? '...' : widget.lastText,
                style: const TextStyle(fontSize: 20, color: Colors.white),
                // textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderButton() => Center(
        child: Container(
          width: 30,
          height: 5,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 199, 199, 199),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      );
}
