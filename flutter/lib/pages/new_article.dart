import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../request/net.dart';

class NewArticlePage extends StatefulWidget {
  const NewArticlePage({Key? key}) : super(key: key);

  @override
  State<NewArticlePage> createState() => _NewArticlePageState();
}

class _NewArticlePageState extends State<NewArticlePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  
  late QuillEditorController controller;//富文本编辑器
  // 创建一个焦点节点
  final FocusNode _editorFocusNode = FocusNode();

  final customToolBarList = [//工具栏显示工具
    ToolBarStyle.undo,
    ToolBarStyle.redo,
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.headerOne,
    ToolBarStyle.headerTwo,
    ToolBarStyle.blockQuote,
    ToolBarStyle.codeBlock,
    ToolBarStyle.link,
    ToolBarStyle.clean,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.image,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];
  final _backgroundColor = Colors.white70;//编辑区域背景颜色
  final _editorTextStyle = const TextStyle(//文本格式
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.normal,
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);
  bool _hasFocus = false;

  final TextEditingController _titleController = TextEditingController(
    text: '',
  );
  final TextEditingController _subTitleController =TextEditingController(
    text: '');
  // 头像图片文件
  late File _imageFile;
  String _selectedCategory = "科技";
  bool _isImageSelected = false; // 添加一个标志来指示是否已经选择了图片

  @override
  void initState() {
    controller = QuillEditorController();
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();//关闭编辑器
    super.dispose();
  }

