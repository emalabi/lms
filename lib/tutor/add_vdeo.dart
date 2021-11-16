import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AddVideo extends StatefulWidget {
  final String courseId;

  const AddVideo({Key key, this.courseId}) : super(key: key);

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  UploadTask task;
  File file;
  bool uploading = false;

  double val = 0;
  CollectionReference imgRef = FirebaseFirestore.instance.collection('courses');
  Reference ref;

  List<File> _files = [];
  List<String> name = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Video'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _files.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: TextButton.icon(
                                icon: Icon(Icons.add),
                                label: Text('Add Video'),
                                onPressed: () =>
                                    !uploading ? selectFile() : null),
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(_files[index - 1]),
                                  fit: BoxFit.cover),
                            ),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      uploading = true;
                    });
                    uploadFile()
                        .whenComplete(() => Navigator.of(context).pop());
                  },
                  icon: Icon(Icons.upload),
                  label: Text('Upload'),
                ),
              ),
            )
          ],
        ));
  }

  Future selectFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.video,
    );
    if (result != null) {
      result.files.forEach((selectedFile) {
        File file = File(selectedFile.path);
        setState(() {
          _files.add(file);
        });
      });
    }
  }

  Future uploadFile() async {
    int i = 1;
    for (var file in _files) {
      setState(() {
        val = i / _files.length;
      });
      ref =
          FirebaseStorage.instance.ref().child('videos/${basename(file.path)}');
      await ref.putFile(file).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef
              .doc(widget.courseId)
              .collection('Videos')
              .add({'url': value, 'name': basename(file.path)});
          i++;
        });
      });
    }
  }
}
