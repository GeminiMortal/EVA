package com.eva.server.controller;

import com.eva.server.common.Result;
import com.eva.server.utils.JwtUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 认证控制器
 */
@RestController
@RequestMapping("/auth")
public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);
    
    private final JwtUtil jwtUtil;
    
    public AuthController(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    /**
     * 用户登录
     *
     * @param loginRequest 登录请求 {username, password}
     * @return Token 和用户信息
     */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody Map<String, String> loginRequest) {
        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        // TODO: 验证用户名和密码（从数据库查询）
        // 这里只是示例，实际应该查询数据库并验证密码
        
        log.info("用户登录: {}", username);

        // 生成 Token
        String token = jwtUtil.generateToken(username);
        String refreshToken = jwtUtil.generateRefreshToken(username);

        // 构建响应
        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        response.put("refreshToken", refreshToken);
        response.put("tokenType", "Bearer");
        response.put("expiresIn", 86400); // 24小时

        // 用户信息（示例）
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("id", 1);
        userInfo.put("username", username);
        userInfo.put("email", username + "@eva.com");
        response.put("user", userInfo);

        return Result.success(response);
    }

    /**
     * 刷新 Token
     *
     * @param refreshRequest 刷新请求 {refreshToken}
     * @return 新的 Token
     */
    @PostMapping("/refresh")
    public Result<Map<String, String>> refreshToken(@RequestBody Map<String, String> refreshRequest) {
        String refreshToken = refreshRequest.get("refreshToken");

        // 验证刷新 Token
        if (!jwtUtil.validateToken(refreshToken)) {
            return Result.error(401, "无效的刷新 Token");
        }

        // 获取用户名
        String username = jwtUtil.getSubjectFromToken(refreshToken);

        // 生成新的 Token
        String newToken = jwtUtil.generateToken(username);

        Map<String, String> response = new HashMap<>();
        response.put("token", newToken);
        response.put("tokenType", "Bearer");

        return Result.success(response);
    }

    /**
     * 获取当前用户信息
     *
     * @param authorization Authorization header
     * @return 用户信息
     */
    @GetMapping("/userinfo")
    public Result<Map<String, Object>> getUserInfo(@RequestHeader("Authorization") String authorization) {
        // 提取 Token
        String token = authorization.replace("Bearer ", "");

        // 验证 Token
        if (!jwtUtil.validateToken(token)) {
            return Result.error(401, "无效的 Token");
        }

        // 获取用户名
        String username = jwtUtil.getSubjectFromToken(token);

        // TODO: 从数据库查询用户详细信息
        Map<String, Object> userInfo = new HashMap<>();
        userInfo.put("id", 1);
        userInfo.put("username", username);
        userInfo.put("email", username + "@eva.com");
        userInfo.put("roles", new String[]{"ADMIN"});

        return Result.success(userInfo);
    }

    /**
     * 用户登出
     *
     * @return 成功响应
     */
    @PostMapping("/logout")
    public Result<Void> logout() {
        // TODO: 如果使用 Redis，可以在此将 Token 加入黑名单
        log.info("用户登出");
        return Result.success();
    }
}
