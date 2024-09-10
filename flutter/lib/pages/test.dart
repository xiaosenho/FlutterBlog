import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';




class BlogEditor extends StatefulWidget {
  @override
  _BlogEditorState createState() => _BlogEditorState();
}

class _BlogEditorState extends State
 {
  
  List<dynamic> _content = [];

  void _insertText(String text) {
    setState(() {
      _content.add(text);
    });
  }

  void _insertImage(File image) {
    setState(() {
      _content.add(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Editor'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var item in _content)
                      if (item is String)
                        Text(item)
                      else if (item is File)
                        Image.file(item),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // 插入文本
                  _insertText('Your text here');
                },
                child: Text('Insert Text'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // 选择图片
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    _insertImage(File(pickedFile.path));
                  }
                },
                child: Text('Insert Image'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

