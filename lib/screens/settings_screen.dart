import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freeder_new/controllers/state_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController cont = TextEditingController();
  late int spd;

  @override
  void initState() {
    final a = Get.find<StateController>();
    cont.text = a.getSize().toString();
    spd = a.getSpeed()!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 35, 49),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 57, 78),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text('размер текста:',  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '25 < ',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: cont,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                  const Text(
                    ' > 75',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'скорость чтения (слов/мин):',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  butn(100),
                  butn(150),
                  butn(200),
                  butn(250),
                  butn(300),
                  butn(350),
                  butn(400),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton.icon(
                onPressed: () {
                  if (int.parse(cont.text) > 25 && int.parse(cont.text) < 75) {
                    final a = Get.find<StateController>();
                    // a.changeFontSize(int.parse(cont.text));
                    a.setSize(int.parse(cont.text));
                    // a.changeSpeed(spd);
                    a.setSpeed(spd);
                    Navigator.pop(context);
                  } else {
                    Get.showSnackbar(
                      const GetSnackBar(
                        message: 'неверный параметр размера.',
                        duration: Duration(milliseconds: 800),
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: const Text(
                  'сохранить',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget butn(int v) {
    return ElevatedButton(
      // style: ButtonStyle(backgroundColor: const Color.fromARGB(255, 28, 57, 78),),
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 28, 57, 78))),
      onPressed: () {
        setState(() {
          // spd = v;
        });
      },
      child: Text(
        v.toString(),
        style: TextStyle(
          color: spd == v ? Colors.amber : Colors.white,
        ),
      ),
    );
  }
}
