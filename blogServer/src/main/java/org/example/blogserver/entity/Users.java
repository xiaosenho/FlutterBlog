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
 * @since 2024-04-26
 */
@Getter
@Setter
@Accessors(chain = true)
@TableName("users")
public class Users implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)//使用雪花算法自动生成主键ID
    private Integer id;

    @TableField("username")
    private String username;

    @TableField("password")
    private String password;

    /**
     * 每个邮箱绑定一个用户，不可重复
     */
    @TableField("email")
    private String email;

    @TableField("intro")
    private String intro;

    /**
     * 头像相对路径
     */
    @TableField("avatar")
    private String avatar;

    @TableField("profession")
    private String profession;

    @TableField("created_at")
    private Date createdAt;

    @TableField("updated_at")
    private Date updatedAt;

    @TableField("deleted")
    @TableLogic
    private Integer deleted;

}
