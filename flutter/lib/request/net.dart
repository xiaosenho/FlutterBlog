import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// 自定义枚举
enum Method { get, post }

class Net {
  // 工厂模式
  factory Net() => _getInstance()!;

  static Net? get instance => _getInstance();
  static Net? _instance;

  late Dio dio;
  late SharedPreferences _prefs;
  String _token = '';

  Future<void> _loadSavedValue() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString('token') ?? 'No value';
  }

  Net._internal() {
    // 初始化
    dio = Dio(BaseOptions(
      connectTimeout: Duration(milliseconds: 60 * 1000), // 连接服务器超时时间，单位是毫秒.
      receiveTimeout: Duration(milliseconds: 60 * 1000), // 响应流上前后两次接受到数据的间隔，单位为毫秒, 这并不是接收数据的总时限.
    ));
    dio.options.baseUrl="http://122.51.76.116:8081";
  }

  // 单例模式
  static Net? _getInstance() {
    _instance ??= Net._internal();
    return _instance;
  }

  get(String url, Map<String, dynamic> params, {Function? success}) {
    _doRequest(url, params, Method.get, success);
  }

  post(String url, Map<String, dynamic> params, {Function? success}) {
    _doRequest(url, params, Method.post, success);
  }

  getBody(String url, Map<String, dynamic> params, {Function? success}) {
    _doRequestBody(url, params, success);
  }

  void _doRequest(String url, Map<String, dynamic> params, Method method,
      Function? successCallBack) async {
    await _loadSavedValue();//等待获取存储token
    try {
      print(_prefs.getString('token'));
      /// 添加header
      dio.options.headers.addAll({
        "content-type": "application/json",
        'satoken': _token//配置token
      });
      Response response;
      switch (method) {
        case Method.get:
          if (params.isNotEmpty) {
            response = await dio.get(url, queryParameters: params);
          } else {
            response = await dio.get(url);
          }
          break;
        case Method.post:
          if (params.isNotEmpty) {
            if((params.containsKey('avatar') && params['avatar'] is MultipartFile)
                || (params.containsKey('cover') && params['cover'] is MultipartFile)){//文件上传需要修改参数格式
              FormData formData = FormData.fromMap(params);
              response = await dio.post(url, data: formData);
            }else response = await dio.post(url, data: params);
          } else {
            response = await dio.post(url);
          }
          break;
      }
      var result = json.decode(response.toString());
      if(result['code']==200||result['code']==204||result['code']==202){
        if (successCallBack != null) {
        //返回请求数据
          successCallBack(result);
        }
      }else {
        Fluttertoast.showToast(msg: "信息有误:"+result['code'].toString()+result['msg']);
        if (successCallBack != null) {
        //返回请求数据
          successCallBack("");
        }
      }
      
    } catch (exception) {
      Fluttertoast.showToast(msg: "网络超时，请检查网络");
      // Fluttertoast.showToast(msg: "网络超时，请检查网络"+exception.toString());
      if (successCallBack != null) {
        //返回请求数据
        successCallBack("");
      }
    }
  }

  void _doRequestBody(String url, Map<String, dynamic> params,
      Function? successCallBack) async {
    await _loadSavedValue();//等待获取存储token
    try {
      // 添加header
      dio.options.headers.addAll({
        "content-type": "application/json",
        'satoken': _token//配置token
      });
      Response response;
      response = await dio.request(url,
          data: params,
          options: Options(method: "GET", contentType: "application/json"));
      var result = json.decode(response.toString());
      if (successCallBack != null) {
        //返回请求数据
        successCallBack(result);
      }
    } catch (exception) {
      Fluttertoast.showToast(msg: "网络超时，请检查网络"+exception.toString());
      if (successCallBack != null) {
        //返回请求数据
        successCallBack("");
      }
    }
  }

}

