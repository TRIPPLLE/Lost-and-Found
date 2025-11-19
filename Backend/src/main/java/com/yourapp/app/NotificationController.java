// src/main/java/com/yourapp/app/NotificationController.java
package com.yourapp.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api")
public class NotificationController {

    @Autowired
    private FirestoreService firestoreService;

    @GetMapping("/notifications/{contact}")
    public List<UserNotification> getNotifications(
            @PathVariable("contact") String contact
    ) throws ExecutionException, InterruptedException {

        return firestoreService.getNotificationsForContact(contact);
    }
}
