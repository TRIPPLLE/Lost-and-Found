// src/main/java/com/yourapp/app/FirebaseConfig.java
package com.yourapp.app;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.InputStream;

@Configuration
public class FirebaseConfig {

    @PostConstruct
    public void initFirebase() throws Exception {
        if (!FirebaseApp.getApps().isEmpty()) {
            return; // already initialized
        }

        InputStream serviceAccount =
                new ClassPathResource("google-service.json").getInputStream();

        FirebaseOptions options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                .build();

        FirebaseApp.initializeApp(options);
        System.out.println("🔥 Firebase initialized (DEFAULT app)");
    }
}

