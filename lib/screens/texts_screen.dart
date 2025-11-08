import 'package:flutter/material.dart';
// import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:freeder_new/database/texts_database.dart';
import 'package:freeder_new/database/user_prefs.dart';
import 'package:freeder_new/models/saved_text_model.dart';
import 'package:freeder_new/screens/reader_screen.dart';
import 'package:freeder_new/screens/settings_screen.dart';
import 'package:freeder_new/widgets/input_card.dart';
import 'package:freeder_new/widgets/saved_text_tile.dart';

class TextsScreen extends StatefulWidget {
  const TextsScreen({super.key});

  @override
  State<TextsScreen> createState() => _TextsScreenState();
}

class _TextsScreenState extends State<TextsScreen> {
  TextEditingController editcont = TextEditingController();
  ScrollController scrollcont = ScrollController();
  List<SavedText> savedtexts = [];
  bool isLoading = false;
  // bool isInitialised = false;

  @override
  void initState() {
    refreshNotes().whenComplete(() => setState(() {}));
    // FlutterMobileVision.start().then((value) => isInitialised = true);
    // s();
    super.initState();
  }

  void s() async {
    await UserPrefs().setPrefs();
  }

  @override
  void dispose() {
    TextsDatabase.instance.closeDB();
    super.dispose();
  }

  Future<void> refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    savedtexts = await TextsDatabase.instance.readAllSavedTexts();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        // title: const Text('"читальня"'),
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     await refreshNotes();
          //   },
          //   icon: const Icon(Icons.replay),
          // ),
          // IconButton(
          //   onPressed: () {
          //     startScan();
          //   },
          //   icon: const Icon(Icons.add),
          // ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SettingsScreen()));
            },
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              InputCard(func: refreshNotes),
              const SizedBox(height: 30),
              GridView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                controller: scrollcont,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
                  childAspectRatio: 6 / 10,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  ...savedtexts.map(
                    (st) => GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(textid: st.id!))).whenComplete(() async {
                          await refreshNotes();
                        });
                      },
                      onLongPressEnd: (details) async {
                        showDialog(context: context, builder: (constext) => dialog(st));
                      },
                      child: SavedTextTile(st: st, funk: refreshNotes),
                    ),
                  ),
                  // tile(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteAndRefresh(int id) async {
    await TextsDatabase.instance.delete(id);
    await refreshNotes();
  }

  Widget dialog(SavedText st) => AlertDialog(
    backgroundColor: const Color.fromARGB(255, 17, 35, 49),
    title: const Text('УДАЛЕНИЕ', style: TextStyle(color: Colors.white)),
    content: Text(
      'уверены что хотите удалить текст: ${st.wholetext}',
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white),
    ),
    actions: [
      TextButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.close_rounded, color: Colors.white),
        label: const Text('назад', style: TextStyle(color: Colors.white)),
      ),
      TextButton.icon(
        onPressed: () {
          deleteAndRefresh(st.id!);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.check_rounded, color: Colors.white),
        label: const Text('удалить', style: TextStyle(color: Colors.white)),
      ),
    ],
  );

  // Future<String> startScan() async {
  //   List<OcrText> ocrlist = [];
  //   String res = '';
  //   try {
  //     ocrlist = await FlutterMobileVision.read(
  //       waitTap: true,
  //       multiple: true,
  //       camera: FlutterMobileVision.CAMERA_BACK,
  //       fps: 15,
  //     );
  //     for(OcrText text in ocrlist) {
  //       res = res + text.value + ' ';
  //     }

  //   } on Exception catch (e) {
  //     print(e);
  //   }
  //   print(res);
  //   return res.isNotEmpty ? res : 'no text found';
  // }
}
