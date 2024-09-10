import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30), // 圆角半径
      child: Image(
      image: AssetImage('assets/img/background/404.jpg'),
      fit: BoxFit.cover,
      )
    );
  }
}