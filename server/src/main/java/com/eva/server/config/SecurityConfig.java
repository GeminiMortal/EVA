package com.eva.server.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Spring Security 配置
 * 适配 Java 21 + Spring Boot 3.4
 */
@Configuration
@EnableWebSecurity
@Order(1)  // 确保此配置优先加载
public class SecurityConfig {

    private static final Logger log = LoggerFactory.getLogger(SecurityConfig.class);

    /**
     * 配置安全过滤链
     */
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        log.info("=== 开始配置 SecurityFilterChain ===");
        
        http
            // 配置 CORS - 必须在 CSRF 之前
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            
            // 禁用 CSRF（使用 JWT 不需要）
            .csrf(csrf -> {
                csrf.disable();
                log.info("CSRF 已禁用");
            })
            
            // 配置会话管理（无状态）
            .sessionManagement(session -> {
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS);
                log.info("会话管理策略: STATELESS");
            })
            
            // 配置异常处理
            .exceptionHandling(exception -> {
                exception.authenticationEntryPoint((request, response, authException) -> {
                    log.warn("⚠️ 未认证访问: {} - Method: {}", request.getRequestURI(), request.getMethod());
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"code\":401,\"message\":\"未认证\",\"data\":null}");
                });
                exception.accessDeniedHandler((request, response, accessDeniedException) -> {
                    log.warn("⚠️ 拒绝访问: {} - {}", request.getRequestURI(), accessDeniedException.getMessage());
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"code\":403,\"message\":\"拒绝访问\",\"data\":null}");
                });
                log.info("异常处理配置完成");
            })
            
            // 配置授权规则 - 必须在最后
            .authorizeHttpRequests(auth -> {
                log.info("📋 配置授权规则...");
                
                // 允许所有 OPTIONS 请求（CORS 预检）
                auth.requestMatchers(org.springframework.http.HttpMethod.OPTIONS, "/**").permitAll();
                
                // 公开接口 - 不需要认证
                auth.requestMatchers("/auth/**").permitAll();
                log.info("✅ /api/auth/** - 允许匿名访问");

                auth.requestMatchers("/system/**").permitAll();
                log.info("✅ /api/system/** - 允许匿名访问");

                auth.requestMatchers("/actuator/**").permitAll();
                log.info("✅ /api/actuator/** - 允许匿名访问");
                
                // 其他所有请求需要认证
                auth.anyRequest().authenticated();
                log.info("✅ 其他请求 - 需要认证");
            });

        SecurityFilterChain filterChain = http.build();
        log.info("=== SecurityFilterChain 配置完成 ===");
        return filterChain;
    }

    /**
     * 配置 CORS
     */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        
        // 允许前端地址访问(端口 8080)
        configuration.setAllowedOrigins(List.of("http://localhost:8080", "http://127.0.0.1:8080"));
        
        // 允许的 HTTP 方法
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
        
        // 允许的请求头
        configuration.setAllowedHeaders(List.of("*"));
        
        // 允许携带凭证(cookies、authorization headers等)
        configuration.setAllowCredentials(true);
        
        // 预检请求缓存时间(秒)
        configuration.setMaxAge(3600L);
        
        // 暴露响应头，让前端可以读取
        configuration.setExposedHeaders(List.of("Authorization", "Content-Type", "X-Requested-With"));

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        
        log.info("🌐 CORS 配置完成:");
        log.info("   - Origins: {}", configuration.getAllowedOrigins());
        log.info("   - Methods: {}", configuration.getAllowedMethods());
        log.info("   - AllowCredentials: {}", configuration.getAllowCredentials());
        
        return source;
    }
}
