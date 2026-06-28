package com.WorldCupApplication.Service;

import com.WorldCupApplication.Models.DTO.TeamPayload;
import com.WorldCupApplication.Models.Match;
import com.WorldCupApplication.Models.Team;
import com.WorldCupApplication.Repository.MatchRepository;
import com.WorldCupApplication.Web.Requests.FastApiRequest;
import com.WorldCupApplication.Web.Responses.FastApiResponse;
import com.WorldCupApplication.Web.Responses.MatchResponse;
import com.WorldCupApplication.Web.Responses.PredictionResult;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@Service
public class PredictionService {

    private final MatchRepository matchRepository;
    private final RestTemplate restTemplate = new RestTemplate();

    // Read from application.properties -> fastapi.url, which itself reads the
    // FASTAPI_URL env var (set to http://ml-service:8000 in docker-compose).
    @Value("${fastapi.url}")
    private String fastApiUrl;

    public PredictionService(MatchRepository matchRepository) {
        this.matchRepository = matchRepository;
    }

    // Used by GET /api/matches to populate the frontend list.
    public List<MatchResponse> getMatches() {
        return matchRepository.findAll().stream()
                .map(m -> new MatchResponse(
                        m.getId(),
                        m.getHomeTeam().getName(),
                        m.getAwayTeam().getName(),
                        m.getRound(),
                        m.getDate()))
                .toList();
    }

    // Used by POST /api/predict.
    public PredictionResult predict(Long matchId) {
        Match match = matchRepository.findById(matchId)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Match not found: " + matchId));

        FastApiRequest payload = new FastApiRequest(
                toPayload(match.getHomeTeam()),
                toPayload(match.getAwayTeam()),
                match.getRound(),   // "Round of 32" -> FastAPI maps to weight 5
                "Neutral"           // fixed: Match.venue holds a stadium name, not H/N/A
        );

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<FastApiRequest> requestEntity = new HttpEntity<>(payload, headers);

        FastApiResponse response;
        try {
            response = restTemplate.postForObject(
                    fastApiUrl + "/predict",
                    requestEntity,
                    FastApiResponse.class
            );
        } catch (RestClientException e) {
            throw new ResponseStatusException(
                    HttpStatus.SERVICE_UNAVAILABLE, "Prediction service is unavailable", e);
        }

        if (response == null) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_GATEWAY, "Empty response from prediction service");
        }

        double percentage = Math.round(response.winProbability() * 1000.0) / 10.0;

        return new PredictionResult(
                response.homeTeam(),
                response.awayTeam(),
                response.predictedWinner(),
                response.winProbability(),
                percentage);
    }

    // Maps our JPA entity (camelCase) to the FastAPI payload (its expected names).
    private TeamPayload toPayload(Team team) {
        return new TeamPayload(
                team.getName(),
                team.getFifaRank(),
                team.getPoints(),
                team.getConfederation(),
                team.getRestDays(),
                team.getTeamForm(),
                team.getLastFormation());
    }
}