// 打开相册或者拍照选择图片
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _isImageSelected = true; // 设置标志为 true
      });
    }
  }

  // 处理封面上传
  void _handleCoverUpload() async {
    // 打开相册或者拍照选择图片
    await _pickImage(ImageSource.gallery); // 可以选择 ImageSource.camera 打开相机
    if (_isImageSelected) {
      // 保存图片访问路径到本地存储
    }
  }
  void checkAndSaveArticle() async{//检查并上传文章
    String? htmlText = await controller.getText();
    if(_titleController.text.isEmpty){
      Fluttertoast.showToast(msg:'请输入标题');
    }else if(_subTitleController.text.isEmpty){
      Fluttertoast.showToast(msg:'请输入简介');
    }else if(htmlText.length<10){
      Fluttertoast.showToast(msg:'请输入内容');
    }else{
      saveArticle(htmlText);
    }
  }

  void saveArticle(String htmlText) async{//保存文章方法
    Net net=Net.instance!;
    // 创建一个空的Uint8List对象
    Uint8List emptyBytes = Uint8List(0);
    // 创建一个MultipartFile对象
    var file = MultipartFile.fromBytes(
      emptyBytes,
      filename: 'empty.png',
    );

    var params = {
      'title': _titleController.text,
      'sub_title': _subTitleController.text,
      'cover': _isImageSelected ? await MultipartFile.fromFile(_imageFile.path, filename: "cover.png") : 
          file,//若未选择封面则返回空文件
      'category': _selectedCategory,
      'content': htmlText,
    };
    net.post('/article/upload', params,success: (result){
      if(result.isNotEmpty){
        Fluttertoast.showToast(msg:'文章上传成功');
        setState(() {//清空内容区
          _titleController.text = '';
          _subTitleController.text = '';
          _isImageSelected=false;
          controller.clear();
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      body: Stack(//堆叠，工具栏显示
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                // pinned: true,
                // floating: true,
                backgroundColor: themeData.colorScheme.surface,
                title: Text(
                  '新建博客',
                  style: themeData.textTheme.headlineSmall,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      checkAndSaveArticle();
                    },
                    icon: SvgPicture.asset('assets/img/icons/download.svg'),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 32,
                        left: 32,
                        top: 36,
                        bottom: 100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(//大标题
                            style: themeData.textTheme.headlineLarge!.copyWith(
                              fontSize: 22,
                            ),
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: '输入标题',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xff7B8BB2).withOpacity(0.26),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: themeData.colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: TextField(//副标题
                              style: themeData.textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: '输入简介',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xff7B8BB2)
                                        .withOpacity(0.26),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeData.colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              controller: _subTitleController,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                           // 封面上传部分
                          GestureDetector(
                            onTap: _handleCoverUpload,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.rectangle,
                                image: _isImageSelected//上传后显示图片
                                  ? DecorationImage(
                                  image: FileImage(_imageFile), // 使用 FileImage 来加载文件图片
                                  fit: BoxFit.cover,
                                  )
                                : null,
                              ),
                              child:  !_isImageSelected ? const Icon(//未选中时显示添加图标
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.white,
                              )
                              : null,
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          DropdownButtonFormField(
                            value: _selectedCategory,
                            items: ['科技', '娱乐', '生活', '旅行','互联网','经济']
                                .map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value.toString();
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: '文章分区',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Wrap(//tag标签添加
                            direction: Axis.horizontal,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            runSpacing: 8,
                            spacing: 8,
                            children: [
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  '添加标签',
                                  style:
                                      themeData.textTheme.displayMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: themeData.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox.shrink(),
                              _chipWidget(themeData, 'Art'),
                              _chipWidget(themeData, 'Design'),
                              _chipWidget(themeData, 'Culture'),
                              _chipWidget(themeData, 'Production'),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          Text(
                            '正文内容',
                            style: themeData.textTheme.displayMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            height: 2.2,
                            margin: const EdgeInsets.only(
                              top: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff7B8BB2).withOpacity(0.26),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          QuillHtmlEditor(
                            hintText: 'Hint text goes here',
                            controller: controller,
                            isEnabled: true,
                            ensureVisible: false,
                            minHeight: 500,
                            autoFocus: false,
                            textStyle: _editorTextStyle,
                            hintTextStyle: _hintTextStyle,
                            hintTextAlign: TextAlign.start,
                            backgroundColor: _backgroundColor,
                            inputAction: InputAction.newline,
                            loadingBuilder: (context) {//载入图标
                              return const Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 5,
                                color: const Color(0xff376AED),
                              ));
                            },
                            onFocusChanged: (focus) {
                              debugPrint('has focus $focus');
                              if(focus){
                                // 点击富文本编辑器时，将焦点从文本栏移开
                                FocusScope.of(context).requestFocus(_editorFocusNode);
                              }
                            },
                            // onTextChanged: (text) => debugPrint('widget text change $text'),
                            onEditorCreated: () {
                              setState(() {
                                _hasFocus = true;
                              });
                            },
                            // onEditorResized: (height) =>
                            //     debugPrint('Editor resized $height'),
                            // onSelectionChanged: (sel) =>
                            //     debugPrint('index ${sel.index}, range ${sel.length}'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          if(_hasFocus)//如果焦点在编辑器中则显示工具栏
            Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 26),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 13,
                      offset: const Offset(0, 13)),
                  ],
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, 
                  child:ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:ConstrainedBox(
                      constraints: BoxConstraints(maxWidth:(customToolBarList.length+1)*40,maxHeight: 48),//限制滚动栏宽度
                      child:ToolBar(//工具栏
                        toolBarConfig: customToolBarList,
                        toolBarColor: themeData.colorScheme.primary,//工具栏背景色
                        padding: const EdgeInsets.all(8),
                        iconSize: 25,
                        iconColor: themeData.colorScheme.surface,//图标颜色
                        activeIconColor: Colors.greenAccent.shade400,//激活状态图标颜色
                        controller: controller,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        direction: Axis.horizontal,
                        customButtons: [
                          InkWell(//加号按钮，将被选中内容转换为html格式
                              onTap: () async {
                                var Text = await controller.getText();
                                debugPrint('selectedText $Text');
                              },
                              child: const Icon(
                                Icons.add_circle,
                                color: Colors.black,
                              )),
                        ],
                      )
                    ))
                )
              ),
            )
        ],
      ),
    );
  }
  void unFocusEditor() => controller.unFocus();

  Widget _chipWidget(ThemeData themeData, String label) {
    return UnconstrainedBox(
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(75),
          border: Border.all(
            color: themeData.colorScheme.primary,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
            ),
            Text(
              label,
              style: themeData.textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 12,
                color: themeData.colorScheme.primary,
              ),
            ),
            Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(4),
              margin:
                  const EdgeInsets.only(left: 8, top: 2, bottom: 2, right: 2),
              decoration: BoxDecoration(
                color: const Color(0xff376AED).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: InkWell(//删除标签
                onTap: (){

                },
                child:SvgPicture.asset(
                  'assets/img/icons/close.svg',
                  width: 16,
                  height: 16,
              ) ,)
            ),
          ],
        ),
      ),
    );
  }
}