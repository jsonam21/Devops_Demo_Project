package com.example.springboot_app.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/")
    public String hello() {
        return "Hello from DevOps Portfolio Project!";
    }

    @GetMapping("/health")
    public String health() {
        return "Application is healthy";
    }
}