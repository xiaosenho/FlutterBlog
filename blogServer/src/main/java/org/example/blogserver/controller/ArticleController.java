package org.example.blogserver.controller;

import cn.dev33.satoken.session.SaSession;
import cn.dev33.satoken.stp.StpUtil;
import cn.dev33.satoken.util.SaResult;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.google.gson.Gson;
import org.example.blogserver.entity.Article;
import org.example.blogserver.entity.Category;
import org.example.blogserver.entity.Users;
import org.example.blogserver.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author xiaosenho
 * @since 2024-04-29
 */
@RestController
@RequestMapping("/article")
public class ArticleController {
    @Autowired
    private Gson gson;
    @Autowired
    private ArticleService articleService;

    /***
     * 文章上传方法，根据提交的文章标题和副标题，将文章内容写入到本地文件中
     * 封面内容可为空文件
     * 正文内容需要将前端提交的字符串保存为Html文件
     * @param title
     * @param subTitle
     * @param file
     * @param category
     * @param content
     * @return
     */
    @PostMapping("/upload")
    public SaResult uploadFile(@RequestParam("title") String title,
                               @RequestParam("sub_title") String subTitle,
                               @RequestParam("cover") MultipartFile file,
                               @RequestParam("category") String category,
                               @RequestParam("content") String content) {
        try {
            int index = Category.valueOf(category).value();//获取分类枚举对应下标
            SaSession session = StpUtil.getSession();
            Users user = (Users) session.get("user");//获取用户会话存储的user数据
            //配置文章基本信息
            Article article = new Article();
            article.setTitle(title);
            article.setSubtitle(subTitle);
            article.setId(user.getId());
            article.setCategoryId(index);
            articleService.saveArticle(article, file, content);
        } catch (IllegalArgumentException e) {
            return SaResult.error("文章分类错误");
        } catch (Exception e){
            return SaResult.error("文章上传失败" + e);
        }
        return SaResult.ok();
    }

    /***
     * 获取最新文章，提供分页查询，根据时间排序
     * @param pageNum
     * @param pageSize
     * @return
     */
    @GetMapping("/latestArticles")
    public SaResult getLatestArticles(@RequestParam(defaultValue = "1") int pageNum,
                                      @RequestParam(defaultValue = "10") int pageSize){
        IPage<Article> articlePage = articleService.getLatestArticlePage(pageNum, pageSize);
        return SaResult.ok().setData(gson.toJson(articlePage));
    }

    /***
     * 获取用户文章，提供分页查询，根据时间排序
     * @param pageNum
     * @param pageSize
     * @return
     */
    @GetMapping("/userArticles")
    public SaResult getUserArticles(@RequestParam(defaultValue = "1") int pageNum,
                                    @RequestParam(defaultValue = "10") int pageSize){
        SaSession session=StpUtil.getSession();
        Users user= (Users) session.get("user");
        IPage<Article> articlePage = articleService.getUserArticlePage(user.getId(),pageNum, pageSize);
        return SaResult.ok().setData(gson.toJson(articlePage));
    }

    /**
     * 获取用户收藏文章，提供分页查询，根据时间排序
     * @param pageNum
     * @param pageSize
     * @return
     */
    @GetMapping("/collectArticles")
    public SaResult getCollectArticles(@RequestParam(defaultValue = "1") int pageNum,
                                        @RequestParam(defaultValue = "10") int pageSize){
        SaSession session=StpUtil.getSession();
        Users user= (Users) session.get("user");
        IPage<Article> articlePage = articleService.getCollectsArticles(user.getId(),pageNum, pageSize);
        return SaResult.ok().setData(gson.toJson(articlePage));
    }

    /**
     * 文章检索，根据用户提交的关键词、类别和排序方式进行检索。提供分页查询
     * @param pageNum
     * @param pageSize
     * @param keyword
     * @param category
     * @param order
     * @return
     */
    @GetMapping("/searchArticles")
    public SaResult searchArticles(@RequestParam(defaultValue = "1") int pageNum,
                                   @RequestParam(defaultValue = "10") int pageSize,
                                   @RequestParam String keyword,
                                   @RequestParam String category,
                                   @RequestParam String order
    ){
        IPage<Article> articlePage = articleService.searchArticle(pageNum,pageSize,keyword,category,order);
        return SaResult.ok().setData(gson.toJson(articlePage));
    }

    @Transactional
    @GetMapping("/deleteArticle")
    public SaResult deleteArticle(@RequestParam int articleId){
        articleService.removeById(articleId);
        return SaResult.ok();
    }
}
