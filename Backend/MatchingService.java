// src/main/java/com/yourapp/app/MatchingService.java
package com.yourapp.app;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ExecutionException;

@Service
public class MatchingService {

    @Autowired
    private FirestoreService firestoreService;

    public List<MatchResult> computeMatchJob()
            throws ExecutionException, InterruptedException {
        return computeMatches(0.35);
    }

    public List<MatchResult> computeMatches(double threshold)
            throws ExecutionException, InterruptedException {

        List<LostTicket> lostList = firestoreService.getAllLost();
        List<FoundTicket> foundList = firestoreService.getAllFound();

        List<MatchResult> results = new ArrayList<>();

        for (LostTicket lost : lostList) {
            if (!"active".equalsIgnoreCase(lost.getStatus())) continue;

            for (FoundTicket found : foundList) {
                if (!"active".equalsIgnoreCase(found.getStatus())) continue;

                double score = similarity(lost, found);
                if (score >= threshold) {
                    MatchResult r = new MatchResult(
                            lost.getId(),
                            found.getId(),
                            lost.getTitle(),
                            found.getTitle(),
                            score
                    );
                    r.setLostContact(lost.getContact());
                    r.setFoundContact(found.getContact());
                    results.add(r);
                }
            }
        }

        results.sort((a, b) -> Double.compare(b.getScore(), a.getScore()));
        return results;
    }

    public MatchResult autoMatchFoundTicket(FoundTicket foundTicket)
            throws ExecutionException, InterruptedException {

        List<LostTicket> lostList = firestoreService.getAllLost();

        LostTicket best = null;
        double bestScore = 0.0;

        for (LostTicket lost : lostList) {
            if (!"active".equalsIgnoreCase(lost.getStatus())) continue;

            double score = similarity(lost, foundTicket);
            if (score > bestScore) {
                bestScore = score;
                best = lost;
            }
        }

        if (best != null && bestScore >= 0.35) {
            System.out.println("🔍 Auto-match for new FOUND ticket");
            System.out.println("   Found: " + foundTicket.getId() + " / " + safe(foundTicket.getTitle()));
            System.out.println("   Lost : " + best.getId() + " / " + safe(best.getTitle()));
            System.out.println("   Score: " + bestScore);

            createNotifications(best, foundTicket, bestScore);

            MatchResult r = new MatchResult(
                    best.getId(),
                    foundTicket.getId(),
                    best.getTitle(),
                    foundTicket.getTitle(),
                    bestScore
            );
            r.setLostContact(best.getContact());
            r.setFoundContact(foundTicket.getContact());
            return r;
        } else {
            System.out.println("No strong match for found ticket " + foundTicket.getId());
            return null;
        }
    }

    public MatchResult autoMatchLostTicket(LostTicket lostTicket)
            throws ExecutionException, InterruptedException {

        List<FoundTicket> foundList = firestoreService.getAllFound();

        FoundTicket best = null;
        double bestScore = 0.0;

        for (FoundTicket found : foundList) {
            if (!"active".equalsIgnoreCase(found.getStatus())) continue;

            double score = similarity(lostTicket, found);
            if (score > bestScore) {
                bestScore = score;
                best = found;
            }
        }

        if (best != null && bestScore >= 0.35) {
            System.out.println("🔍 Auto-match for new LOST ticket");
            System.out.println("   Lost : " + lostTicket.getId() + " / " + safe(lostTicket.getTitle()));
            System.out.println("   Found: " + best.getId() + " / " + safe(best.getTitle()));
            System.out.println("   Score: " + bestScore);

            createNotifications(lostTicket, best, bestScore);

            MatchResult r = new MatchResult(
                    lostTicket.getId(),
                    best.getId(),
                    lostTicket.getTitle(),
                    best.getTitle(),
                    bestScore
            );
            r.setLostContact(lostTicket.getContact());
            r.setFoundContact(best.getContact());
            return r;
        } else {
            System.out.println("No strong match for lost ticket " + lostTicket.getId());
            return null;
        }
    }

    private void createNotifications(LostTicket lost,
                                     FoundTicket found,
                                     double score)
            throws ExecutionException, InterruptedException {

        if (lost.getContact() != null && !lost.getContact().isEmpty()) {
            UserNotification nLost = new UserNotification();
            nLost.setContact(lost.getContact());
            nLost.setOtherContact(found.getContact());
            nLost.setLostId(lost.getId());
            nLost.setFoundId(found.getId());
            nLost.setLostTitle(lost.getTitle());
            nLost.setFoundTitle(found.getTitle());
            nLost.setScore(score);
            nLost.setMessage("Possible match for your lost item \"" +
                    safe(lost.getTitle()) + "\".");
            firestoreService.saveNotification(nLost);
        }

        if (found.getContact() != null && !found.getContact().isEmpty()) {
            UserNotification nFound = new UserNotification();
            nFound.setContact(found.getContact());
            nFound.setOtherContact(lost.getContact());
            nFound.setLostId(lost.getId());
            nFound.setFoundId(found.getId());
            nFound.setLostTitle(lost.getTitle());
            nFound.setFoundTitle(found.getTitle());
            nFound.setScore(score);
            nFound.setMessage("Possible owner for the item \"" +
                    safe(found.getTitle()) + "\".");
            firestoreService.saveNotification(nFound);
        }
    }

    private double similarity(LostTicket lost, FoundTicket found) {
        String lostText = (safe(lost.getTitle()) + " "
                + safe(lost.getCategory()) + " "
                + safe(lost.getDescription()) + " "
                + safe(lost.getCity())).toLowerCase();

        String foundText = (safe(found.getTitle()) + " "
                + safe(found.getCategory()) + " "
                + safe(found.getDescription()) + " "
                + safe(found.getCity())).toLowerCase();

        Set<String> lostWords  = new HashSet<>(Arrays.asList(lostText.split("\\s+")));
        Set<String> foundWords = new HashSet<>(Arrays.asList(foundText.split("\\s+")));

        lostWords.removeIf(String::isEmpty);
        foundWords.removeIf(String::isEmpty);

        if (lostWords.isEmpty() || foundWords.isEmpty()) return 0.0;

        int common = 0;
        for (String w : lostWords) {
            if (foundWords.contains(w)) common++;
        }

        int union = lostWords.size() + foundWords.size() - common;
        return union == 0 ? 0.0 : (double) common / union;
    }

    private String safe(String s) {
        return s == null ? "" : s;
    }
}
