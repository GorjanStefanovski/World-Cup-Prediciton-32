package com.WorldCupApplication.Web.Requests;

// Incoming from the frontend: just the id of the match to predict.
public record PredictionRequest(Long matchId) {
}
