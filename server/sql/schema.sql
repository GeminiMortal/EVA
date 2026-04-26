-- EVA 管理系统数据库表结构扩展脚本
-- 用于添加新表或修改现有表结构

USE eva_db;

-- ============================================
-- 角色表
-- ============================================
CREATE TABLE IF NOT EXISTS `role` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `role_name` VARCHAR(50) NOT NULL UNIQUE COMMENT '角色名称',
    `role_code` VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    `description` VARCHAR(255) COMMENT '角色描述',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- ============================================
-- 用户角色关联表
-- ============================================
CREATE TABLE IF NOT EXISTS `user_role` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_role` (`user_id`, `role_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- ============================================
-- 菜单/权限表
-- ============================================
CREATE TABLE IF NOT EXISTS `menu` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `parent_id` BIGINT DEFAULT 0 COMMENT '父菜单ID',
    `menu_name` VARCHAR(50) NOT NULL COMMENT '菜单名称',
    `menu_code` VARCHAR(50) COMMENT '菜单编码',
    `menu_type` TINYINT DEFAULT 1 COMMENT '菜单类型：1-目录 2-菜单 3-按钮',
    `path` VARCHAR(200) COMMENT '路由路径',
    `component` VARCHAR(200) COMMENT '组件路径',
    `icon` VARCHAR(50) COMMENT '图标',
    `sort_order` INT DEFAULT 0 COMMENT '排序',
    `visible` TINYINT DEFAULT 1 COMMENT '是否可见：0-隐藏 1-显示',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-禁用 1-启用',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    INDEX `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单权限表';

-- ============================================
-- 角色菜单关联表
-- ============================================
CREATE TABLE IF NOT EXISTS `role_menu` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `role_id` BIGINT NOT NULL COMMENT '角色ID',
    `menu_id` BIGINT NOT NULL COMMENT '菜单ID',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_role_menu` (`role_id`, `menu_id`),
    INDEX `idx_role_id` (`role_id`),
    INDEX `idx_menu_id` (`menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色菜单关联表';

-- ============================================
-- 操作日志表
-- ============================================
CREATE TABLE IF NOT EXISTS `operation_log` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    `user_id` BIGINT COMMENT '操作用户ID',
    `username` VARCHAR(50) COMMENT '操作用户名',
    `operation` VARCHAR(100) COMMENT '操作描述',
    `method` VARCHAR(200) COMMENT '请求方法',
    `params` TEXT COMMENT '请求参数',
    `ip` VARCHAR(50) COMMENT 'IP地址',
    `location` VARCHAR(100) COMMENT '操作地点',
    `status` TINYINT DEFAULT 1 COMMENT '状态：0-失败 1-成功',
    `error_msg` TEXT COMMENT '错误信息',
    `execution_time` BIGINT COMMENT '执行时长（毫秒）',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    PRIMARY KEY (`id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- ============================================
-- 插入初始数据
-- ============================================

-- 插入角色数据
INSERT INTO `role` (`role_name`, `role_code`, `description`) VALUES
('超级管理员', 'ADMIN', '拥有所有权限'),
('普通用户', 'USER', '基本使用权限');

-- 插入菜单数据
INSERT INTO `menu` (`parent_id`, `menu_name`, `menu_code`, `menu_type`, `path`, `component`, `icon`, `sort_order`) VALUES
(0, '系统管理', 'system', 1, '/system', NULL, '⚙️', 1),
(1, '用户管理', 'user', 2, '/system/user', 'views/system/UserView', '👤', 1),
(1, '角色管理', 'role', 2, '/system/role', 'views/system/RoleView', '🔑', 2),
(1, '菜单管理', 'menu', 2, '/system/menu', 'views/system/MenuView', '📋', 3),
(0, '首页', 'home', 2, '/', 'views/home/HomeView', '🏠', 0);
