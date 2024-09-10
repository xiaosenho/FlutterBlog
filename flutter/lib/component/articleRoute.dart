import 'package:flutter/material.dart';
import 'package:flutter2/pages/articlesListView.dart';

class Articleroute extends StatelessWidget{
  const Articleroute({super.key});
  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('相关文章'),
      ),
      body:  ArticleListView(key: UniqueKey(), pageSize: 10, isStaticPage: false, url: url),
      );
  }
}