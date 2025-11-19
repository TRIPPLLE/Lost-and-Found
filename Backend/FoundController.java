// src/main/java/com/yourapp/app/FoundController.java
package com.yourapp.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/found")
public class FoundController {

    @Autowired
    private FirestoreService firestoreService;

    @Autowired
    private FileUploadService fileUploadService;

    @Autowired
    private MatchingService matchingService;   // 👈

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> createFound(
            @RequestPart("data") FoundTicket ticket,
            @RequestPart(value = "images", required = false) MultipartFile[] files
    ) throws Exception {

        List<String> urls = new ArrayList<>();
        if (files != null) {
            for (MultipartFile f : files) {
                urls.add(fileUploadService.uploadFile(f));
            }
        }
        ticket.setImageUrls(urls);

        // save in Firestore
        String id = firestoreService.saveFoundTicket(ticket);
        ticket.setId(id);

        // 🔥 run auto–matching (this will create notifications)
        matchingService.autoMatchFoundTicket(ticket);

        return ResponseEntity.ok("Found ticket created with ID: " + id);
    }
}
