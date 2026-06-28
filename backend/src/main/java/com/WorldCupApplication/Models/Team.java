package com.WorldCupApplication.Models;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Table(name = "teams")
public class Team {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 50)
    private String name;

    @Column(nullable = false, length = 20)
    private String confederation;

    @Column(name = "still_in_tournament", nullable = false)
    private Boolean stillInTournament = true;

    @Column(nullable = false)
    private Integer fifaRank;

    @Column(name = "fifa_points",nullable = false)
    private Double points;

    @Column(name = "rest_days")
    private Integer restDays = 0;

    @Column(name = "team_form")
    private Double teamForm = 0.0;

    @Column(name = "last_formation", length = 20)
    private String lastFormation;
}
