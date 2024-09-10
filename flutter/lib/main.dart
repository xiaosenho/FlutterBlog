import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter2/pages/chat.dart';
import 'package:flutter2/pages/new_article.dart';
import 'package:flutter2/pages/search.dart';
import './pages/home.dart';
import './pages/profile.dart';
import 'router.dart';

void main() {//入口函数
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {//主app无状态控件
  static const String defaultFontFamily = 'Avenir';//默认字体

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryTextColor = Color(0xFF0D253C);
    const Color secondaryTextColor = Color(0xFF2D4379);

    return MaterialApp(//入口类,配置应用基本信息
      title: "Blog",//任务栏应用名
      debugShowCheckedModeBanner: false,//消除debug图标
      theme: ThemeData(//主题色
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
            primary: Color(0xFF0D253C),
            surface: Colors.white,
            onSurface: Color(0xFF0D253C),
            onSecondary: Color(0xFF2D4379),
            secondaryContainer: Color.fromARGB(255, 93, 129, 219),
            onPrimary: Colors.white
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontFamily: defaultFontFamily,
            fontWeight: FontWeight.w700,
            color: primaryTextColor,
            fontSize: 16
          ),
          headlineMedium: TextStyle(
            fontFamily: defaultFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: primaryTextColor,
          ),
          headlineLarge: TextStyle(
            fontFamily: defaultFontFamily,
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: primaryTextColor,
          ),
          titleMedium: TextStyle(

          ),
          bodyLarge: TextStyle(
            fontFamily: defaultFontFamily,
            fontWeight: FontWeight.w400,
            color: primaryTextColor,
            fontSize: 14,
          ),
          bodyMedium: TextStyle(
            fontFamily: defaultFontFamily,
            color: secondaryTextColor,
            fontSize: 12,
          ),
          bodySmall: TextStyle(

          ),
          labelLarge: TextStyle(

          ),
          labelMedium: TextStyle(

          ),
          labelSmall: TextStyle(

          ),
          displayLarge: TextStyle(
            fontFamily: defaultFontFamily,
            color: secondaryTextColor,
            fontWeight: FontWeight.w300,
            fontSize: 18,
          ),
          displayMedium: TextStyle(
            fontFamily: defaultFontFamily,
            color: primaryTextColor,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          displaySmall: TextStyle(

          ),
          
        )
      ),
      routes: globalRoutes,
      home: DefaultTabController(
        length: 5,
        child: MyHomePage(),
      ),
    );//主页面
  }
}


class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //底部导航栏需要绑定DefaultTabController，length决定可操控的tab数量
    return Scaffold(//页面结构脚手架，包含导航栏，内容区，抽屉等
        // appBar: AppBar(//导航栏
        //   title: const Text(""),
        //   centerTitle: true,
        //   actions: [
        //     IconButton(onPressed: (){}, icon: const Icon(Icons.search))
        //   ],
          
        // ),

        body: TabBarView(//内容区,根据不同tab切换页面
          physics: const NeverScrollableScrollPhysics(),//内容区,根据不同tab切换页面
          children: [
            HomePage(),
            SearchPage(),
            const NewArticlePage(),
            ChatPage(),
            const ProfilePage(),
          ],
        ),
        
          
        bottomNavigationBar: Container(//底部导航栏
          decoration: BoxDecoration(//添加阴影
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          height: 60,
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                
              ),
              Tab(
                icon: Icon(Icons.subscriptions),
                
              ),
              Tab(
                icon: Icon(Icons.add_circle_rounded,),
              ),
              Tab(
                icon: Icon(Icons.notifications),
                
              ),
              Tab(
                icon: Icon(Icons.person),
                
              ),
            ]
          ),
        ),
      //   floatingActionButton: Container(
      //     decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       border: Border.all(color: Colors.white, width: 2.0), // 添加白色边框
      //     ),
      //     margin: EdgeInsets.only(top: 20.0), // 将按钮下移
      //     child: ClipOval( // 使用 ClipOval 包裹 FloatingActionButton
      //       child:FloatingActionButton(

      //       onPressed: () {
      //         // 获取 TabController
      //         final TabController? tabController = DefaultTabController.of(context);
      //         if (tabController != null) {
      //           // 切换到第三个选项卡
      //           tabController.animateTo(2);
      //         }
      //       },
      //       tooltip: 'Add',
      //       child: Icon(Icons.add),
      //       )
      //     ),
      // ),
      //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}