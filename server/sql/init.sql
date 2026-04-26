-- EVA 管理系统数据库初始化脚本
-- 创建数据库
CREATE DATABASE IF NOT EXISTS eva_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE eva_db;

-- 用户表
CREATE TABLE IF NOT EXISTS `user` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `username` VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    `password` VARCHAR(255) NOT NULL COMMENT '密码',
    `email` VARCHAR(100) COMMENT '邮箱',
    `phone` VARCHAR(20) COMMENT '手机号',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 插入测试数据
INSERT INTO `user` (`username`, `password`, `email`, `phone`) VALUES
('admin', 'admin123', 'admin@eva.com', '13800138000'),
('test', 'test123', 'test@eva.com', '13800138001');
