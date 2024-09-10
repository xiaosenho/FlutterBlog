package org.example.blogserver;

import org.example.blogserver.controller.ChatController;
import org.junit.jupiter.api.Test;
import org.springframework.ai.chat.ChatClient;
import org.springframework.ai.chat.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.openai.OpenAiChatClient;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class BlogServerApplicationTests {
    @Autowired
    ChatController chatController;
    @Autowired
    OpenAiChatClient chatClient;

    @Test
    void contextLoads() {
        chatController.greeting("{\"message\":\"hello!\",\"temperature\":0.8}");
//        ChatResponse response = chatClient.call(
//                new Prompt(
//                        "hello!",
//                        OpenAiChatOptions.builder()
//                                .withModel("gpt-3.5-turbo")
//                .withTemperature((float) 0.5)//温度越高创造性越好，相对精确率越低
//                .build()));
//        System.out.println(response.getResult().getOutput());

    }

}
