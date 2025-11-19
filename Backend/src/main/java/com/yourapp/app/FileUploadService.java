package com.yourapp.app;

import com.google.cloud.storage.Bucket;
import com.google.firebase.cloud.StorageClient;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
public class FileUploadService {

    public String uploadFile(MultipartFile file) throws IOException {

        // Generate a unique name for each uploaded image
        String fileName = UUID.randomUUID().toString() + ".jpg";

        // Firebase storage bucket (auto detected from FirebaseConfig)
        Bucket bucket = StorageClient.getInstance().bucket();

        // Upload file to Firebase Storage
        bucket.create(fileName, file.getInputStream(), file.getContentType());

        // Return public URL (requires Firebase rules to allow read access)
        return "https://storage.googleapis.com/"
                + bucket.getName() + "/"
                + fileName;
    }
}
