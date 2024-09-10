import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../request/net.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  String _email = '';
  String _selectedProfession = '程序员';
  // 头像图片文件
  late File _imageFile;
  bool _isImageSelected = false; // 添加一个标志来指示是否已经选择了图片

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

  // 处理头像上传
  void _handleAvatarUpload() async {
    // 打开相册或者拍照选择图片
    await _pickImage(ImageSource.gallery); // 可以选择 ImageSource.camera 打开相机
    if (_isImageSelected) {
      // 将选定的图片文件上传到服务器
      // 在这里添加上传图片到服务器的逻辑，可以使用 http 包或者 dio 包发送请求
      // 上传成功后，服务器会返回图片的访问路径
      // 保存图片访问路径到本地存储
    }
  }

  // 模拟上传图片到服务器的方法
  Future<String> uploadImageToServer(File imageFile) async {
    // 这里模拟上传图片到服务器的过程，并返回图片的访问路径
    await Future.delayed(Duration(seconds: 2)); // 模拟上传延迟
    return 'https://example.com/uploads/avatar.jpg'; // 返回图片的访问路径
  }

  // 处理注册按钮点击事件
  void _handleRegister() async{
    // 在这里添加注册逻辑，将_email、_username、_password、_selectedProfession提交给后端进行注册
    Net net = Net.instance!;
    // 创建一个空的Uint8List对象
    Uint8List emptyBytes = Uint8List(0);

    // 创建一个MultipartFile对象
    var file = MultipartFile.fromBytes(
      emptyBytes,
      filename: 'empty.png',
    );
    var params={
      "username": _username, 
      "password": _password,
      "email": _email,
      "profession": _selectedProfession,
      "avatar": _isImageSelected? await MultipartFile.fromFile(_imageFile.path, filename: "avatar.png"):file};
    // 发送POST请求
    net.post("/users/register", params , success: (result) {
      if(result.isNotEmpty){
        final Function callback = ModalRoute.of(context)!.settings.arguments as Function;
        print("callback:"+callback.toString());
        var token=result['data']['tokenValue'];
        saveToken(token);
        Fluttertoast.showToast(msg: "注册成功");
        callback();
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
  }

  void checkInfo() async{//信息验证
    if(_email.isEmpty||_username.isEmpty||_password.isEmpty||_isImageSelected==false){
      Fluttertoast.showToast(msg: "请填写完整信息");
    }else if(_password!=_confirmPassword){
      Fluttertoast.showToast(msg: "两次密码不一致");
    }else if(_validateEmail(_email)){
      Fluttertoast.showToast(msg: "邮箱格式不正确");
    }else{
      _handleRegister();
    }
  }
  @override
  void initState() {
    //初始化状态时调用请求
    super.initState();
  }
  
  Future<void> saveToken(String token) async {
    // 保存token到本地
    // 使用SharedPreferences来保存token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  bool _validateEmail(String value) {
    // 正则表达式用于验证邮箱格式
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return !regex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // 头像上传部分
            GestureDetector(
              onTap: _handleAvatarUpload,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
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
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                  _username = value;
              },
              decoration: InputDecoration(
                hintText: '用户名',
                icon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                  _password = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                hintText: '密码',
                icon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                  _confirmPassword = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                hintText: '确认密码',
                icon: Icon(Icons.password_outlined),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                _email = value;
              },
              decoration: InputDecoration(
                hintText: '邮箱地址',
                icon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 20.0),
            // 职业选择栏
            DropdownButtonFormField(
              value: _selectedProfession,
              items: ['程序员', '设计师', '教师', '个人职业者','学生']
                  .map((profession) {
                return DropdownMenuItem(
                  value: profession,
                  child: Text(profession),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProfession = value.toString();
                });
              },
              decoration: InputDecoration(
                labelText: '职业',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(//注册按钮
              onPressed: () {
                // 处理注册逻辑
                checkInfo();
              },
              child: Text('注册'),
            ),
            
          ],
        ),
      ),
    );
  }
}