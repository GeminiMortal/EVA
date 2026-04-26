-- EVA 管理系统示例查询 SQL

-- 1. 查询所有用户
SELECT * FROM user;

-- 2. 根据 ID 查询用户
SELECT * FROM user WHERE id = 1;

-- 3. 根据用户名查询用户
SELECT * FROM user WHERE username = 'admin';

-- 4. 分页查询用户（每页 10 条，第 1 页）
SELECT * FROM user ORDER BY create_time DESC LIMIT 0, 10;

-- 5. 统计用户总数
SELECT COUNT(*) as total FROM user;

-- 6. 模糊搜索用户（按用户名或邮箱）
SELECT * FROM user 
WHERE username LIKE '%admin%' 
   OR email LIKE '%admin%';

-- 7. 查询最近创建的用户（最近 7 天）
SELECT * FROM user 
WHERE create_time >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY create_time DESC;

-- 8. 更新用户信息
UPDATE user 
SET email = 'newemail@eva.com', 
    phone = '13900139000'
WHERE id = 1;

-- 9. 删除用户
DELETE FROM user WHERE id = 1;

-- 10. 批量插入用户
INSERT INTO user (username, password, email, phone) VALUES
('user1', 'password1', 'user1@eva.com', '13800138002'),
('user2', 'password2', 'user2@eva.com', '13800138003'),
('user3', 'password3', 'user3@eva.com', '13800138004');
