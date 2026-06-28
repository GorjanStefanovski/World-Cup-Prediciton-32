package com.WorldCupApplication.Web.Responses;

import com.fasterxml.jackson.annotation.JsonProperty;

// What we hand back to the frontend: winner + chance as a percentage.
/*
public record PredictionResult(
        String homeTeam,
        String awayTeam,
        String predictedWinner,
        double winPercentage
) {
}
 */
public record PredictionResult(
        @JsonProperty("home_team") String homeTeam,
        @JsonProperty("away_team") String awayTeam,
        @JsonProperty("predicted_winner") String predictedWinner,
        @JsonProperty("win_probability") Double winProbability,
        @JsonProperty("home_win_probability") Double homeWinProbability
) {}
