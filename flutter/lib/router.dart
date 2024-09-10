import 'package:flutter/material.dart';
import 'package:flutter2/component/articleRoute.dart';
import 'package:flutter2/pages/register.dart';
import 'package:flutter2/pages/test.dart';
import 'main.dart';
import './pages/home.dart';
import './pages/profile.dart';
import './pages/login.dart';
import 'pages/articlePage.dart';
import 'pages/new_article.dart';

// 定义全局路由表
final Map<String, WidgetBuilder> globalRoutes = {
  '/myHome': (context) => MyHomePage(),
  '/home': (context) => HomePage(),
  '/profile': (context) => ProfilePage(),
  '/login':(context) => LoginPage(),
  '/article':(context) => ArticlePage(),
  '/newArticle':(context) => NewArticlePage(),
  '/register':(context)=> RegisterPage(),
  '/test':(context)=> BlogEditor(),
  '/allArticles':(context)=> Articleroute(),
  // 添加其他路由...
};