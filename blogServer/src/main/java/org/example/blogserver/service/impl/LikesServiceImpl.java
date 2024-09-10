package org.example.blogserver.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.example.blogserver.entity.Article;
import org.example.blogserver.entity.Likes;
import org.example.blogserver.mapper.LikesMapper;
import org.example.blogserver.service.ArticleService;
import org.example.blogserver.service.LikesService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author xiaosenho
 * @since 2024-05-21
 */
@Service
public class LikesServiceImpl extends ServiceImpl<LikesMapper, Likes> implements LikesService {
    @Autowired
    private ArticleService articleService;

    @Override
    public Likes findLike(int articleId, int userId) {
        return this.getOne(new LambdaQueryWrapper<Likes>()
                .eq(Likes::getUserId,userId)
                .eq(Likes::getArticleId,articleId));
    }
    @Transactional
    @Override
    public void addLike(int articleId, int userId) {
        Article article=articleService.getById(articleId);
        Likes newLike=new Likes();
        article.setLikes(article.getLikes()+1);
        articleService.updateById(article);//点赞数保存
        newLike.setArticleId(articleId);
        newLike.setUserId(userId);
        this.save(newLike);//点赞关系保存
    }
    @Transactional
    @Override
    public void removeLike(int articleId, Likes likes) {
        Article article=articleService.getById(articleId);
        this.removeById(likes);
        article.setLikes(article.getLikes()-1);
        articleService.updateById(article);
    }

}
