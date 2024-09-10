package org.example.blogserver.controller;

import cn.dev33.satoken.session.SaSession;
import cn.dev33.satoken.stp.StpUtil;
import com.google.gson.Gson;
import jakarta.annotation.Resource;
import org.example.blogserver.entity.Message;
import org.springframework.ai.chat.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.openai.OpenAiChatClient;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

/**
 * @author: 作者
 * @create: 2024-05-05 18:35
 * @Description:
 */
@Controller
@CrossOrigin(origins = "http://127.0.0.1:5500")
public class ChatController {
    public static final String STREAM_TERMINATION_CHAR = "\u001E"; // ASCII码表中的Record Separator (RS)
    @Resource
    private OpenAiChatClient openAiChatClient;

    @Autowired
    Gson gson;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @GetMapping("/chat")
    public Object chat(String msg) {
        //带上下文的prompt已注释
//        Map<String,Object> prompt = new HashMap<>();
//        List<Message> message = new ArrayList<>();
//        System.out.println(StpUtil.isLogin());
//        if(StpUtil.isLogin()){
//            SaSession session= StpUtil.getSession();
//            message.addAll(session.get("chat_history",new ArrayList<>()));
//        }
//        Message newMessage = new Message("user",msg);
//        message.add(newMessage);
//        prompt.put("model","gpt-4");
//        prompt.put("messages", message);
//        ChatResponse chatResponse=openAiChatClient.call(new Prompt(gson.toJson(prompt)));
//        String answer = chatResponse.getResult().getOutput().getContent();
//        message.add(new Message("assistant",answer));
//        if(StpUtil.isLogin()){
//            SaSession session= StpUtil.getSession();
//            session.set("chat_history",message);
//        }

        Flux<ChatResponse> flux=openAiChatClient.stream(new Prompt(msg,OpenAiChatOptions.builder()
                .withTemperature((float) 0.5)//温度越高创造性越好，相对精确率越低
                .build()));
        flux.toStream().forEach(chatResponse -> {
            System.out.println(chatResponse.getResult().getOutput().getContent());});
        return "hello!";
    }

    @MessageMapping("/hello")
    public void greeting(String msg) {
        Map map=gson.fromJson(msg,Map.class);
        String text= (String) map.get("message");
        double temp= (double) map.get("temperature");
        Flux<ChatResponse> flux = openAiChatClient.stream(new Prompt(text, OpenAiChatOptions.builder()
                .withTemperature((float) temp)//温度越高创造性越好，相对精确率越低
                .build()));
        //subscribe 方法在 Reactor 库中是一个终端操作符，它会触发数据流的订阅，从而开始处理数据,单线程不会出现并发错误
        flux.doOnComplete(()->{//结尾添加终止符
            messagingTemplate.convertAndSend("/topic/greetings", STREAM_TERMINATION_CHAR);
        }).subscribe(chatResponse -> {
            if(chatResponse.getResult()!=null) {
                String result = chatResponse.getResult().getOutput().getContent();
                if(result!=null)
                    if(!"null".equals(result)) messagingTemplate.convertAndSend("/topic/greetings", result);
            }
        });
    }
}
