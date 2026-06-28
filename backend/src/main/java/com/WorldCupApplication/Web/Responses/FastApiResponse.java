package com.WorldCupApplication.Web.Responses;


import com.fasterxml.jackson.annotation.JsonProperty;

// The JSON FastAPI returns.
public record FastApiResponse(
        @JsonProperty("home_team") String homeTeam,
        @JsonProperty("away_team") String awayTeam,
        @JsonProperty("predicted_winner") String predictedWinner,
        @JsonProperty("win_probability") Double winProbability,
        @JsonProperty("home_win_probability") Double homeWinProbability
) {
}
