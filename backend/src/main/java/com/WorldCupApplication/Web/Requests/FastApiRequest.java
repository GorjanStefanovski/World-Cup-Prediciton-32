package com.WorldCupApplication.Web.Requests;


import com.WorldCupApplication.Models.DTO.TeamPayload;
import com.fasterxml.jackson.annotation.JsonProperty;

// The exact JSON body POSTed to FastAPI /predict.
public record FastApiRequest(
        @JsonProperty("home_team") TeamPayload home_team,
        @JsonProperty("away_team") TeamPayload away_team,
        String round,
        String venue
) {
}