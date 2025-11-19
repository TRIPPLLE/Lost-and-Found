package com.yourapp.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class TicketQueryController {

    @Autowired
    private FirestoreService firestoreService;

    @GetMapping("/lost")
    public ResponseEntity<?> getAllLost() {
        try {
            List<LostTicket> lost = firestoreService.getAllLost();
            return ResponseEntity.ok(lost);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body(new ApiResponse(false, "Failed to fetch lost tickets", null));
        }
    }

    @GetMapping("/found")
    public ResponseEntity<?> getAllFound() {
        try {
            List<FoundTicket> found = firestoreService.getAllFound();
            return ResponseEntity.ok(found);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body(new ApiResponse(false, "Failed to fetch found tickets", null));
        }
    }
}
