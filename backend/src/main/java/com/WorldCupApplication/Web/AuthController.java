package com.WorldCupApplication.Web;

import com.WorldCupApplication.Models.AppUser;
import com.WorldCupApplication.Repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UserRepository userRepository;

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody AppUser requestUser) {

        if (userRepository.existsByEmail(requestUser.getEmail())) {
            return ResponseEntity.badRequest().body("Email already exist!");
        }

        if (userRepository.existsByUsername(requestUser.getUsername())) {
            return ResponseEntity.badRequest().body("This username is taken!");
        }

        AppUser newUser = new AppUser();
        newUser.setUsername(requestUser.getUsername());
        newUser.setEmail(requestUser.getEmail());
        newUser.setPassword(requestUser.getPassword());

        userRepository.save(newUser);

        return ResponseEntity.ok("Successful registration");
    }

    @PostMapping("/login")
    public ResponseEntity<Long> login(@RequestBody AppUser loginRequest) {

        return userRepository.findByEmailAndPassword(loginRequest.getEmail(), loginRequest.getPassword())
                .map(user -> ResponseEntity.ok(user.getID()))
                .orElse(ResponseEntity.status(401).build());
    }
}