package com.WorldCupApplication.Repository;

import com.WorldCupApplication.Models.AppUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<AppUser,Long> {

    boolean existsByEmail(String email);

    boolean existsByUsername(String username);

    Optional<AppUser> findByEmailAndPassword(String email, String password);
}
