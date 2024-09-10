package org.example.blogserver.config;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * @author: 作者
 * @create: 2024-05-07 14:31
 * @Description:
 */

public class WebSocketHandler extends TextWebSocketHandler {

    private final Set<WebSocketSession> sessions = Collections.synchronizedSet(new HashSet<>());
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        // 连接建立后的处理逻辑
        sessions.add(session);
        session.sendMessage(new TextMessage("Connected to the server."));
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        // 处理接收到的消息
        String payload = message.getPayload();
        System.out.println("Received message: " + payload);

        // 发送消息到客户端
        session.sendMessage(new TextMessage("Hello, client!"));
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        // 连接关闭后的处理逻辑
        sessions.remove(session);
    }
}
