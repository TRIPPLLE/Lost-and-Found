package com.yourapp.app;

public class FoundTicketRequest {

    private String itemName;
    private String category;
    private String description;
    private String location;
    private String foundDate;
    private String contact;

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getFoundDate() { return foundDate; }
    public void setFoundDate(String foundDate) { this.foundDate = foundDate; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
}
