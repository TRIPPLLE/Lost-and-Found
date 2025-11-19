package com.yourapp.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/lost")
public class LostController {

    @Autowired
    private FirestoreService firestoreService;

    @Autowired
    private FileUploadService fileUploadService;

    @PostMapping(value = "/create", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> createLost(
            @RequestPart("data") LostTicket ticket,
            @RequestPart("images") MultipartFile[] files) throws Exception {

        // upload all images
        List<String> urls = new ArrayList<>();
        for (MultipartFile f : files) {
            urls.add(fileUploadService.uploadFile(f));
        }
        ticket.setImageUrls(urls);  

        // save in Firestore
        firestoreService.saveLostTicket(ticket);

        return ResponseEntity.ok("Lost ticket created");
    }
}
