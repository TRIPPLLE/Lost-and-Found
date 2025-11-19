package com.yourapp.app;

import java.util.ArrayList;
import java.util.List;

public class FoundTicket {

    private String id;
    private String title;
    private String category;
    private String description;
    private String city;
    private String dateFound;
    private String userId;                 // Flutter's "contact" maps here
    private List<String> imageUrls = new ArrayList<>();
    private String status = "active";
    private String matchedWith = null;

    // ---- getters / setters ----

    public String getId() { 
        return id; 
    }

    public void setId(String id) { 
        this.id = id; 
    }

    public String getTitle() { 
        return title; 
    }

    public void setTitle(String title) { 
        this.title = title; 
    }

    public String getCategory() { 
        return category; 
    }

    public void setCategory(String category) { 
        this.category = category; 
    }

    public String getDescription() { 
        return description; 
    }

    public void setDescription(String description) { 
        this.description = description; 
    }

    public String getCity() { 
        return city; 
    }

    public void setCity(String city) { 
        this.city = city; 
    }

    public String getDateFound() { 
        return dateFound; 
    }

    public void setDateFound(String dateFound) { 
        this.dateFound = dateFound; 
    }

    public String getUserId() { 
        return userId; 
    }

    public void setUserId(String userId) { 
        this.userId = userId; 
    }

    // 🔥 IMPORTANT FIX: alias for Flutter field "contact"
    public String getContact() {
        return userId;
    }

    public void setContact(String contact) {
        this.userId = contact;
    }

    public List<String> getImageUrls() { 
        return imageUrls; 
    }

    public void setImageUrls(List<String> imageUrls) { 
        this.imageUrls = imageUrls; 
    }

    public String getStatus() { 
        return status; 
    }

    public void setStatus(String status) { 
        this.status = status; 
    }

    public String getMatchedWith() { 
        return matchedWith; 
    }

    public void setMatchedWith(String matchedWith) { 
        this.matchedWith = matchedWith; 
    }
}
