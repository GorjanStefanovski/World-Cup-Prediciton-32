package com.WorldCupApplication.Web;
import com.WorldCupApplication.Service.PredictionService;
import com.WorldCupApplication.Web.Requests.PredictionRequest;
import com.WorldCupApplication.Web.Responses.MatchResponse;
import com.WorldCupApplication.Web.Responses.PredictionResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class PredictionController {

    private final PredictionService predictionService;

    public PredictionController(PredictionService predictionService) {
        this.predictionService = predictionService;
    }

    // Frontend lists these before the user picks one.
    @GetMapping("/matches")
    public List<MatchResponse> getMatches() {
        return predictionService.getMatches();
    }

    // Frontend sends { "matchId": 5 }; we return winner + percentage.
    @PostMapping("/predict")
    public PredictionResult predict(@RequestBody PredictionRequest request) {
        return predictionService.predict(request.matchId());
    }
}
