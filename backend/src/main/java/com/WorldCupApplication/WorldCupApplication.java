package com.WorldCupApplication;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
//We have to add this so that the application will listen for jobs
@EnableScheduling
public class WorldCupApplication {

	public static void main(String[] args) {
		SpringApplication.run(WorldCupApplication.class, args);
	}

}
