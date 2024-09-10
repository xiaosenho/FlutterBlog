package org.example.blogserver.service;

import org.example.blogserver.entity.Likes;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author xiaosenho
 * @since 2024-05-21
 */
public interface LikesService extends IService<Likes> {
    /**
     * 查询对应文章id和用户id的点赞资料
     * @param articleId
     * @param userId
     * @return
     */
    Likes findLike(int articleId,int userId);

    /**
     * 添加点赞
     * @param articleId
     * @param userId
     */
    void addLike(int articleId,int userId);

    /**
     * 删除点赞
     * @param articleId
     * @param likes
     */
    void removeLike(int articleId,Likes likes);
}
