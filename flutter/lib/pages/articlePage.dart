import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/component/timeAgo.dart';
import 'package:flutter2/data.dart';
import 'package:flutter2/request/net.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../gen/assets.gen.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  String htmlText='';
  bool isLoaded=false;//html页面已加载标签
  late Map<String,dynamic> author;//用户信息实例
  bool _getAuthorInfo=false;//是否获取作者信息
  bool _getUserInfo=false;//是否获取用户信息
  bool _isMarked=false;
  bool _isLiked=false;
  String _avatarImg = '';//作者头像

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(!_getUserInfo){
      loadUserInfo(); 
    }
    if(!_getAuthorInfo){
      loadAuthorInfo();
    }
  }
  //获取作者信息
  void loadAuthorInfo()async{
    if(_getAuthorInfo){
      return;
    }
    Net net = Net.instance!;
    final Article article = ModalRoute.of(context)!.settings.arguments as Article;
    var params={
      "id":article.id
    };
    net.get("/users/getAuthor", params,success: (result){
      if(result.isNotEmpty){
        if(result['code']==200){
          setState(() {
            author=result['data'];
            _getAuthorInfo=true;
            if(author['avatar']!=null) {
              getAvatarImg(author['avatar']);
            }
          });
        }
      }
    });
  }
  //获取用户点赞收藏信息
  void loadUserInfo()async{
    Net net = Net.instance!;
    final Article article = ModalRoute.of(context)!.settings.arguments as Article;
    var params={
      "articleId":article.articleID
    };
    net.get("/users/getLikeAndCol", params,success: (result){
      if(result.isNotEmpty){
        if(result['code']==200){
          Map<String,dynamic> data=result['data'];
          setState(() {
            _getUserInfo=true;
            _isMarked=data['isCollected'];
            _isLiked=data['isLiked'];
          });
        }
      }
    });
  }
  //获取头像图片
  void getAvatarImg(String filePath) async {
    Net net = Net.instance!;
    var params={
      "filepath":filePath,
    };
    // 发送GET请求
    net.get("/auth/files",params,success: (result) {
      if(result.isNotEmpty){
        if(result['code']==200){//获取头像
         if(mounted) {
           setState(() {
            _avatarImg = result['data'];
          });
         }
        }else{//无头像信息
          
        }
      }
    });
  }
  //获取正文内容
  void loadHtml(Article article) async{
    Net net = Net.instance!;
    var params={
      "filepath":article.content
    };
    net.get("/auth/files", params,success: (result){
      if(result.isNotEmpty){
        if(result['code']==200){
          if(mounted) {
            setState(() {
            htmlText=utf8.decode(base64Decode(result['data']));
            isLoaded=true;
          });
          }
        }
      }
    });
  }
  //点赞或取消点赞
  void changeLike(Article article) async{
    Net net = Net.instance!;
    var params={
      "articleId":article.articleID,
    };
    net.get("/likes/changeLike", params,success: (result){
      if(result.isNotEmpty){
        if(result['code']==200){
          showSnackBar(context, '点赞成功');
          if(mounted){
            setState(() {
            article.likes++;
            _isLiked=true;
          });
          }
        }
        else if(result['code']==204){
          showSnackBar(context, '取消点赞');
          if(mounted){
            setState(() {
            article.likes--;
            _isLiked=false;
          });
          }
        }
      }
    });
  }
  void changeCollect(Article article) async{
    Net net = Net.instance!;
    var params={
      "articleId":article.articleID,
    };
    net.get("/collects/changeCollect", params,success: (result){
      if(result.isNotEmpty){
        if(result['code']==200){
          showSnackBar(context, '收藏成功');
          if(mounted){
            setState(() {
            _isMarked=true;
          });
          }
        }
        else if(result['code']==204){
          showSnackBar(context, '取消收藏');
          if(mounted){
            setState(() {
            _isMarked=false;
          });
          }
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Article article = ModalRoute.of(context)!.settings.arguments as Article;
    if(!isLoaded) {
      loadHtml(article);
    }
    return Scaffold(
        floatingActionButton: InkWell(//点赞按钮
          onTap: () {
            changeLike(article);
          },
          child: Container(
            width: 111,
            height: 48,
            decoration: BoxDecoration(
              color: themeData.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    blurRadius: 20,
                    color: themeData.colorScheme.primary.withOpacity(0.5))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isLiked? CupertinoIcons.hand_thumbsup_fill:CupertinoIcons.hand_thumbsup,
                  color: themeData.colorScheme.onPrimary,),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  article.likes.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'avenir',
                    fontWeight: FontWeight.w400,
                    color: themeData.colorScheme.onPrimary,
                  ),
                )
              ],
            ),
          ),
        ),
        backgroundColor: themeData.colorScheme.surface,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  // pinned: true,
                  // floating: true,
                  title: Text(
                    '文章',
                    style: themeData.textTheme.headlineSmall,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        showSnackBar(context, 'on More is Clicked');
                      },
                      icon: const Icon(Icons.more_horiz_rounded),
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ],
                ),
                SliverList(
                    delegate: SliverChildListDelegate.fixed([
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                        child: Text(
                          article.title,
                          style: themeData.textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 16, 32),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _avatarImg.isEmpty?const SizedBox(
                                    width: 48,
                                    height: 48,
                                  ):
                                  Image.memory(
                                    height: 48, width: 48,
                                    base64Decode(_avatarImg),//作者头像图片
                                    fit: BoxFit.cover,
                                ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(//作者信息
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getAuthorInfo?author['username']:'无名称',
                                    style: themeData.textTheme.displayLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: themeData
                                                .colorScheme.onSecondary),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  TimeAgoText(dateTime: article.createdAt),
                                ],
                              ),
                            ),
                            IconButton(//分享
                              icon: Icon(
                                CupertinoIcons.share,
                                color: themeData.colorScheme.primary,
                              ),
                              onPressed: () {
                                showSnackBar(context, 'on Share is Clicked');
                              },
                            ),
                            IconButton(//收藏
                              icon: Icon(
                                _isMarked? CupertinoIcons.bookmark_fill:CupertinoIcons.bookmark,
                                color: themeData.colorScheme.primary,
                              ),
                              onPressed: () {
                                changeCollect(article);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width, // 获取屏幕宽度
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(32),
                            topLeft: Radius.circular(32),
                          ),
                          child: Assets.img.background.onboarding.image(
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
                        child: Text(
                          article.subtitle,
                          style: themeData.textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 32, 66),
                        child: 
                        HtmlWidget(//Html渲染
                          htmlText,
                          customStylesBuilder: (element) {
                            if (element.classes.contains('foo')) {
                              return {'color': 'red'};
                            }

                            return null;
                          },
                          // HTML渲染方式
                          // by default, a simple `Column` is rendered
                          // consider using `ListView` or `SliverList` for better performance
                          renderMode: RenderMode.column,
                          // 默认文本字体
                          textStyle: themeData.textTheme.bodyLarge,
                        ),
                                               
                      ),
                    ],
                  ),
                ]))
              ],
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        themeData.colorScheme.surface,
                        themeData.colorScheme.surface.withOpacity(0)
                      ],
                    ),
                  ),
                ))
          ],
        ));
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(message),
          duration: Duration(seconds: 2), // 设置持续时间为2秒
          behavior: SnackBarBehavior.floating, // 设置为浮动在屏幕上方
        ));
  }
  @override
  void dispose() {
    super.dispose();
  }
}