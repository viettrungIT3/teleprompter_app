import 'package:flutter/material.dart';

import '../services/teleprompter_service.dart';
import 'teleprompter_screen.dart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();
  final TeleprompterService teleprompterService = TeleprompterService();
  @override
  void initState() {
    super.initState();
    textEditingController.text = teleprompterService.getDefaultText().content;
    textEditingController.selection =
        const TextSelection(baseOffset: 0, extentOffset: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home page'),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Text for teleprompter",
            ),
            scrollPadding: const EdgeInsets.all(20.0),
            keyboardType: TextInputType.multiline,
            maxLines: 99999,
            autofocus: true,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.play_arrow),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TeleprompterScreen(
                text: textEditingController.text,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
