package com.WorldCupApplication.Web.Responses;

import java.time.LocalDateTime;

// Sent to the frontend so it can list the Round of 32 matches.
public record MatchResponse(
        Long id,
        String homeTeam,
        String awayTeam,
        String round,
        LocalDateTime date
) {
}
