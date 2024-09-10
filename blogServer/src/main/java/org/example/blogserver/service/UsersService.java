package org.example.blogserver.service;

import org.example.blogserver.entity.Users;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author xiaosenho
 * @since 2024-04-26
 */
public interface UsersService extends IService<Users> {

    /**
     * 注册用户
     * @param user
     * @return avatarPath
     * @throws Exception
     */
    String register(Users user) throws Exception;
}
