package org.example.blogserver.service.impl;

import org.example.blogserver.entity.Users;
import org.example.blogserver.mapper.UsersMapper;
import org.example.blogserver.service.UsersService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author xiaosenho
 * @since 2024-04-26
 */
@Service
public class UsersServiceImpl extends ServiceImpl<UsersMapper, Users> implements UsersService {
    @Autowired
    private Environment env;

    /**
     * 注册用户，进行事务管理，保存用户信息，生成头像文件，返回头像文件路径
     * @param user
     * @return avatarPath
     * @throws Exception
     */
    @Transactional
    @Override
    public String register(Users user) throws Exception{
        this.save(user);//保存用户
        String avatarFileName= "avatars/avatar_"+user.getId()+".png";//生成头像文件名
        String avatarPath = generateAvatarPath(avatarFileName);//生成头像文件路径
        user.setAvatar(avatarFileName);//添加头相对路径
        this.updateById(user);
        return avatarPath;
    }

    /**
     * 生成头像文件路径
     * @param avatarFileName
     * @return
     */
    String generateAvatarPath(String avatarFileName) {
        // 定义头像文件存储的根目录
        String rootDirectory = env.getProperty("spring.servlet.multipart.location");
        // 返回完整的头像文件路径
        return rootDirectory + avatarFileName;
    }
}
