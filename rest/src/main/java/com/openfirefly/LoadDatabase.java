package com.openfirefly;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.logging.Logger;

@Configuration
public class LoadDatabase {
    private static final Logger log = Logger.getLogger(LoadDatabase.class.getName());

    @Bean
    CommandLineRunner initDatabase(EmployeeRepository repository){

        return args -> {
            log.info("Preloading " + repository.save(new Employee("John Doe", "john@doe.com")));
            log.info("Preloading " + repository.save(new Employee("Jane Doe", "jane@doe.com")));
        };
    }
}
