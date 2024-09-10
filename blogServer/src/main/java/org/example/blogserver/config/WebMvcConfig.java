package org.example.blogserver.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * @author: 作者
 * @create: 2024-05-22 19:41
 * @Description:
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    /*
     * 配置全局跨域请求
     * */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/cors/**").
                allowedHeaders("*").
                allowedMethods("*").
                maxAge(1800).
                allowedOrigins("*");

        registry.addMapping("/**").
                allowedHeaders("*").
                allowedMethods("*").
                maxAge(1800).
                allowedOrigins("http://localhost:59512");
    }
}

