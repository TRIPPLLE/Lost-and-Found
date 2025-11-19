// src/main/java/com/yourapp/app/FoundJsonController.java
package com.yourapp.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/api")
public class FoundJsonController {

    @Autowired
    private FirestoreService firestoreService;

    @Autowired
    private MatchingService matchingService;

    @PostMapping("/found")
    public ResponseEntity<ApiResponse> createFoundJson(
            @RequestBody FoundTicket ticket
    ) throws ExecutionException, InterruptedException {

        if (ticket.getStatus() == null) {
            ticket.setStatus("active");
        }

        String id = firestoreService.saveFoundTicket(ticket);
        ticket.setId(id);

        MatchResult match = matchingService.autoMatchFoundTicket(ticket);

        String msg = (match != null)
                ? "Found ticket saved. Possible match found."
                : "Found ticket saved. No strong match yet.";

        // match object goes into 'data' → Flutter sees it
        return ResponseEntity.ok(
                new ApiResponse(true, msg, match)
        );
    }
}
