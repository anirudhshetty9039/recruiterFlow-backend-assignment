
package com.anirudh.recuriterflowbot;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping
public class MatchingController {

    private final MatchingService matchingService;

    public MatchingController(MatchingService matchingService) {
        this.matchingService = matchingService;
    }

    @GetMapping("/jobs/{id}/matches")
    public List<Map<String, Object>> getCandidatesForJob(
            @PathVariable("id") int jobId) {
        return matchingService.findCandidatesForJob(jobId);
    }

    @GetMapping("/candidates/{id}/matches")
    public List<Map<String, Object>> getJobsForCandidate(
            @PathVariable("id") int candidateId) {
        return matchingService.findJobsForCandidate(candidateId);
    }



}
