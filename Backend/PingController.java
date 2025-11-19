// src/main/java/com/yourapp/app/controller/PingController.java
package com.yourapp.app;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PingController {

    @GetMapping("/api/ping")
    public String ping() {
        System.out.println(">>>> /api/ping HIT");
        return "pong";
    }
}
