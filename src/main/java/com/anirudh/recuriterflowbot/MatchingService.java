
package com.anirudh.recuriterflowbot;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class MatchingService {

    private final JdbcTemplate jdbcTemplate;

    public MatchingService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<Map<String, Object>> findCandidatesForJob(int jobId) {

        List<Map<String, Object>> jobs = jdbcTemplate.queryForList(
                "SELECT id, title, min_experience FROM jobs WHERE id = ?",
                jobId
        );

        if (jobs.isEmpty()) {
            throw new IllegalArgumentException("Job not found: " + jobId);
        }

        Map<String, Object> job = jobs.get(0);
        int minimumExperience = ((Number) job.get("min_experience")).intValue();

        List<String> requiredSkills = jdbcTemplate.queryForList(
                "SELECT skill FROM job_required_skills WHERE job_id = ?",
                String.class,
                jobId
        );

        List<Map<String, Object>> candidates = jdbcTemplate.queryForList(
                "SELECT id, name, experience_years, availability " +
                        "FROM candidates"
        );

        List<Map<String, Object>> results = new ArrayList<>();

        for (Map<String, Object> candidate : candidates) {

            int candidateId =
                    ((Number) candidate.get("id")).intValue();

            int experience =
                    ((Number) candidate.get("experience_years")).intValue();

            List<String> candidateSkills = jdbcTemplate.queryForList(
                    "SELECT skill FROM candidate_skills WHERE candidate_id = ?",
                    String.class,
                    candidateId
            );

            Set<String> candidateSkillSet = new HashSet<>(candidateSkills);

            List<String> matchedSkills = new ArrayList<>();
            List<String> missingSkills = new ArrayList<>();

            for (String skill : requiredSkills) {
                if (candidateSkillSet.contains(skill)) {
                    matchedSkills.add(skill);
                } else {
                    missingSkills.add(skill);
                }
            }

            double skillScore = requiredSkills.isEmpty()
                    ? 0.0
                    : 100.0 * matchedSkills.size() / requiredSkills.size();

            double experienceScore = minimumExperience <= 0
                    ? 100.0
                    : Math.min(100.0,
                    100.0 * experience / minimumExperience);

            double matchScore =
                    0.70 * skillScore + 0.30 * experienceScore;

            Map<String, Object> result = new java.util.LinkedHashMap<>();
            result.put("candidateId", candidateId);
            result.put("candidateName", candidate.get("name"));
            result.put("experienceYears", experience);
            result.put("availability", candidate.get("availability"));
            result.put("matchedSkills", matchedSkills);
            result.put("missingSkills", missingSkills);
            result.put("skillScore", Math.round(skillScore * 100.0) / 100.0);
            result.put("experienceScore",
                    Math.round(experienceScore * 100.0) / 100.0);
            result.put("matchScore", Math.round(matchScore * 100.0) / 100.0);

            results.add(result);
        }

        results.sort(
                Comparator.comparingDouble(
                        (Map<String, Object> result) ->
                                ((Number) result.get("matchScore")).doubleValue()
                ).reversed()
        );

        return results;
    }


    public List<Map<String, Object>> findJobsForCandidate(int candidateId) {

        List<Map<String, Object>> candidates = jdbcTemplate.queryForList(
                "SELECT id, name, experience_years FROM candidates WHERE id = ?",
                candidateId
        );

        if (candidates.isEmpty()) {
            throw new IllegalArgumentException(
                    "Candidate not found: " + candidateId
            );
        }

        Map<String, Object> candidate = candidates.get(0);

        int experience =
                ((Number) candidate.get("experience_years")).intValue();

        List<String> candidateSkills = jdbcTemplate.queryForList(
                "SELECT skill FROM candidate_skills WHERE candidate_id = ?",
                String.class,
                candidateId
        );

        Set<String> candidateSkillSet = new HashSet<>(candidateSkills);

        List<Map<String, Object>> jobs = jdbcTemplate.queryForList(
                "SELECT id, title, min_experience FROM jobs"
        );

        List<Map<String, Object>> results = new ArrayList<>();

        for (Map<String, Object> job : jobs) {

            int jobId = ((Number) job.get("id")).intValue();
            int minimumExperience =
                    ((Number) job.get("min_experience")).intValue();

            List<String> requiredSkills = jdbcTemplate.queryForList(
                    "SELECT skill FROM job_required_skills WHERE job_id = ?",
                    String.class,
                    jobId
            );

            List<String> matchedSkills = new ArrayList<>();
            List<String> missingSkills = new ArrayList<>();

            for (String skill : requiredSkills) {
                if (candidateSkillSet.contains(skill)) {
                    matchedSkills.add(skill);
                } else {
                    missingSkills.add(skill);
                }
            }

            double skillScore = requiredSkills.isEmpty()
                    ? 0.0
                    : 100.0 * matchedSkills.size() / requiredSkills.size();

            double experienceScore = minimumExperience <= 0
                    ? 100.0
                    : Math.min(100.0,
                    100.0 * experience / minimumExperience);

            double matchScore =
                    0.70 * skillScore + 0.30 * experienceScore;

            Map<String, Object> result = new java.util.LinkedHashMap<>();
            result.put("jobId", jobId);
            result.put("jobTitle", job.get("title"));
            result.put("minimumExperience", minimumExperience);
            result.put("matchedSkills", matchedSkills);
            result.put("missingSkills", missingSkills);
            result.put("skillScore", Math.round(skillScore * 100.0) / 100.0);
            result.put("experienceScore",
                    Math.round(experienceScore * 100.0) / 100.0);
            result.put("matchScore", Math.round(matchScore * 100.0) / 100.0);

            results.add(result);
        }

        results.sort(
                Comparator.comparingDouble(
                        (Map<String, Object> result) ->
                                ((Number) result.get("matchScore")).doubleValue()
                ).reversed()
        );

        return results;
    }

}
