import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:freeder_new/database/texts_database.dart';
import 'package:freeder_new/models/saved_text_model.dart';
import 'package:freeder_new/utils/logger.dart';
import 'package:freeder_new/screens/reader_screen.dart';

class InputCard extends StatelessWidget {
  final Future<void> Function() func;
  InputCard({super.key, required this.func});

  final log = getLogger('InputCard');
  final TextEditingController editcont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          color: const Color.fromARGB(255, 28, 57, 78),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'ваш текст...',
                    hintStyle: TextStyle(color: Colors.white38),
                    border: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 17, 35, 49))),
                  ),
                  // enabled: false,
                  controller: editcont,
                  maxLines: 20,
                  minLines: 1,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () async {
                  if (editcont.text.isNotEmpty) {
                    log.info('Adding new text from input (length: ${editcont.text.length} chars)');
                    final navigator = Navigator.of(context);
                    final id = await addText(editcont.text);
                    log.info('Text saved with ID: $id, navigating to reader');
                    navigator.push(MaterialPageRoute(builder: (context) => ReaderScreen(textid: id))).whenComplete(func);
                  }
                  editcont.clear();
                },
                icon: const Icon(Icons.textsms, color: Colors.white),
                label: const Text('читать', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Card(
          color: const Color.fromARGB(255, 28, 57, 78),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton.icon(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  log.info('Opening file picker for text files');
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: [
                      'txt',
                      // 'doc',
                      // 'docx',
                    ],
                  );
                  if (result == null) {
                    log.info('File picking cancelled');
                    return;
                  }
                  final file = File(result.files.single.path!);
                  log.info('Reading file: ${result.files.single.name}');
                  final content = await file.readAsString();
                  // print(content);
                  final id = await addText(content);
                  navigator.push(MaterialPageRoute(builder: (context) => ReaderScreen(textid: id))).whenComplete(func);
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('выбрать файл', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<int> addText(String wholetext) async {
    log.info('Creating new SavedText entry with ${wholetext.length} characters');
    final ttext = SavedText(title: '', wholetext: wholetext, lastindex: 0, timecreated: DateTime.now());
    final a = await TextsDatabase.instance.create(ttext);
    log.info('Successfully created text with ID: ${a.id}');
    return a.id!;
  }
}
