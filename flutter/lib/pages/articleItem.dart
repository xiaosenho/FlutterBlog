import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter2/component/timeAgo.dart';
import 'package:flutter2/data.dart';
import 'package:flutter2/request/net.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ArticleItem extends StatefulWidget{//文章项
  //构造函数，required表示必须传入参数
  ArticleItem({Key? key,required this.withShadow,required this.isLoading,required this.article}) : super(key: key);

  final bool withShadow;
  final bool isLoading;
  final Article article;
  
  @override
  State<StatefulWidget> createState() {
    return _ArticleItemState();
  }
  
}

class _ArticleItemState extends State<ArticleItem>{
  String coverImg = '';

  @override
  void initState() {
    super.initState();
    // 检查缓存中是否存在图片数据
    if(mounted) {
      loadCachedImage();
    }
  }

  Future<void> loadCachedImage() async {
    // 检查缓存中是否已存在图片数据
    FileInfo? fileInfo = await DefaultCacheManager().getFileFromCache(
      'data:image/jpeg;base64,${widget.article.articleID.hashCode}', // 缓存文件的键
    );

    if (fileInfo == null) {
      // 如果缓存中不存在图片数据，重新缓存图片数据
      getCoverImg();
    }else{
      // 如果缓存中存在图片数据，则直接使用缓存中的图片数据
      Uint8List imageByteData = await fileInfo.file.readAsBytes();
      if(mounted){
        setState(() {
          coverImg = base64Encode(imageByteData);
        });
      }
    }
  }

  void getCoverImg () async{//获取封面请求
    if(widget.article.cover==null){
      // ByteData imageByteData = await rootBundle.load('assets/img/posts/small/small_post_3.jpg');
      // List<int> bytes = imageByteData.buffer.asUint8List();
      // setState(() {
      //   coverImg=base64Encode(bytes);
      // });
      return;
    }
    Net net = Net.instance!;
    var params={
      "filepath": widget.article.cover,
    };
    // 发送GET请求
    net.get("/auth/files",params,success: (result) {
      if(result.isNotEmpty){
        if(result['code']==200){//获取封面
          if(mounted){
            setState(() {
              coverImg = result['data'];
              // 将图片数据缓存到设备的磁盘中
              DefaultCacheManager().putFile(
                'data:image/jpeg;base64,${widget.article.articleID.hashCode}', // 缓存文件的键
                base64Decode(coverImg), // 图片数据
              );
            });
          }
        }else{//无封面信息
          
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(//提供点击效果和触摸反馈
        onTap: () {
          Navigator.pushNamed(context, '/article',arguments: widget.article);
        },
        child: Container(
          height: 150,
          margin: const EdgeInsets.fromLTRB(32, 8, 32, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              widget.withShadow == false
                  ? const BoxShadow(
                      blurRadius: 10,
                      color: Color(0x1a5282FF),
                    )
                  : BoxShadow(
                      blurRadius: 5,
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    )
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child:  coverImg.isEmpty?Image.asset('assets/img/posts/small/small_post_3.jpg',
                        height: 150, // 设置图片宽度

                        fit: BoxFit.fitWidth,
                  ):
                      Image.memory(
                        base64Decode(coverImg),
                        height: 150, // 设置图片宽度
                        width: 125,
                        fit: BoxFit.cover,
                      )
                
                      
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(//标题
                        widget.article.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF376AED),
                        ),
                        maxLines: 2, // 设置最大行数
                        overflow: TextOverflow.ellipsis, // 设置溢出文本显示省略号
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(//副标题
                        widget.article.subtitle,
                        style: Theme.of(context).textTheme.displayMedium,
                        maxLines: 2, // 设置最大行数
                        overflow: TextOverflow.ellipsis, // 设置溢出文本显示省略号
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            CupertinoIcons.hand_thumbsup,
                            size: 16,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(//点赞数
                            widget.article.likes.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Icon(
                            CupertinoIcons.clock,
                            size: 16,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          TimeAgoText(dateTime: widget.article.createdAt),//上传时间
                          Expanded(//收藏标签
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                 CupertinoIcons.bookmark,
                                size: 16,
                                color:
                                    Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }
}