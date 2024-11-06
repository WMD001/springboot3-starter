package com.xdtech.bzj;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Create by habit on 2024/11/6
 */
@RestController
@RequestMapping("/")
public class Hello {

    @RequestMapping
    public String start() {
        return "bzj start project.";
    }

}
