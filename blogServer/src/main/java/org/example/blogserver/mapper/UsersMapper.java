package org.example.blogserver.mapper;

import org.example.blogserver.entity.Users;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 *  Mapper 接口
 * </p>
 *
 * @author xiaosenho
 * @since 2024-04-26
 */
@Mapper
public interface UsersMapper extends BaseMapper<Users> {

}
