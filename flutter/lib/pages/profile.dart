
import 'package:flutter2/pages/profile_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../request/net.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _profilePageState();
  }
}

class _profilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin{
  //使用 AutomaticKeepAliveClientMixin 保持页面状态
  @override
  bool get wantKeepAlive => true;

  late Map<String,dynamic> user;//用户信息实例
  bool isLogin = false;//登录验证
  bool _isLoading = true; // 添加一个布尔变量来控制加载状态
  String fullUrl = '';//image网络请求地址
  String _avatarImg = '';

  @override
  void initState() {
    //初始化状态时调用请求
    super.initState();
    getUserInfo();
  }

  //获取用户信息
  void getUserInfo() async {
    Net net = Net.instance!;
    fullUrl=net.dio.options.baseUrl;
    // 发送GET请求
    net.get("/users/getUserInfo",{},success: (result) {
          setState(() {
            _isLoading = false;
          });
          if(result.isNotEmpty){
            if(result['code']==200){//已登录
              setState(() {
                isLogin=true;
                user = result['data'];
                if(user['avatar']!=null) {
                  getAvatarImg(user['avatar']);
                }
              });
            }else{//未登录或登录已过时
              setState(() {
                isLogin=false;
              });
            }
          }
    });
  }

  //获取头像图片
  void getAvatarImg(String filePath) async {
    Net net = Net.instance!;
    fullUrl=net.dio.options.baseUrl;
    var params={
      "filepath":filePath,
    };
    // 发送GET请求
    net.get("/auth/files",params,success: (result) {
      if(result.isNotEmpty){
        if(result['code']==200){//获取头像
          setState(() {
            _avatarImg = result['data'];
          });
        }else{//无头像信息
          
        }
      }
    });
  }

  void changeLoginState() async{//登录状态改变时调用，作为回调传给子页面
    setState(() {
      isLogin=!isLogin;
      if(isLogin){
        _isLoading=true;//加载
        getUserInfo();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return  _isLoading
      ? const Center(
          // 如果加载中，显示加载动画
          child: SpinKitCubeGrid(
            color: Colors.blue,
            size: 50.0,
          ),
        )
      : Center(
      child: isLogin ? LoggedInPage(user: user,callback: changeLoginState,avatarImg: _avatarImg,) : NotLoggedInPage(callback: changeLoginState), // 根据登录状态显示不同的页面
      );
  }
  
}

