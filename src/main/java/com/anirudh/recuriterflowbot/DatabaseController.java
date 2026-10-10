
package com.anirudh.recuriterflowbot;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class DatabaseController {

    private final JdbcTemplate jdbcTemplate;

    public DatabaseController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/api/health")
    public Map<String, Object> health() {
        Integer candidateCount = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM candidates",
                Integer.class
        );

        return Map.of(
                "status", "UP",
                "database", "connected",
                "candidateCount", candidateCount
        );
    }
}
