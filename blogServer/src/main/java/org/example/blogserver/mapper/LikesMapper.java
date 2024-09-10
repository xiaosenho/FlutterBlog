package org.example.blogserver.mapper;

import org.example.blogserver.entity.Likes;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author xiaosenho
 * @since 2024-05-21
 */
@Mapper
public interface LikesMapper extends BaseMapper<Likes> {

}
