import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/component/deleteDialog.dart';
import 'package:flutter2/data.dart';
import 'package:flutter2/pages/404.dart';
import 'package:flutter2/pages/articleItem.dart';
import 'package:flutter2/request/net.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ArticleListView extends StatefulWidget{
  
  final int pageSize;
  final bool isStaticPage;//静态页面标识
  final String url;
  ArticleListView({Key? key, required this.pageSize,required this.isStaticPage,required this.url}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ArticleListState();
  }
}

class _ArticleListState extends State<ArticleListView>{
  bool _isLoading = false;
  List<Article> articles = [];
  int pageNumber = 1;
  int total=0;
  bool _hasMore = true;
  bool _connected=false;
  bool _isDelete=false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }
  @override
  void dispose() {
    super.dispose();
  }

  void _loadData() async{//数据加载
    if(!_hasMore){
      if(mounted) {
        setState(() {
        //停止加载
        _isLoading = false;
        // 显示没有更多数据
      });
      }
      return;
    }
    Net net=Net.instance!;
    var params={
      'pageNum':pageNumber,
      'pageSize':widget.pageSize
    };
    await net.get(widget.url,params,success: (result){
      if(result.isNotEmpty){
        Map data = json.decode(result['data']);
        // 从 JSON 数据中提取 records 字段的值
        List<dynamic> records = data['records'];
        List<Article> articles = [];
        for (var record in records) {
          Article article = Article.fromJson(record);
          articles.add(article);
        }
        if(mounted) {
          setState(() {// 更新数据
          total=data['total'];
          this.articles.addAll(articles);
          _connected=true;
          //停止加载
          _isLoading = false;
          if(pageNumber*widget.pageSize>total){//所有数据已经加载判断
            _hasMore=false;
          }else{
            pageNumber++;
          }   
        });
        }
      }
    });
  }
  void _deleteArticle(Article article)async{
    Net net=Net.instance!;
    var params={
      'articleId':article.articleID
    };
    await net.get('/article/deleteArticle',params,success: (result){
      if(result.isNotEmpty){
        if(result['code']==200){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('已删除'),
              duration: Duration(seconds: 2), // 设置持续时间为2秒
              behavior: SnackBarBehavior.floating, // 设置为浮动在屏幕上方
            ),
          );
        }
      }
    });
  }
  // 判断是否滚动到列表底部
  bool _isScrollEnd(ScrollNotification notification) {
    return notification.metrics.extentAfter == 0;
  }

  // 监听滚动事件
  void _handleScrollEnd(ScrollNotification notification) {
    if(widget.isStaticPage){//如果是静态页面则不加载
      return;
    }
    if (_isScrollEnd(notification)) {
      // 滚动到底部，加载更多数据
      if(!_hasMore)return;//如果无更多数据则停止加载数据
      if (!_isLoading) {
        if(mounted) {
          setState(() {
          _isLoading = true;
        });
        }
        _loadData();
      }
    }
  }


  // 模拟刷新操作
  Future<void> _handleRefresh() async {
    setState(() {//重置所有数据重新加载
      _isLoading = false;
      articles = [];
      pageNumber = 1;
      total=0;
      _hasMore = true;
      _connected=false;
    });
    _loadData();
  }
  @override
  Widget build(BuildContext context) {
    return _connected?NotificationListener<ScrollNotification>(//注册监听器
      // 判断是否滚动到列表底部
      onNotification: (notification) {
        _handleScrollEnd(notification);
        return true;
      },
      child:RefreshIndicator(
        onRefresh: _handleRefresh,
        child:ListView.builder(
        itemExtent: 141,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.isStaticPage? articles.length:articles.length+1,//多一个空容器，用于显示加载动画
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          if(index<articles.length){//直接渲染
            final Article article=articles[index];
            return Dismissible(//右划删除
            key: Key(article.articleID.toString()), 
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            dismissThresholds: {DismissDirection.endToStart: 0.5} ,
            confirmDismiss: (direction) => showDialog(
              context: context,
              builder: (BuildContext context) {
                return DeleteConfirmationDialog();
            }),
            onDismissed: (direction) {
              if(widget.url=='/article/userArticles'){//用户文章右滑删除
                setState(() {
                  articles.removeAt(index);
                });
                _deleteArticle(article);
              }else if(widget.url=='/article/collectArticles'){//收藏文章删除
                setState(() {
                  articles.removeAt(index);
                });
              }else{//推送文章隐藏
                setState(() {
                  articles.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('已隐藏'),
                  duration: Duration(seconds: 2), // 设置持续时间为2秒
                  behavior: SnackBarBehavior.floating, // 设置为浮动在屏幕上方
                ),
              );
              }
            },
            child:ArticleItem(withShadow: false,isLoading: _isLoading,article: article,)
            );
          }else {//最后一个容器进行判断
              // 渲染加载动画
              if (_isLoading) {
                return const Center(
                  child: SpinKitCubeGrid(
                  color: Colors.blue,
                  size: 50.0,
                  ),
                );
              } else {
                // 如果不是正在加载，则返回一个空的容器
                return Container();
              }
          }
        }),
    ))
    : NotFoundPage();
  }
}


