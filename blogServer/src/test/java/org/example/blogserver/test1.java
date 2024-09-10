package org.example.blogserver;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.blogserver.controller.ChatController;
import org.example.blogserver.controller.UsersController;
import org.example.blogserver.entity.Article;
import org.example.blogserver.mapper.ArticleMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

import java.util.List;

/**
 * @author: 作者
 * @create: 2024-05-07 13:43
 * @Description:
 */
@SpringBootTest
public class test1 {
    @Autowired
    private UsersController usersController;
    @Autowired
    private ArticleMapper articleMapper;
    @Test
    public void test1(){
        articleMapper.selectOne(new QueryWrapper<Article>().eq("title","123"));
    }
}
