package com.eva.server.controller;

import com.eva.server.common.Result;
import com.eva.server.entity.User;
import com.eva.server.service.UserService;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * 用户控制器
 */
@RestController
@RequestMapping("/users")
public class UserController {
    
    private final UserService userService;
    
    public UserController(UserService userService) {
        this.userService = userService;
    }
    
    @GetMapping
    public Result<List<User>> getAllUsers() {
        return Result.success(userService.getAllUsers());
    }
    
    @GetMapping("/{id}")
    public Result<User> getUserById(@PathVariable Long id) {
        return Result.success(userService.getUserById(id));
    }
    
    @PostMapping
    public Result<User> createUser(@RequestBody User user) {
        return Result.success(userService.createUser(user));
    }
    
    @PutMapping("/{id}")
    public Result<User> updateUser(@PathVariable Long id, @RequestBody User user) {
        return Result.success(userService.updateUser(id, user));
    }
    
    @DeleteMapping("/{id}")
    public Result<Void> deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
        return Result.success();
    }
}
