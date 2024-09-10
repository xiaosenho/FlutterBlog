package org.example.blogserver.controller;

import cn.dev33.satoken.stp.StpUtil;
import cn.dev33.satoken.util.SaResult;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.wf.captcha.SpecCaptcha;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import java.awt.*;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@RestController
@RequestMapping("/auth")
public class ValueController {

    @Value("${spring.servlet.multipart.location}") // 注入上传文件的存储目录
    private String uploadDirectory;

    @Autowired
    private Gson gson;

    @GetMapping("/code")
    public SaResult captcha(HttpServletResponse response) throws IOException, FontFormatException {
        // 设置响应头为图片格式
        response.setContentType("image/png");
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);

        // 创建验证码对象
        SpecCaptcha captcha = new SpecCaptcha(130, 48, 5);
        captcha.setFont(SpecCaptcha.FONT_1);
        String uuid = UUID.randomUUID().toString().replace("-", "");
        // 存储验证码到 匿名未登录session 中，用于之后验证
        StpUtil.getAnonTokenSession().set("captcha", captcha.text().toLowerCase());
        String token=StpUtil.getTokenValue();

        JsonObject imgResult=new JsonObject();
        imgResult.addProperty("img", captcha.toBase64());
        imgResult.addProperty("uuid", uuid);
        imgResult.addProperty("token", token);//将临时token传给前端

        return SaResult.ok().setData(gson.toJson(imgResult));
    }

    @GetMapping("/files")
    public SaResult getFile(@RequestParam String filepath){
        if (StringUtils.isEmpty(filepath)) {
            return SaResult.error("文件名不能为空");
        }
        try{
            // 拼接文件路径
            String filePath = uploadDirectory + filepath;
            Path path = Paths.get(filePath);
            // 判断文件是否存在
            if (Files.exists(path)) {
                // 读取文件内容并返回Base64编码文件
                byte[] data = Files.readAllBytes(path);
                return SaResult.ok().setData(Base64.getEncoder().encodeToString(data));
            } else {
                return SaResult.error("文件不存在");
            }
        }catch (Exception e){
            return SaResult.error("读取文件失败");
        }
    }

}
