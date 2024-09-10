import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter2/pages/articlesListView.dart';
import 'package:flutter2/request/net.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 已登录页面
// ignore: must_be_immutable
class LoggedInPage extends StatelessWidget {
  //使用 GlobalKey 获取 Scaffold 实例
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LoggedInPage({super.key,required this.user,required this.callback,required this.avatarImg});
  final String avatarImg;
  final Map<String,dynamic> user;
  Function callback;//父页面回调函数更新登录状态

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      key: _scaffoldKey,//配置key
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface.withOpacity(0),//不透明度设置为0
        titleTextStyle: themeData.textTheme.headlineLarge,
        title: const Text('个人资料'),
        actions: [
          IconButton(//更多设置按钮
            onPressed: () {
              // 打开侧边栏
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(Icons.more_horiz_rounded),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      endDrawer: proflieDrawer(user: user,callback: callback,avatarImg: avatarImg),
      body: Stack(
        children: [
          //使用NestedScrollView嵌套滚动组件来包装ListView，保证子组件的滑动监听器生效
          NestedScrollView(
            headerSliverBuilder: (BuildContext context,bool innerBoxIsScrolled){
              return [
                SliverToBoxAdapter(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(32, 8, 32, 64),
                            decoration: BoxDecoration(
                              color: themeData.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color:
                                      themeData.colorScheme.primary.withOpacity(0.1),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 84,
                                        height: 84,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(24),
                                          gradient: const LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            colors: [
                                              Color(0xFF376AED),
                                              Color(0xFF49B0E2),
                                              Color(0xFF9CECFB),
                                            ],
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(2),
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: themeData.colorScheme.surface,
                                            borderRadius: BorderRadius.circular(22),
                                          ),
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child:avatarImg.isEmpty?const Text('头像'):
                                                  Image.memory(
                                                    base64Decode(avatarImg),//用户头像图片
                                                    fit: BoxFit.cover,
                                                  ),
                                          )
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user['email'],
                                                style: themeData.textTheme.bodyMedium
                                                    ?.copyWith(
                                                        color: themeData
                                                            .colorScheme.onSecondary,
                                                        fontWeight: FontWeight.w400),
                                                ),
                                              const SizedBox(
                                                height: 6,
                                              ),
                                              Text(
                                                user['username'],
                                                style: themeData.textTheme.displayLarge
                                                    ?.copyWith(
                                                        fontWeight: FontWeight.w800,
                                                        color: themeData
                                                            .colorScheme.onSurface),
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                              Text(
                                                user['profession'],
                                                style: themeData.textTheme.displayLarge
                                                    ?.copyWith(
                                                        color: themeData
                                                            .colorScheme.primary,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500),
                                              ),
                                            ]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    'About me',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: themeData.colorScheme.onSurface),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    user['intro']??"还未添加信息",
                                    style: TextStyle(
                                        color: themeData.colorScheme.onSecondary,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 32,
                              right: 96,
                              left: 96,
                              child: Container(
                                height: 32,
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    blurRadius: 30,
                                    color: themeData.colorScheme.onBackground
                                        .withOpacity(0.8),
                                  )
                                ]),
                              )),
                          Positioned(
                            bottom: 32,
                            left: 64,
                            right: 64,
                            child: Container(
                              height: 68,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromARGB(255, 112, 148, 240),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF2151CD),
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '52',
                                            style: themeData.textTheme.headlineMedium!
                                                .apply(
                                                    color: themeData
                                                        .colorScheme.onPrimary),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Post',
                                            style: themeData.textTheme.displayLarge!
                                                .copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    color: themeData
                                                        .colorScheme.onPrimary),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '250',
                                          style: themeData.textTheme.headlineMedium!
                                                .apply(
                                                    color: themeData
                                                        .colorScheme.onPrimary),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'Following',
                                          style: themeData.textTheme.displayLarge!
                                                .copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    color: themeData
                                                        .colorScheme.onPrimary),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '4.5K',
                                          style: themeData.textTheme.headlineMedium!
                                                .apply(
                                                    color: themeData
                                                        .colorScheme.onPrimary),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'Followers',
                                          style: themeData.textTheme.displayLarge!
                                                .copyWith(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    color: themeData
                                                        .colorScheme.onPrimary),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: themeData.colorScheme.surface,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                              bottomLeft: Radius.circular(28),
                              bottomRight: Radius.circular(28),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      themeData.colorScheme.primary.withOpacity(0.1),
                                  blurRadius: 20)
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 32,
                                right: 16,
                                top: 16,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '我的文章',
                                      style: themeData.textTheme.headlineMedium,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context,'/allArticles',arguments: '/article/userArticles');
                                    },
                                    icon: Text(
                                      '更多',
                                      style: TextStyle(color: Color(0xFF376AED)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ];
            }, 
            body: ArticleListView(
                pageSize: 3,
                isStaticPage: true,
                url: '/article/userArticles',
            ),
          ),
          
        ],
      ),
    );
  }
}

