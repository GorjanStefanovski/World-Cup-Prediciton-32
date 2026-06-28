package com.WorldCupApplication.Service;

import com.WorldCupApplication.Models.Team;
import com.WorldCupApplication.Repository.TeamRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class TeamUpdateScheduler {

    private final TeamRepository teamRepository;

    @Scheduled(cron = "0 0 6 * * ?", zone = "Europe/Skopje")
    @Transactional
    public void updateTeamStatistics() {
        log.info("Starting cron job after last game finished");

        List<Team> activeTeams = teamRepository.findAllByStillInTournamentTrue();

        for (Team team : activeTeams) {
            try {
                // ТУКА ЌЕ ДОЈДЕ ЛОГИКАТА КОГА ЌЕ ГО ИМАМЕ MATCH ЕНТИТЕТОТ
                // Пример: team.setRestDays(calculateRestDays(team.getId()));
                // Пример: team.setTeamForm(calculateTeamForm(team.getId()));

                // За сега, ставаме фиктивен апдејт чисто за да видиме дека работи
                team.setRestDays(team.getRestDays() + 1);

                log.info("Успешно ажуриран тимот: {}", team.getName());
            } catch (Exception e) {
                // Ставаме try-catch во циклусот за да не падне целиот job ако има проблем со еден тим
                log.error("Грешка при ажурирање на тимот {}: {}", team.getName(), e.getMessage());
            }
        }

        teamRepository.saveAll(activeTeams);

        log.info("Team update cron job finishes successfully.Number of teams updated are {}.", activeTeams.size());
    }
}
