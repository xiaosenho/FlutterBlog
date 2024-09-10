
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../request/net.dart';

class Message {
  String text;
  final bool isMine;

  Message({required this.text, required this.isMine});
}
class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  late StompClient _client;
  String baseUrl=Net.instance!.dio.options.baseUrl;
  bool isReply=false;
  bool isfirst=true;
  double _selectedOption=0.5;

  @override
  void initState() {
    super.initState();
    connect();
  }
  @override
  void dispose() {
    _client.deactivate();//关闭连接
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if(text.isEmpty)return;
    _textController.clear();
    setState(() {
      isfirst=false;
      Message message = Message(text: text, isMine: true);
      _messages.insert(0, message); // 将新消息插入到列表的开头
    });
    Message message = Message(text: "加载中", isMine: false);
    // 发送消息到服务器
    if(_client.connected&&_client.isActive){
      setState(() {
        isReply=true;
      });
      _client.send(
        destination: '/app/hello',
        body: jsonEncode({
          'temperature': _selectedOption,
          'message':text
        }),
      );
    }else message = Message(text: "无法连接，请检查网络连接", isMine: false);
    _messages.insert(0, message); // 将新消息插入到列表的开头
  }

  void connect(){
    _client = StompClient(
      config: StompConfig(
          url:  '$baseUrl/ws',
          onConnect: onConnectCallback,
          useSockJS: true
      )
    );
    _client.activate();
  }
  void onConnectCallback(StompFrame connectFrame) {
    // client is connected and ready
    _client.subscribe(destination: '/topic/greetings', headers: {}, callback: (frame) {
    // Received a frame for this subscription
      setState(() {
        if(frame.body=="\u001E"){//流终止符
          isReply=false;
        }else {
          if(_messages[0].text=="加载中"){
          _messages[0].text=frame.body??"加载中";
          }else _messages[0].text+=frame.body??"加载中";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: <Widget>[
          Flexible(
            child: isfirst?_firstLogo():ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return 
                  ChatListItem(message: _messages[index].text, isMine: _messages[index].isMine);
              },
              reverse: true, // 让新消息显示在顶部
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _firstLogo(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 50),
          Icon(
            Icons.android,
            size: 100,
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          Text(
            'AI助手',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '选择对话样式',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OptionButton(
                    text: '更创新',
                    isSelected: _selectedOption == 0.8,
                    onPressed: () {
                      setState(() {
                        _selectedOption = 0.8;
                      });
                    },
                  ),
                  OptionButton(
                    text: '更平衡',
                    isSelected: _selectedOption == 0.5,
                    onPressed: () {
                      setState(() {
                        _selectedOption = 0.5;
                      });
                    },
                  ),
                  OptionButton(
                    text: '更精确',
                    isSelected: _selectedOption == 0.2,
                    onPressed: () {
                      setState(() {
                        _selectedOption = 0.2;
                      });
                    },
                  ),
                ],
              ),
        ],
      );
  }

  Widget _buildTextComposer() {
  return IconTheme(
    data: IconThemeData(color: Colors.black),
    child: GestureDetector(
      onTap: () {
        setState(() {
          // 当用户点击输入框时，更新UI
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.grey[200],
        ),
        constraints: BoxConstraints(
          minHeight: 50,
          maxHeight: 200, // 设置输入框的最大高度
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                enabled: !isReply,
                controller: _textController,
                maxLines: null, // 设置最大行数为null，以自动增高
                onChanged: (text) {
                  setState(() {
                    // 在文本内容变化时，更新UI
                  });
                },
                decoration: InputDecoration.collapsed(hintText: '有问题尽管问我……'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _handleSubmitted(_textController.text);
              },
            ),
          ],
        ),
      ),
    ),
  );
}


}

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  OptionButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : null,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


class ChatListItem extends StatelessWidget {
  final String message;
  final bool isMine;

  const ChatListItem({
    Key? key,
    required this.message,
    required this.isMine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context); 
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
      color: isMine ? Colors.blue[100] : Colors.white, // 根据消息是自己发送还是接收，设置不同的背景色
      borderRadius: BorderRadius.circular(8.0), // 设置圆角
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMine?Icon(Icons.account_circle, size: 20.0):
          Icon(Icons.reply, size: 20.0),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMine?"你":"ChatAI",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: themeData.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
