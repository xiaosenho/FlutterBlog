package org.example.blogserver.controller;

import cn.dev33.satoken.exception.NotLoginException;
import cn.dev33.satoken.session.SaSession;
import cn.dev33.satoken.stp.SaTokenInfo;
import cn.dev33.satoken.stp.StpUtil;
import cn.dev33.satoken.util.SaResult;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.service.IService;
import com.google.gson.Gson;
import org.example.blogserver.entity.Collects;
import org.example.blogserver.entity.Likes;
import org.example.blogserver.entity.Users;
import org.example.blogserver.service.CollectsService;
import org.example.blogserver.service.LikesService;
import org.example.blogserver.service.UsersService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Map;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author admin
 * @since 2024-04-25
 */
@RestController
@RequestMapping("/users")
public class UsersController {
    @Autowired
    private Gson gson;

    @Autowired
    private UsersService usersService;
    @Autowired
    private LikesService likesService;
    @Autowired
    private CollectsService collectsService;

    /**
     * 登录
     * @param json
     * @return
     */
    @PostMapping("/login")
    public SaResult login(@RequestBody String json) {
        // 使用 Type 类型来指定 Map 的类型
        Type type = new com.google.gson.reflect.TypeToken<Map<String, String>>(){}.getType();
        Map<String,String> map=gson.fromJson(json,type);

        // 查询数据库中是否存在该用户
        Users user=usersService.getOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getEmail, map.get("email"))
        );

        if(user!=null){
            // 处理登录逻辑，验证用户名和密码等
            if(user.getEmail().equals(map.get("email"))&&user.getPassword().equals(map.get("password"))){
                //获取临时会话绑定token的验证码值
                String captcha=(String) StpUtil.getTokenSessionByToken(StpUtil.getTokenValue()).get("captcha");
                if(captcha.equals(map.get("captcha"))){//验证码判断
                    StpUtil.login(map.get("email"));//用户登录
                    //缓存用户信息到session中
                    SaSession session = StpUtil.getSession();
                    session.set("user",user);
                    //获取token信息
                    SaTokenInfo tokenInfo = StpUtil.getTokenInfo();
                    return SaResult.ok().setData(tokenInfo);//返回token信息
                }else return SaResult.error("验证码错误");
            }else  // 如果验证失败，返回错误信息
                return SaResult.error("用户名或密码错误");
        }else return SaResult.error("用户不存在");
    }

    /**
     * 用户注册
     * @param username
     * @param password
     * @param email
     * @param profession
     * @param file
     * @return
     */
    @PostMapping("/register")
    public SaResult register(@RequestParam("username") String username,
                             @RequestParam("password") String password,
                             @RequestParam("email") String email,
                             @RequestParam("profession") String profession,
                             @RequestParam("avatar") MultipartFile file){

        Users user=new Users();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setProfession(profession);
        try{
            String avatarPath = usersService.register(user);
            if (!file.isEmpty()) {//保存文件到本地
                file.transferTo(new File(avatarPath));
            }
            StpUtil.login(email);//用户登录
            //缓存用户信息到session中
            SaSession session = StpUtil.getSession();
            session.set("user",user);
            //获取token信息
            SaTokenInfo tokenInfo = StpUtil.getTokenInfo();
            return SaResult.ok().setData(tokenInfo);//返回token信息
        }catch (DuplicateKeyException duplicateKeyException) {//重复值冲突异常
            return SaResult.error("邮箱已被注册");
        }catch (Exception e){
            return SaResult.error("注册异常"+e);
        }
    }

    /**
     * 用户登出
     * @return
     */
    @PostMapping("/logout")
    public SaResult logout() {
        // 处理登出逻辑
        StpUtil.logout();
        return SaResult.ok();
    }

    /**
     * 判断当前用户是否登录
     * @return
     */
    @GetMapping("/isLogin")
    public ResponseEntity<Boolean> isLogin() {
        // 判断当前用户是否登录
        return ResponseEntity.ok(StpUtil.isLogin());
    }

    /**
     * 获取当前登录用户信息
     * @return
     */
    @GetMapping("/getUserInfo")
    public SaResult getUserInfo() {
        SaSession session=StpUtil.getSession();
        Users user=(Users) session.get("user");
        user.setPassword("******");//密码不返回
        return SaResult.ok().setData(user);
    }

    /**
     * 获取文章作者用户信息
     * @param id
     * @return
     */
    @GetMapping("/getAuthor")
    public SaResult getAuthor(@RequestParam("id") int id){
        // 查询数据库中是否存在该用户
        Users user=usersService.getOne(new LambdaQueryWrapper<Users>()
                .eq(Users::getId, id));
        if (user != null) {
            return SaResult.ok().setData(user);
        }else return SaResult.error("用户不存在");
    }

    @GetMapping("/getLikeAndCol")
    public SaResult getLikeAndCol(@RequestParam("articleId") int articleId){
        try {
            SaSession session= StpUtil.getSession();
            Users user= (Users) session.get("user");
            boolean isLiked=false;
            boolean isMarked=false;
            if(likesService.findLike(articleId,user.getId())!=null){
                isLiked=true;
            }
            if(collectsService.getOne(new LambdaQueryWrapper<Collects>()
                    .eq(Collects::getUserId,user.getId())
                    .eq(Collects::getArticleId,articleId))!=null){
                isMarked=true;
            }
            HashMap <String,Boolean> map=new HashMap<>();
            map.put("isLiked",isLiked);
            map.put("isCollected",isMarked);
            return SaResult.ok().setData(map);
        }catch (NotLoginException e){
            return SaResult.ok("请先登录").setCode(204);//204——请求收到，但返回信息为空
        }
    }
}
