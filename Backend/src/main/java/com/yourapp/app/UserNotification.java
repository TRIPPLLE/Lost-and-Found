// src/main/java/com/yourapp/app/UserNotification.java
package com.yourapp.app;

import java.util.Date;

public class UserNotification {

    private String id;
    private String contact;          // current user (who receives this notification)
    private String otherContact;     // 🔥 the other person's number/email
    private String lostId;
    private String foundId;
    private String lostTitle;
    private String foundTitle;
    private double score;
    private String message;
    private Date createdAt;

    public UserNotification() {
        this.createdAt = new Date();
    }

    // ----- getters & setters -----

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getOtherContact() { return otherContact; }
    public void setOtherContact(String otherContact) { this.otherContact = otherContact; }

    public String getLostId() { return lostId; }
    public void setLostId(String lostId) { this.lostId = lostId; }

    public String getFoundId() { return foundId; }
    public void setFoundId(String foundId) { this.foundId = foundId; }

    public String getLostTitle() { return lostTitle; }
    public void setLostTitle(String lostTitle) { this.lostTitle = lostTitle; }

    public String getFoundTitle() { return foundTitle; }
    public void setFoundTitle(String foundTitle) { this.foundTitle = foundTitle; }

    public double getScore() { return score; }
    public void setScore(double score) { this.score = score; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
