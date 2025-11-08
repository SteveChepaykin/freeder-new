import 'package:flutter/material.dart';
import 'package:freeder_new/models/saved_text_model.dart';
import 'package:freeder_new/database/texts_database.dart';

class EditScreen extends StatefulWidget {
  final SavedText st;
  const EditScreen({super.key, required this.st});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController textedit = TextEditingController();
  final TextEditingController positionedit = TextEditingController();
  // final TextEditingController headeredit = TextEditingController();
  List<String> textlist = [];
  int index = 0;
  String alltext = '';
  int untillength = 0;
  bool isredacting = false;

  @override
  void initState() {
    textedit.text = widget.st.wholetext;
    positionedit.text = (widget.st.lastindex + 1).toString();
    index = widget.st.lastindex;
    alltext = widget.st.wholetext;
    // headeredit.text = widget.st.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    untillength = 0;
    textlist = alltext.split(' ');
    if(index >= textlist.length) {
      index = textlist.length - 1;
    }
    for (String a in textlist.sublist(0, index)) {
      untillength += a.length;
    }
    untillength += index;
    textedit.text = alltext;
    positionedit.text = (index + 1).toString();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
        actions: [
          TextButton.icon(
            onPressed: () {
              // alltext.replaceAll(' █ ', ' ');
              updateText(
                alltext,
                int.parse(positionedit.text) - 1,
              );
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: const Text(
              'save',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              !isredacting ? RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 17, color: Colors.white),
                  children: [
                    TextSpan(
                      text: alltext.substring(0, untillength),
                    ),
                    TextSpan(
                      text: alltext.substring(untillength, untillength + textlist[index].length),
                      style: const TextStyle(fontSize: 17, backgroundColor: Color.fromARGB(255, 245, 164, 0), color: Colors.black),
                    ),
                    TextSpan(
                      text: alltext.substring(untillength + textlist[index].length),
                    )
                  ],
                ),
              ) : TextField(
                controller: textedit,
                maxLines: null,
                style: const TextStyle(fontSize: 17, color: Colors.white),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: 'add text...', hintStyle: TextStyle(color: Colors.white54)),
                onEditingComplete: () {
                  setState(() {
                    index = int.parse(positionedit.text) - 1;
                    untillength = 0;
                    alltext = textedit.text;
                    isredacting = false;
                    textedit.clear();
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          isredacting = true;
                        });
                      },
                      icon: const Icon(
                        Icons.edit_note_rounded,
                        color: Colors.white,
                      ),
                      label: const Text('изменить', style: TextStyle(color: Colors.white),),
                    ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'позиция в тексте:',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        index -= 1;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: positionedit,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      onEditingComplete: () {
                        setState(() {
                          index = int.parse(positionedit.text) - 1;
                          untillength = 0;
                        });
                      },
                    ),
                  ),
                  const Text(
                    'слово',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        index += 1;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateText(String newlasttext, int newlastindex) async {
    final updatedtext = widget.st.copy(
      wholetext: newlasttext,
      lastindex: newlastindex,
      // title: newheader,
    );
    await TextsDatabase.instance.update(updatedtext);
  }
}
