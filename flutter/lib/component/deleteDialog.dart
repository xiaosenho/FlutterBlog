import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('确认删除'),
      content: Text('是否要删除该项目？'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // 返回false表示用户取消删除操作
          },
          child: Text('取消'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // 返回true表示用户确认删除操作
          },
          child: Text('确认'),
        ),
      ],
    );
  }
}