class proflieDrawer extends StatelessWidget {//侧边栏
  final Map<String,dynamic> user;
  final String avatarImg;
  const proflieDrawer({
    super.key,required this.callback,required this.user,required this.avatarImg});
  final Function callback;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context); 
    return Drawer(//侧边栏
          child: ListView(//列表显示
            padding: EdgeInsets.all(0),//内边距设为0
            children:  [
              UserAccountsDrawerHeader(//账号信息
                accountEmail: Text(user['email'],
                  style: themeData.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: themeData
                                                      .colorScheme.onSecondary,
                                                  fontWeight: FontWeight.w400),
                ) ,
                accountName: Text(user['username'],
                  style: themeData.textTheme.displayLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w800,
                                                  color: themeData
                                                      .colorScheme.onSurface),
                ),
                currentAccountPicture: Container(//头像
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomLeft,
                        colors: [
                          Color(0xFF376AED),
                          Color(0xFF49B0E2),
                          Color(0xFF9CECFB),
                        ],
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.surface,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child:
                              avatarImg.isEmpty?const Text('头像'):
                                            Image.memory(
                                              base64Decode(avatarImg),//用户头像图片
                                              fit: BoxFit.cover,
                                            )
                      ),
                    ),
                  ),
                decoration: const BoxDecoration(//装饰器，美化控件
                  image: DecorationImage(
                    fit: BoxFit.cover,//图片适应
                    image: AssetImage('assets/img/posts/small/small_post_1.jpg')
                  )
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("设置",
                  style: themeData.textTheme.headlineSmall,
                ),
              ),
              ListTile(
                onTap: () => Navigator.pushNamed(context,'/allArticles',arguments:'/article/collectArticles'),
                leading: Icon(Icons.collections),
                title: Text("收藏",
                  style: themeData.textTheme.headlineSmall,
                ),
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text("回收站",
                  style: themeData.textTheme.headlineSmall,
                ),
              ),
              ListTile(
                onTap: (){
                  logout();
                  Navigator.pop(context);
                },
                leading: Icon(Icons.logout),
                title: Text("注销",
                style: themeData.textTheme.headlineSmall,),
              )
            ],
          )
    );
  }
  //注销账号
  logout(){
    Net net = Net.instance!;
    net.post("/users/logout", {} , success: (result) {
      if(result.isNotEmpty){
        removeToken();
        Fluttertoast.showToast(msg: "注销成功");
        callback();
      }
    });
  }
  Future<void> removeToken() async {
    // 删除本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}

// 未登录页面
class NotLoggedInPage extends StatelessWidget {
  const NotLoggedInPage({super.key,required this.callback});
  final Function callback;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('请登录后继续操作'),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login',arguments: callback);
            }, // 跳转到登录页面
            child: Text('点击登录'),
          ),
        ],
      ),
    );
  }
}