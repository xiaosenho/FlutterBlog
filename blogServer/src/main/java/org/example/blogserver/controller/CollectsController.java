package org.example.blogserver.controller;

import cn.dev33.satoken.exception.NotLoginException;
import cn.dev33.satoken.session.SaSession;
import cn.dev33.satoken.stp.StpUtil;
import cn.dev33.satoken.util.SaResult;
import org.example.blogserver.entity.Collects;
import org.example.blogserver.entity.Likes;
import org.example.blogserver.entity.Users;
import org.example.blogserver.service.CollectsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author xiaosenho
 * @since 2024-05-22
 */
@RestController
@RequestMapping("/collects")
public class CollectsController {

    @Autowired
    private CollectsService collectsService;
    /**
     * 收藏和取消
     * @param articleId
     * @return
     */
    @Transactional
    @GetMapping("/changeCollect")
    public SaResult addLike(@RequestParam("articleId") int articleId){
        try{
            SaSession session= StpUtil.getSession();
            Users user= (Users) session.get("user");
            Collects collect=collectsService.findCollect(articleId,user.getId());
            if(collect==null){
                collectsService.addCollect(articleId,user.getId());
                return SaResult.ok().setCode(200);
            }else{
                collectsService.removeById(collect);
                return SaResult.ok().setCode(204);//204——请求收到，但返回信息为空
            }
        }catch (NotLoginException e){//拦截器拦截，待删除
            return SaResult.error("未登录");
        }
    }
}
