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
 * @since 2024-05-22
 */
@Getter
@Setter
@Accessors(chain = true)
@TableName("collects")
public class Collects implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "collectId", type = IdType.ASSIGN_ID)
    private Integer collectId;

    @TableField("created_at")
    private Date createdAt;

    @TableField("update_at")
    private Date updateAt;

    @TableField("articleId")
    private Integer articleId;

    @TableField("userId")
    private Integer userId;
}
