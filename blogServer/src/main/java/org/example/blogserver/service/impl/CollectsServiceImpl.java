package org.example.blogserver.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.example.blogserver.entity.Article;
import org.example.blogserver.entity.Collects;
import org.example.blogserver.entity.Likes;
import org.example.blogserver.mapper.CollectsMapper;
import org.example.blogserver.service.CollectsService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author xiaosenho
 * @since 2024-05-22
 */
@Service
public class CollectsServiceImpl extends ServiceImpl<CollectsMapper, Collects> implements CollectsService {

    @Override
    public Collects findCollect(int articleId, int userId) {
        return this.getOne(new LambdaQueryWrapper<Collects>()
                .eq(Collects::getUserId,userId)
                .eq(Collects::getArticleId,articleId));
    }
    @Transactional
    @Override
    public boolean addCollect(int articleId, int userId) {
        Collects collects = new Collects();
        collects.setArticleId(articleId);
        collects.setUserId(userId);
        return this.save(collects);
    }
}
