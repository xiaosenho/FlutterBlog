package org.example.blogserver.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import org.example.blogserver.entity.Article;
import org.springframework.web.multipart.MultipartFile;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author xiaosenho
 * @since 2024-04-29
 */
public interface ArticleService extends IService<Article> {
    /**
     * 保存文章
     * @param article
     * @param file
     * @param content
     * @throws Exception
     */
    void saveArticle(Article article, MultipartFile file,String content) throws Exception;

    /**
     * 搜索文章，根据关键词、分类、排序
     * @param pageNum
     * @param pageSize
     * @param keyword
     * @param category
     * @param order
     * @return
     */
    IPage<Article> searchArticle(int pageNum, int pageSize,String keyword,String category,String order);

    /**
     * 获取最新文章，分页查询
     * @param pageNum
     * @param pageSize
     * @return
     */
    IPage<Article> getLatestArticlePage(int pageNum, int pageSize);

    /**
     * 获取用户文章，分页查询
     * @param userId
     * @param pageNum
     * @param pageSize
     * @return
     */
    IPage<Article> getUserArticlePage(int userId,int pageNum, int pageSize);

    IPage<Article> getCollectsArticles(int userId,int pageNum, int pageSize);
}
