package org.example.blogserver.service;

import org.example.blogserver.entity.Collects;
import com.baomidou.mybatisplus.extension.service.IService;
import org.example.blogserver.entity.Likes;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author xiaosenho
 * @since 2024-05-22
 */
public interface CollectsService extends IService<Collects> {
    /**
     * 查询对应文章id和用户id的收藏资料
     * @param articleId
     * @param userId
     * @return
     */
    Collects findCollect(int articleId, int userId);

    /**
     * 添加收藏
     * @param articleId
     * @param userId
     */
    boolean addCollect(int articleId,int userId);

}
