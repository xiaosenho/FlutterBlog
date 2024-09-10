
import 'package:flutter/material.dart';
import '../request/net.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _password = '';
  String _captchaImg = '';
  String _captcha = '';
  @override
  void initState() {
    //初始化状态时调用请求
    super.initState();
    getCaptchaImage();
  }

  getCaptchaImage() async{//验证码图片获取
    Net net = Net.instance!;
    // 发送GET请求
    net.get("/auth/code",{},success: (result) {
      
      //修改状态都要放到setState函数中，否则页面不会更新
        setState(() {
          if(result.isNotEmpty){
            // 含有前缀，继续解析为 Map
            Map<String, dynamic> data = json.decode(result['data']);
            var img=data['img'];
            var token=data['token'];
            saveToken(token);
            _captchaImg  = img.split(',').last;
          }
        });
    });
  }

  login() async{//登录请求
    Net net = Net.instance!;
    var params={"email": _email, "password": _password, "captcha": _captcha};
    // 发送POST请求
    net.post("/users/login", params , success: (result) {
      if(result.isNotEmpty){
        Function callback=ModalRoute.of(context)!.settings.arguments as Function;
        var token=result['data']['tokenValue'];
        saveToken(token);
        Fluttertoast.showToast(msg: "登录成功");
        callback();
        Navigator.pop(context);
      }
    });
  }

  Future<void> saveToken(String token) async {
    // 保存token到本地
    // 使用SharedPreferences来保存token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                  _email = value;
              },
              decoration: InputDecoration(
                hintText: '邮箱地址',
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      _captcha = value;
                    },
                    decoration: InputDecoration(
                      hintText: '验证码',
                      icon: Icon(Icons.security),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                _captchaImg.isNotEmpty
                    ? InkWell(
                        onTap: () {//点击刷新验证码
                          getCaptchaImage();
                        },
                        child: Image.memory(
                        base64Decode(_captchaImg), // 将 Base64 编码字符串转换为图片
                        width: 100.0,
                        height: 40.0,
                      ),)
                    : SizedBox(width: 100.0, height: 40.0),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: Text('登录'),
                  ),
                ),
                SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/register",arguments:(ModalRoute.of(context)!.settings.arguments as Function));
                  },
                  child: Text('注册'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}