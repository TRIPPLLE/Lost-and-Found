// src/main/java/com/yourapp/app/FirestoreService.java
package com.yourapp.app;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class FirestoreService {

    // Helper: always get Firestore from Firebase SDK
    private Firestore db() {
        return FirestoreClient.getFirestore();
    }

    // ================= LOST =================

    public String saveLostTicket(LostTicket ticket) throws ExecutionException, InterruptedException {
        CollectionReference col = db().collection("lostTickets");
        DocumentReference doc = (ticket.getId() == null || ticket.getId().isEmpty())
                ? col.document()
                : col.document(ticket.getId());

        ticket.setId(doc.getId());
        ApiFuture<WriteResult> write = doc.set(ticket);
        write.get();  // wait for completion (or handle asynchronously if you want)
        return doc.getId();
    }

    public List<LostTicket> getAllLost() throws ExecutionException, InterruptedException {
        List<LostTicket> list = new ArrayList<>();
        ApiFuture<QuerySnapshot> future = db().collection("lostTickets").get();

        for (DocumentSnapshot snap : future.get().getDocuments()) {
            LostTicket t = snap.toObject(LostTicket.class);
            if (t != null) {
                t.setId(snap.getId());
                list.add(t);
            }
        }
        return list;
    }

    // ================= FOUND =================

    public String saveFoundTicket(FoundTicket ticket) throws ExecutionException, InterruptedException {
        CollectionReference col = db().collection("foundTickets");
        DocumentReference doc = (ticket.getId() == null || ticket.getId().isEmpty())
                ? col.document()
                : col.document(ticket.getId());

        ticket.setId(doc.getId());
        ApiFuture<WriteResult> write = doc.set(ticket);
        write.get();
        return doc.getId();
    }

    public List<FoundTicket> getAllFound() throws ExecutionException, InterruptedException {
        List<FoundTicket> list = new ArrayList<>();
        ApiFuture<QuerySnapshot> future = db().collection("foundTickets").get();

        for (DocumentSnapshot snap : future.get().getDocuments()) {
            FoundTicket t = snap.toObject(FoundTicket.class);
            if (t != null) {
                t.setId(snap.getId());
                list.add(t);
            }
        }
        return list;
    }

    // ================= NOTIFICATIONS =================

    public void saveNotification(UserNotification notification)
            throws ExecutionException, InterruptedException {

        CollectionReference col = db().collection("notifications");
        DocumentReference doc = (notification.getId() == null || notification.getId().isEmpty())
                ? col.document()
                : col.document(notification.getId());

        notification.setId(doc.getId());
         System.out.println(
        "👉 Saving notification for contact=" + notification.getContact() +
        " otherContact=" + notification.getOtherContact() +
        " lostId=" + notification.getLostId() +
        " foundId=" + notification.getFoundId()
    );
        ApiFuture<WriteResult> write = doc.set(notification);
        write.get();
    }

    public List<UserNotification> getNotificationsForContact(String contact)
            throws ExecutionException, InterruptedException {

        List<UserNotification> list = new ArrayList<>();
        CollectionReference col = db().collection("notifications");

        ApiFuture<QuerySnapshot> future = col
                .whereEqualTo("contact", contact)
                .orderBy("createdAt", Query.Direction.DESCENDING)
                .get();

        for (DocumentSnapshot snap : future.get().getDocuments()) {
            UserNotification n = snap.toObject(UserNotification.class);
            if (n != null) {
                n.setId(snap.getId());
                list.add(n);
            }
        }
        return list;
    }
}
