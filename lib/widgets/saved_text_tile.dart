import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:intl/intl.dart';
import 'package:freeder_new/database/texts_database.dart';
import 'package:freeder_new/models/saved_text_model.dart';
import 'package:freeder_new/screens/edit_screen.dart';

class SavedTextTile extends StatefulWidget {
  final SavedText st;
  final Future<void> Function() funk;
  const SavedTextTile({super.key, required this.st, required this.funk});

  @override
  State<SavedTextTile> createState() => _SavedTextTileState();
}

class _SavedTextTileState extends State<SavedTextTile> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Offset distance = isPressed ? Offset(2, 2) : Offset(10, 10);
    // double blur = isPressed ? 5 : 15;
    // return GestureDetector(
    //   onTap: () => setState(() {
    //     isPressed = !isPressed;
    //   }),
    //   child: Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: AnimatedContainer(
    //       duration: const Duration(milliseconds: 100),
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(15),
    //         color: const Color.fromARGB(255, 17, 35, 49),
    //         boxShadow: [
    //           BoxShadow(offset: distance, color: const Color.fromARGB(255, 12, 25, 36), blurRadius: blur, inset: isPressed),
    //           BoxShadow(offset: -distance, color: const Color.fromARGB(255, 24, 48, 66), blurRadius: blur, inset: isPressed)
    //         ],
    //       ),
    //       child: Column(
    //         children: [
    //           Text(
    //             DateFormat.yMMMd().format(widget.st.timecreated),
    //           ),
    //           const SizedBox(
    //             height: 5,
    //           ),
    //           Text(widget.st.title),
    //           Text(
    //             widget.st.wholetext,
    //             style: const TextStyle(
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Card(
      color: const Color.fromARGB(255, 28, 57, 78),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMd().format(widget.st.timecreated),
              style: const TextStyle(
                color: Colors.white38,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // Text(
            //   widget.st.title,
            //   style: TextStyle(color: Colors.white, fontSize: 17),
            // ),
            Expanded(
              child: Text(
                widget.st.wholetext,
                style: const TextStyle(
                    // overflow: TextOverflow.ellipsis,
                    color: Colors.white70,
                    fontSize: 15),
                // overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    await replayText();
                  },
                  icon: const Icon(
                    Icons.replay_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5,),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditScreen(st: widget.st),
                      ),
                    ).whenComplete(widget.funk);
                  },
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                  ),
                ),
                // TextButton.icon(
                //   onPressed: () async {
                //     await replayText();
                //   },
                //   icon: const Icon(
                //     Icons.replay_outlined,
                //     color: Colors.white,
                //   ),
                //   label: const Text(
                //     // 'заново',
                //     '',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                // // const SizedBox(width: 5,),
                // TextButton.icon(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => EditScreen(st: widget.st),
                //       ),
                //     ).whenComplete(widget.funk);
                //   },
                //   icon: const Icon(
                //     Icons.edit_outlined,
                //     color: Colors.white,
                //   ),
                //   label: const Text(
                //     // 'изменить',
                //     '',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> replayText() async {
    final updatedtext = widget.st.copy(
      lastindex: 0,
    );
    await TextsDatabase.instance.update(updatedtext);
  }
}
