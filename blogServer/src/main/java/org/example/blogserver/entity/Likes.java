package org.example.blogserver.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
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
@TableName("likes")
public class Likes implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "likeId", type = IdType.ASSIGN_ID)
    private Integer likeId;

    @TableField("articleId")
    private Integer articleId;

    @TableField("userId")
    private Integer userId;

    @TableField("update_at")
    private Date updateAt;

    @TableField("created_at")
    private Date createdAt;
}
