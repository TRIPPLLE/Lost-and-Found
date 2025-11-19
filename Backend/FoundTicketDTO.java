package com.yourapp.app;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;

import java.util.List;

@Data
public class FoundTicketDTO {

    @NotBlank
    private String userId;

    @NotBlank
    private String category;

    @NotBlank
    private String description;

    @NotBlank
    private String city;

    @NotBlank
    private String dateFound;

    private List<String> imageUrls;  // optional
}
