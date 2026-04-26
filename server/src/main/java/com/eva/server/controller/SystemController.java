package com.eva.server.controller;

import com.eva.server.common.Result;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 系统信息控制器
 */
@RestController
@RequestMapping("/system")
public class SystemController {

    /**
     * 健康检查
     */
    @GetMapping("/health")
    public Result<Map<String, Object>> health() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("timestamp", LocalDateTime.now());
        health.put("application", "EVA Server");
        health.put("javaVersion", System.getProperty("java.version"));
        
        return Result.success(health);
    }

    /**
     * 获取服务器信息
     */
    @GetMapping("/info")
    public Result<Map<String, String>> info() {
        Map<String, String> info = new HashMap<>();
        info.put("application", "EVA Management System");
        info.put("version", "1.0.0");
        info.put("javaVersion", System.getProperty("java.version"));
        info.put("osName", System.getProperty("os.name"));
        info.put("osArch", System.getProperty("os.arch"));
        
        return Result.success(info);
    }
}
