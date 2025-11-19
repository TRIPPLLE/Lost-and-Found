package com.yourapp.app;

public class MatchResult {

    private String lostId;
    private String foundId;
    private String lostTitle;
    private String foundTitle;
    private double score;

    // 👇 NEW: contacts that we send back to Flutter
    private String lostContact;
    private String foundContact;

    public MatchResult() {
    }

    public MatchResult(String lostId,
                       String foundId,
                       String lostTitle,
                       String foundTitle,
                       double score) {
        this.lostId = lostId;
        this.foundId = foundId;
        this.lostTitle = lostTitle;
        this.foundTitle = foundTitle;
        this.score = score;
    }

    public String getLostId() {
        return lostId;
    }

    public void setLostId(String lostId) {
        this.lostId = lostId;
    }

    public String getFoundId() {
        return foundId;
    }

    public void setFoundId(String foundId) {
        this.foundId = foundId;
    }

    public String getLostTitle() {
        return lostTitle;
    }

    public void setLostTitle(String lostTitle) {
        this.lostTitle = lostTitle;
    }

    public String getFoundTitle() {
        return foundTitle;
    }

    public void setFoundTitle(String foundTitle) {
        this.foundTitle = foundTitle;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }



    public String getLostContact() {
        return lostContact;
    }

    public void setLostContact(String lostContact) {
        this.lostContact = lostContact;
    }

    public String getFoundContact() {
        return foundContact;
    }

    public void setFoundContact(String foundContact) {
        this.foundContact = foundContact;
    }
}
