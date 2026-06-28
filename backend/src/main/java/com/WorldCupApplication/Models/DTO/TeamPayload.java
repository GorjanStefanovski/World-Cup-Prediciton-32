package com.WorldCupApplication.Models.DTO;

import com.fasterxml.jackson.annotation.JsonProperty;

// One team's raw values, named exactly as the FastAPI service expects (snake_case).
public record TeamPayload(
        String name,
        Integer rank,
        Double points,
        String confederation,
        @JsonProperty("rest_days") Integer restDays,
        Double form,
        String formation
) {
}
