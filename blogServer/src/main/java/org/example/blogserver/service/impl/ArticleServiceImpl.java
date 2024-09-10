package org.example.blogserver.service.impl;

import cn.dev33.satoken.util.SaResult;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.example.blogserver.entity.Article;
import org.example.blogserver.entity.Category;
import org.example.blogserver.entity.Collects;
import org.example.blogserver.mapper.ArticleMapper;
import org.example.blogserver.mapper.CollectsMapper;
import org.example.blogserver.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileWriter;
import java.util.List;
import java.util.stream.Collectors;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author xiaosenho
 * @since 2024-04-29
 */
@Service
public class ArticleServiceImpl extends ServiceImpl<ArticleMapper, Article> implements ArticleService {
    @Autowired
    private ArticleMapper articleMapper;
    @Autowired
    private CollectsMapper collectsMapper;
    @Autowired
    private Environment env;

    /**
     * 文章保存，将文章内容保存到本地文件，采用事务管理
     * @param article
     * @param file
     * @param content
     * @throws Exception
     */
    @Transactional
    @Override
    public void saveArticle(Article article, MultipartFile file,String content) throws Exception {
        this.save(article);//提前保存生成主键
        //文章封面保存
        if (!file.isEmpty()) {//保存文件到本地
            String coverFileName = "covers/cover_" + article.getArticleID() + ".png";
            String coverPath = generateCoverPath(coverFileName);//生成封面文件路径
            file.transferTo(new File(coverPath));//文件转存到服务端磁盘中
            article.setCover(coverFileName);//添加头相对路径
            this.updateById(article);//更新封面路径
        }
        //文章正文处理，转换成html文件
        if(!content.isEmpty()){
            String htmlFileName="htmls/html_"+article.getArticleID()+".html";
            String htmlPath = generateCoverPath(htmlFileName);//生成html文件路径
            FileWriter fileWriter;
            fileWriter = new FileWriter(htmlPath);
            fileWriter.write(content);//写入文件中
            fileWriter.close();
            article.setContent(htmlFileName);//添加正文相对路径
            this.updateById(article);//更新正文路径
        }
    }


    @Override
    public IPage<Article> searchArticle(int pageNum, int pageSize,String keyword,String category,String order){
        String orderBy = "created_at";
        if("按热度排序".equals(order)) orderBy="likes";
        QueryWrapper<Article> queryWrapper = new QueryWrapper<>();
        try{
            int categoryId= Category.valueOf(category).value();
            queryWrapper.eq("category_id",categoryId).like("title",keyword).orderByDesc(orderBy);
        }catch (IllegalArgumentException e){//枚举中没有，则返回所有情况
            queryWrapper.like("title",keyword).orderByDesc(orderBy);
        }
        Page<Article> page = new Page<>(pageNum, pageSize);
        return articleMapper.selectPage(page,queryWrapper);
    }

    /**
     * 获取最新的文章列表，分页查询
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public IPage<Article> getLatestArticlePage(int pageNum, int pageSize) {
        QueryWrapper<Article> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("created_at");
        Page<Article> page = new Page<>(pageNum, pageSize);
        return articleMapper.selectPage(page,queryWrapper);
    }

    /**
     * 获取用户的文章列表，分页查询
     * @param userId
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public IPage<Article> getUserArticlePage(int userId,int pageNum, int pageSize) {
        QueryWrapper<Article> queryWrapper = new QueryWrapper<>();
        queryWrapper
                .eq("id",userId)
                .orderByDesc("created_at");
        Page<Article> page = new Page<>(pageNum, pageSize);
        return articleMapper.selectPage(page,queryWrapper);
    }

    /**
     * 获取用户收藏的文章列表，分页查询
     * @param userId
     * @param pageNum
     * @param pageSize
     * @return
     */
    @Override
    public IPage<Article> getCollectsArticles(int userId, int pageNum, int pageSize) {
        List<Collects> collects= collectsMapper.selectList(new LambdaQueryWrapper<Collects>().eq(Collects::getUserId,userId));
        if(collects.isEmpty())return new Page<>(pageNum, pageSize);
        else {
            QueryWrapper<Article> queryWrapper = new QueryWrapper<>();
            queryWrapper
                    .in("articleId",collects.stream().map(Collects::getArticleId).collect(Collectors.toList()))
                    .orderByDesc("created_at");
            Page<Article> page = new Page<>(pageNum, pageSize);
            return articleMapper.selectPage(page,queryWrapper);
        }
    }

    String generateCoverPath(String coverFileName) {
        // 定义头像文件存储的根目录
        String rootDirectory = env.getProperty("spring.servlet.multipart.location");
        // 返回完整的头像文件路径
        return rootDirectory + coverFileName;
    }
}
