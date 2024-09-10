import 'package:flutter/material.dart';
import 'package:flutter2/pages/articlesListView.dart';
import '../carousel/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import '../data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(//保证页面不受系统状态栏和导航栏覆盖
        child: SingleChildScrollView(//可上下滚动页面
          physics: const BouncingScrollPhysics(),//模拟ios弹性滚动效果
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,//子部件在交叉轴上与主轴的起始位置对齐，对于Column来说，交叉轴是水平轴，而对于Row来说，交叉轴是垂直轴。
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '你好',
                      style: themeData.textTheme.displayLarge,
                    ),
                    Image.asset(
                      'assets/img/icons/notification.png',
                      width: 32,
                      height: 32,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 0, 0, 16),
                child: Text(
                  '开始探索吧！',
                  style: themeData.textTheme.headlineLarge,
                ),
              ),
              const _CategoryList(),//分类栏
              const PostList(),
              const SizedBox(
                height: 85,
              ),
            ]
          )
      )),
    );
  }
}

class _CategoryList extends StatelessWidget {//分类列表视图
  const _CategoryList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = AppData.categories;
    if(kIsWeb){//web端轮播图
      return CarouselSlider.builder(
        itemCount: categories.length,
        itemBuilder: (context, index, realIndex) {
          return _Category(
            category: categories[index],//使用index虚拟索引，防止轮播超出范围
            left: index == 0 ? 32 : 8,
            right: index == categories.length - 1 ? 32 : 8,
          );
        },
        options: CarouselOptions(
              height: 200.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16/9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
          ),//表示根据高度放大中心页面
      );
    }else {//移动端轮播图
      return CarouselSlider.builder(
        itemCount: categories.length,
        itemBuilder: (context, index, realIndex) {
          return _Category(
            category: categories[realIndex],
            left: realIndex == 0 ? 32 : 8,
            right: realIndex == categories.length - 1 ? 32 : 8,
          );
        },
        options: CarouselOptions(
            aspectRatio: 1.2,//定义轮播中每个项目的宽高比
            scrollDirection: Axis.horizontal,//指定轮播滚动的方向
            viewportFraction: 0.8,//视口占轮播容器宽度的比例
            initialPage: 0,
            scrollPhysics: const BouncingScrollPhysics(),//定义轮播的滚动物理效果
            disableCenter: true,//指示是否禁用轮播项居中对齐
            enableInfiniteScroll: false,//指示是否启用无限循环滚动
            enlargeCenterPage: true,//指示是否放大中心页面
            enlargeStrategy: CenterPageEnlargeStrategy.height),//表示根据高度放大中心页面
      );
    }
    
  }
}

class _Category extends StatelessWidget {//分类项显示
  const _Category(
      {Key? key,
      required this.right,
      required this.left,
      required this.category})
      : super(key: key);

  final double right;
  final double left;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(left, 0, right, 0),
      child: Stack(
        children: [
          // 第一个子部件，用于显示阴影
          Positioned.fill(
            top: 100,
            right: 65,
            bottom: 24,
            left: 65,
            child: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(blurRadius: 20, color: Color(0xaa0D253C)),
              ]),
            ),
          ),
          // 第二个子部件，用于显示图像和渐变
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Color(0xff0D253C),
                    Colors.transparent,
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'assets/img/posts/large/${category.imageFileName}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 第三个子部件，用于显示标题
          Positioned(
            left: 32,
            bottom: 48,
            child: Text(
              category.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class PostList extends StatelessWidget {//最近文章视图
  const PostList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '最近文章',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              TextButton(//更多按钮
                onPressed: () {
                  Navigator.pushNamed(context,'/allArticles',arguments:'/article/latestArticles');
                },
                child: const Text(
                  '更多',
                  style: TextStyle(color: Color(0xFF376AED)),
                ),
              )
            ],
          ),
        ),
        ArticleListView(pageSize: 3,isStaticPage: true ,url: '/article/latestArticles',)
      ],
    );
  }
}