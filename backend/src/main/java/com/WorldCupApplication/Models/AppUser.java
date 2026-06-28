package com.WorldCupApplication.Models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "app_user")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class AppUser {

    @SequenceGenerator(name = "id_sequence_user",initialValue = 0,allocationSize = 1)
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO,generator = "id_sequence_user")
    private long ID;

    @Column(unique = true, nullable = false)
    private String username;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    @CreationTimestamp
    private LocalDateTime createdAt;

    //private Double totalScore = 0.0;
}
