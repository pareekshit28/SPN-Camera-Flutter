import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class SaveImageScreen extends StatelessWidget {
  final File file;
  SaveImageScreen({Key? key, required this.file}) : super(key: key);

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Save Image"),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.clear,
              size: 25,
            )),
      ),
      body: SingleChildScrollView(
        child: Image.file(
          File(file.path),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            final text = DateTime.now().toString().replaceAll(" ", "_");
            _textController.text = text;
            _textController.selection =
                TextSelection(baseOffset: 0, extentOffset: text.length);
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Rename Image",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _textController,
                              autofocus: true,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                const Spacer(),
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  child: const Text("Cancel"),
                                ),
                                const SizedBox(width: 10),
                                MaterialButton(
                                  onPressed: () async {
                                    final path = file.path;
                                    final lastSeparator = path
                                        .lastIndexOf(Platform.pathSeparator);
                                    final newPath =
                                        path.substring(0, lastSeparator + 1) +
                                            _textController.text +
                                            ".jpg";
                                    final newFile = await file.rename(newPath);
                                    final result = await GallerySaver.saveImage(
                                      newFile.path,
                                      albumName: "Camera",
                                      toDcim: true,
                                    );
                                    if (result != null && result) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Image saved succesfully!")));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Something went wrong")));
                                    }
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  child: const Text("Save"),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ));
          },
          icon: const Icon(Icons.save),
          label: const Text("Save")),
    );
  }
}
