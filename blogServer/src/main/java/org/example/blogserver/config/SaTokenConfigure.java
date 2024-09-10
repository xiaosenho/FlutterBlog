package org.example.blogserver.config;

import cn.dev33.satoken.interceptor.SaInterceptor;
import cn.dev33.satoken.router.SaRouter;
import cn.dev33.satoken.stp.StpUtil;
import cn.dev33.satoken.util.SaResult;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @author: 作者
 * @create: 2024-04-25 14:03
 * @Description:
 */
@Configuration
public class SaTokenConfigure implements WebMvcConfigurer {
    //注册拦截器
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 注册 Sa-Token 拦截器，定义详细认证规则
        registry.addInterceptor(new SaInterceptor(handler -> {
            // 指定一条 match 规则
            SaRouter
                    .match("/**")// 拦截的 path 列表 */
                    .notMatch("/users/login")//跳过拦截
                    .notMatch("/auth/code")
                    .notMatch("/auth/files")
                    .notMatch("/users/register")
                    .notMatch("/users/getAuthor")
                    .notMatch("/article/latestArticles")
                    .notMatch("/article/searchArticles")
                    .notMatch("/chat/hello")
                    .match(!StpUtil.isLogin())//未登录匹配
                    .back(SaResult.error("尚未登录").setCode(401));    // 匹配路径返回内容
        })).addPathPatterns("/**");
    }
}
