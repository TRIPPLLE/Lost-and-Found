package com.yourapp.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class LostJsonController {

    @Autowired
    private FirestoreService firestoreService;

    @PostMapping("/lost")
    public ResponseEntity<ApiResponse> createLostTicket(
            @RequestBody LostTicketRequest request) {

        System.out.println("==== New Lost Ticket (JSON) ====");
        System.out.println("Item : " + request.getItemName());
        System.out.println("Cat  : " + request.getCategory());
        System.out.println("Desc : " + request.getDescription());
        System.out.println("Loc  : " + request.getLocation());
        System.out.println("Date : " + request.getLostDate());
        System.out.println("User : " + request.getContact());
        System.out.println("================================");

        try {
            // Convert JSON request → Firestore object
            LostTicket ticket = new LostTicket();
            ticket.setTitle(request.getItemName());
            ticket.setCategory(request.getCategory());
            ticket.setDescription(request.getDescription());
            ticket.setCity(request.getLocation());
            ticket.setDateLost(request.getLostDate());
            ticket.setUserId(request.getContact());

            String id = firestoreService.saveLostTicket(ticket);

            return ResponseEntity.ok(
                new ApiResponse(true, "Saved to Firestore", id)
            );

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body(new ApiResponse(false, "Error saving: " + e.getMessage(), null));
        }
    }
}
