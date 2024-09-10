package org.example.blogserver.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import java.io.Serializable;
import java.util.Date;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

/**
 * <p>
 * 
 * </p>
 *
 * @author xiaosenho
 * @since 2024-05-21
 */
@Getter
@Setter
@Accessors(chain = true)
@TableName("article")
public class Article implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "articleID", type = IdType.ASSIGN_ID)
    private Integer articleID;

    /**
     * 文章标题
     */
    @TableField("title")
    private String title;

    /**
     * 文章子标题、简介
     */
    @TableField("subtitle")
    private String subtitle;

    /**
     * 封面图路径
     */
    @TableField("cover")
    private String cover;

    /**
     * 创建用户id
     */
    @TableField("id")
    private Integer id;

    @TableField("category_id")
    private Integer categoryId;

    @TableField("likes")
    private Integer likes;

    /**
     * 正文内容路径
     */
    @TableField("content")
    private String content;

    @TableField("created_at")
    private Date createdAt;

    @TableField("updated_at")
    private Date updatedAt;

    /**
     * 逻辑删除
     */
    @TableField("deleted")
    @TableLogic
    private Integer deleted;
}
