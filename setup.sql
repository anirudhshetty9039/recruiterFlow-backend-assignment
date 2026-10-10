-- RecruiterFlow Backend Assignment
-- Part 1: Database schema and seed data
-- WARNING: This script drops and recreates the recruiter_bot database.

CREATE DATABASE IF NOT EXISTS recruiter_bot;
USE recruiter_bot;

-- Drop tables in dependency order so the script can be rerun.
DROP TABLE IF EXISTS candidate_skills;
DROP TABLE IF EXISTS job_required_skills;
DROP TABLE IF EXISTS candidates;
DROP TABLE IF EXISTS jobs;

-- 1. Candidates
CREATE TABLE candidates (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    experience_years INT NOT NULL,
    availability VARCHAR(50) NOT NULL,
    traits VARCHAR(255),
    quirk TEXT
);

-- 2. Jobs
CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    min_experience INT NOT NULL,
    culture_keywords VARCHAR(255),
    tagline TEXT
);

-- 3. Candidate skills
CREATE TABLE candidate_skills (
    candidate_id INT NOT NULL,
    skill VARCHAR(100) NOT NULL,
    PRIMARY KEY (candidate_id, skill),
    FOREIGN KEY (candidate_id) REFERENCES candidates(id)
);

-- 4. Required skills for each job
CREATE TABLE job_required_skills (
    job_id INT NOT NULL,
    skill VARCHAR(100) NOT NULL,
    PRIMARY KEY (job_id, skill),
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);

-- Seed candidates
INSERT INTO candidates
    (id, name, experience_years, availability, traits, quirk)
VALUES
(1, 'Sherlock H.', 8, 'Immediate',
 'analytical, blunt',
 'Solves problems by eliminating the impossible; occasionally insufferable in standups.'),

(2, 'Hermione G.', 4, '2 weeks',
 'detail-oriented, overachiever',
 'Reads the entire documentation before writing a single line of code.'),

(3, 'Tony S.', 12, 'Not looking',
 'confident, innovative',
 'Ships an MVP overnight, refuses to write tests.'),

(4, 'Leslie K.', 6, 'Immediate',
 'tenacious, organized',
 'Has a binder for everything, including the binder.'),

(5, 'Ron S.', 15, 'Not looking',
 'stubborn, principled',
 'Refuses to use more than one monitor.'),

(6, 'Rick S.', 20, 'Immediate',
 'genius, reckless',
 'Solution works, mechanism deeply concerning.'),

(7, 'Elle W.', 3, 'Immediate',
 'optimistic, sharp',
 'Underestimated in every standup, correct in every retro.'),

(8, 'MacGyver', 10, '2 weeks',
 'calm, improviser',
 'Fixes production outages with duct tape and a paperclip metaphor.'),

(9, 'Sheldon C.', 9, 'Immediate',
 'rigid, brilliant',
 'Correct 95% of the time, insufferable 100% of the time.'),

(10, 'Katniss E.', 5, 'Immediate',
 'resilient, decisive',
 'Excellent under pressure, terrible with public speaking.'),

(11, 'Michael S.', 11, 'Not looking',
 'enthusiastic, chaotic',
 'World''s best boss, according to a mug he bought himself.'),

(12, 'Olivia P.', 13, '2 weeks',
 'decisive, intense',
 'Handles it. Whatever it is.'),

(13, 'Ted L.', 7, 'Immediate',
 'empathetic, persistent',
 'Turns every technical setback into a folksy metaphor.'),

(14, 'Miranda P.', 18, 'Not looking',
 'demanding, decisive',
 'Reviews every PR personally. Says nothing. Everyone panics.'),

(15, 'Dwight S.', 9, 'Immediate',
 'intense, loyal',
 'Assistant to the regional backend engineer.');

-- Seed jobs
INSERT INTO jobs
    (id, title, min_experience, culture_keywords, tagline)
VALUES
(1, 'Backend Detective', 3,
 'analytical, autonomous',
 'We have a bug. We have no leads. We have you.'),

(2, 'Rapid Prototyping Engineer', 2,
 'innovative, fast-paced',
 'Ship first, document never (kidding — please document).'),

(3, 'Developer Relations Lead', 2,
 'energetic, curious',
 'Explain complex things to confused humans, cheerfully.'),

(4, 'Engineering Manager, Chaos Team', 5,
 'empathetic, organized',
 'Herd cats. The cats are senior engineers.'),

(5, 'Incident Commander', 4,
 'decisive, calm-under-pressure',
 '3am page. You''re the one who picks up.'),

(6, 'Sales Engineer', 3,
 'enthusiastic, persistent',
 'Sell the vision, then go build it.');

-- Candidate skills
INSERT INTO candidate_skills (candidate_id, skill) VALUES
(1, 'deduction'),
(1, 'pattern-recognition'),
(1, 'forensics'),

(2, 'research'),
(2, 'time-management'),
(2, 'public-speaking'),

(3, 'systems-design'),
(3, 'rapid-prototyping'),
(3, 'leadership'),

(4, 'project-management'),
(4, 'stakeholder-management'),
(4, 'public-speaking'),

(5, 'woodworking'),
(5, 'minimalism'),
(5, 'negotiation'),

(6, 'systems-design'),
(6, 'rapid-prototyping'),
(6, 'chemistry'),

(7, 'persuasion'),
(7, 'research'),
(7, 'public-speaking'),

(8, 'rapid-prototyping'),
(8, 'resourcefulness'),
(8, 'chemistry'),
(8, 'systems-design'),

(9, 'theoretical-analysis'),
(9, 'pattern-recognition'),
(9, 'research'),

(10, 'precision'),
(10, 'strategy'),
(10, 'crisis-management'),

(11, 'sales'),
(11, 'public-speaking'),
(11, 'team-building'),

(12, 'crisis-management'),
(12, 'negotiation'),
(12, 'strategy'),
(12, 'leadership'),

(13, 'team-building'),
(13, 'optimism'),
(13, 'mentorship'),
(13, 'public-speaking'),

(14, 'leadership'),
(14, 'negotiation'),
(14, 'stakeholder-management'),
(14, 'precision'),

(15, 'sales'),
(15, 'negotiation'),
(15, 'security'),
(15, 'loyalty');

-- Required skills for jobs
INSERT INTO job_required_skills (job_id, skill) VALUES
(1, 'deduction'),
(1, 'pattern-recognition'),
(1, 'forensics'),

(2, 'rapid-prototyping'),
(2, 'systems-design'),

(3, 'public-speaking'),
(3, 'research'),

(4, 'team-building'),
(4, 'stakeholder-management'),
(4, 'leadership'),

(5, 'crisis-management'),
(5, 'strategy'),
(5, 'negotiation'),

(6, 'sales'),
(6, 'public-speaking'),
(6, 'negotiation');

-- Verification queries
SELECT COUNT(*) AS candidate_count FROM candidates;
SELECT COUNT(*) AS job_count FROM jobs;
SELECT COUNT(*) AS candidate_skill_count FROM candidate_skills;
SELECT COUNT(*) AS required_skill_count FROM job_required_skills;
