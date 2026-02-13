-- seed_data.sql
-- Herra: Sample data for the women's health symptom tracker.

-- Users
INSERT INTO users (name, date_of_birth, email) VALUES
    ('Maria Santos', '1995-03-12', 'maria@example.com'),
    ('Lena Kim', '1998-07-25', 'lena@example.com'),
    ('Priya Patel', '1993-11-08', 'priya@example.com');

-- Symptoms
INSERT INTO symptoms (name, category) VALUES
    ('Cramps', 'physical'),
    ('Headache', 'physical'),
    ('Bloating', 'digestive'),
    ('Nausea', 'digestive'),
    ('Fatigue', 'physical'),
    ('Back pain', 'physical'),
    ('Breast tenderness', 'physical'),
    ('Acne', 'skin'),
    ('Insomnia', 'sleep'),
    ('Hot flashes', 'physical'),
    ('Dizziness', 'physical'),
    ('Constipation', 'digestive'),
    ('Irritability', 'emotional'),
    ('Anxiety', 'emotional'),
    ('Mood swings', 'emotional');

-- Moods
INSERT INTO moods (name) VALUES
    ('Happy'),
    ('Sad'),
    ('Anxious'),
    ('Irritable'),
    ('Calm'),
    ('Energetic'),
    ('Exhausted'),
    ('Stressed');

-- Medications
INSERT INTO medications (name, type) VALUES
    ('Ibuprofen', 'painkiller'),
    ('Midol', 'painkiller'),
    ('Iron supplement', 'supplement'),
    ('Vitamin D', 'supplement'),
    ('Magnesium', 'supplement'),
    ('Birth control pill', 'hormonal'),
    ('Evening primrose oil', 'supplement'),
    ('Acetaminophen', 'painkiller');

-- Maria Santos - Cycle and symptom data (roughly 28-day cycles)

-- Maria's cycles
INSERT INTO cycles (user_id, start_date, end_date, flow_level, notes) VALUES
    (1, '2025-10-03', '2025-10-08', 'heavy', 'Rough start this month'),
    (1, '2025-10-31', '2025-11-04', 'medium', NULL),
    (1, '2025-11-28', '2025-12-02', 'heavy', 'Heavier than usual'),
    (1, '2025-12-26', '2025-12-30', 'medium', NULL),
    (1, '2026-01-23', '2026-01-27', 'medium', NULL);

-- Maria's symptom logs
INSERT INTO symptom_logs (user_id, symptom_id, log_date, severity, notes) VALUES
    -- October cycle
    (1, 1, '2025-10-03', 8, 'Really bad cramps day 1'),
    (1, 5, '2025-10-03', 7, NULL),
    (1, 6, '2025-10-04', 6, 'Lower back ache'),
    (1, 2, '2025-10-04', 5, NULL),
    (1, 3, '2025-10-02', 4, 'Day before period'),
    (1, 7, '2025-10-01', 5, NULL),
    (1, 15, '2025-10-01', 6, 'Snapped at roommate'),
    -- November cycle
    (1, 1, '2025-10-31', 7, NULL),
    (1, 5, '2025-10-31', 6, 'So tired'),
    (1, 6, '2025-11-01', 5, NULL),
    (1, 3, '2025-10-30', 5, NULL),
    (1, 8, '2025-10-28', 4, 'Chin breakout'),
    (1, 14, '2025-10-29', 6, 'Anxious before period'),
    -- December cycle
    (1, 1, '2025-11-28', 9, 'Worst cramps in months'),
    (1, 5, '2025-11-28', 8, NULL),
    (1, 2, '2025-11-29', 7, 'Migraine-level headache'),
    (1, 4, '2025-11-29', 5, 'Felt nauseous all morning'),
    (1, 6, '2025-11-28', 7, NULL),
    (1, 3, '2025-11-27', 6, NULL),
    (1, 13, '2025-11-27', 7, NULL),
    -- January cycle
    (1, 1, '2026-01-23', 6, NULL),
    (1, 5, '2026-01-23', 5, NULL),
    (1, 3, '2026-01-22', 4, NULL),
    (1, 9, '2026-01-21', 5, 'Could not sleep night before period'),
    (1, 15, '2026-01-22', 5, NULL);

-- Maria's mood logs
INSERT INTO mood_logs (user_id, mood_id, log_date, intensity, notes) VALUES
    (1, 4, '2025-10-01', 4, NULL),
    (1, 7, '2025-10-03', 5, 'Exhausted on day 1'),
    (1, 2, '2025-10-04', 3, NULL),
    (1, 3, '2025-10-29', 4, 'Pre-period anxiety'),
    (1, 7, '2025-10-31', 4, NULL),
    (1, 8, '2025-11-27', 5, 'Stressed and crampy'),
    (1, 2, '2025-11-28', 4, 'Felt down all day'),
    (1, 4, '2025-11-29', 3, NULL),
    (1, 3, '2026-01-22', 3, NULL),
    (1, 7, '2026-01-23', 4, NULL),
    (1, 1, '2026-01-28', 4, 'Feeling better after period ended'),
    (1, 6, '2025-10-15', 4, 'Mid-cycle energy boost'),
    (1, 5, '2025-11-12', 3, NULL);

-- Maria's medication logs
INSERT INTO medication_logs (user_id, medication_id, log_date, dosage, notes) VALUES
    (1, 1, '2025-10-03', '400mg', 'For cramps'),
    (1, 1, '2025-10-04', '400mg', NULL),
    (1, 2, '2025-10-31', '1 pill', NULL),
    (1, 1, '2025-11-28', '600mg', 'Needed more for the pain'),
    (1, 1, '2025-11-29', '400mg', NULL),
    (1, 5, '2025-11-15', '400mg', 'Started magnesium for cramps'),
    (1, 5, '2025-11-16', '400mg', NULL),
    (1, 5, '2025-11-28', '400mg', NULL),
    (1, 1, '2026-01-23', '400mg', NULL);

-- Lena Kim - Cycle and symptom data (shorter cycles ~25 days)

-- Lena's cycles
INSERT INTO cycles (user_id, start_date, end_date, flow_level, notes) VALUES
    (2, '2025-10-05', '2025-10-09', 'light', NULL),
    (2, '2025-10-30', '2025-11-03', 'medium', NULL),
    (2, '2025-11-24', '2025-11-28', 'light', NULL),
    (2, '2025-12-19', '2025-12-23', 'medium', 'A bit heavier this time'),
    (2, '2026-01-13', '2026-01-17', 'light', NULL),
    (2, '2026-02-07', '2026-02-10', 'medium', NULL);

-- Lena's symptom logs
INSERT INTO symptom_logs (user_id, symptom_id, log_date, severity, notes) VALUES
    (2, 2, '2025-10-05', 6, 'Headache on day 1'),
    (2, 5, '2025-10-06', 4, NULL),
    (2, 9, '2025-10-04', 5, 'Couldn''t sleep before period'),
    (2, 14, '2025-10-04', 5, NULL),
    (2, 2, '2025-10-30', 5, NULL),
    (2, 3, '2025-10-29', 4, NULL),
    (2, 5, '2025-10-30', 5, NULL),
    (2, 8, '2025-10-27', 3, 'Forehead breakout'),
    (2, 2, '2025-11-24', 7, 'Bad headache'),
    (2, 11, '2025-11-24', 4, NULL),
    (2, 9, '2025-11-23', 6, NULL),
    (2, 14, '2025-11-23', 5, 'Feeling really anxious'),
    (2, 2, '2025-12-19', 5, NULL),
    (2, 5, '2025-12-19', 6, NULL),
    (2, 1, '2025-12-20', 4, 'Mild cramps'),
    (2, 2, '2026-01-13', 6, NULL),
    (2, 9, '2026-01-12', 7, 'Terrible insomnia'),
    (2, 14, '2026-01-12', 6, NULL),
    (2, 5, '2026-01-13', 5, NULL),
    (2, 2, '2026-02-07', 5, NULL),
    (2, 3, '2026-02-06', 4, NULL);

-- Lena's mood logs
INSERT INTO mood_logs (user_id, mood_id, log_date, intensity, notes) VALUES
    (2, 3, '2025-10-04', 4, 'Anxious night before period'),
    (2, 2, '2025-10-05', 3, NULL),
    (2, 6, '2025-10-15', 4, 'Good energy mid-cycle'),
    (2, 8, '2025-10-29', 4, NULL),
    (2, 7, '2025-10-30', 3, NULL),
    (2, 3, '2025-11-23', 5, 'Really anxious'),
    (2, 2, '2025-11-24', 4, NULL),
    (2, 1, '2025-12-01', 4, 'Feeling great'),
    (2, 3, '2026-01-12', 4, NULL),
    (2, 7, '2026-01-13', 4, NULL),
    (2, 5, '2026-01-20', 3, 'Calm after period');

-- Lena's medication logs
INSERT INTO medication_logs (user_id, medication_id, log_date, dosage, notes) VALUES
    (2, 8, '2025-10-05', '500mg', 'For headache'),
    (2, 4, '2025-10-10', '2000 IU', 'Daily vitamin D'),
    (2, 8, '2025-10-30', '500mg', NULL),
    (2, 8, '2025-11-24', '1000mg', 'Took extra for bad headache'),
    (2, 4, '2025-11-24', '2000 IU', NULL),
    (2, 8, '2025-12-19', '500mg', NULL),
    (2, 7, '2025-12-15', '1000mg', 'Trying evening primrose oil'),
    (2, 7, '2025-12-16', '1000mg', NULL),
    (2, 8, '2026-01-13', '500mg', NULL);

-- Priya Patel - Cycle and symptom data (longer cycles ~32 days)

-- Priya's cycles
INSERT INTO cycles (user_id, start_date, end_date, flow_level, notes) VALUES
    (3, '2025-10-10', '2025-10-16', 'heavy', 'Long and heavy'),
    (3, '2025-11-11', '2025-11-16', 'heavy', NULL),
    (3, '2025-12-13', '2025-12-18', 'medium', 'A bit lighter this month'),
    (3, '2026-01-14', '2026-01-19', 'heavy', NULL);

-- Priya's symptom logs
INSERT INTO symptom_logs (user_id, symptom_id, log_date, severity, notes) VALUES
    (3, 1, '2025-10-10', 8, 'Terrible cramps'),
    (3, 1, '2025-10-11', 7, NULL),
    (3, 5, '2025-10-10', 7, NULL),
    (3, 6, '2025-10-11', 8, 'Could barely move'),
    (3, 4, '2025-10-10', 6, 'Morning nausea'),
    (3, 3, '2025-10-09', 5, NULL),
    (3, 7, '2025-10-08', 6, NULL),
    (3, 10, '2025-10-12', 4, 'Woke up with hot flash'),
    (3, 13, '2025-10-09', 6, NULL),
    -- November
    (3, 1, '2025-11-11', 9, 'Worst cramps ever'),
    (3, 5, '2025-11-11', 8, NULL),
    (3, 6, '2025-11-12', 7, NULL),
    (3, 4, '2025-11-11', 5, NULL),
    (3, 2, '2025-11-12', 6, NULL),
    (3, 12, '2025-11-10', 4, NULL),
    (3, 15, '2025-11-10', 7, 'Extreme mood swings'),
    (3, 14, '2025-11-09', 6, NULL),
    -- December (lighter month)
    (3, 1, '2025-12-13', 5, 'Cramps not as bad'),
    (3, 5, '2025-12-13', 4, NULL),
    (3, 3, '2025-12-12', 4, NULL),
    (3, 8, '2025-12-10', 5, 'Breakout on jawline'),
    -- January
    (3, 1, '2026-01-14', 8, NULL),
    (3, 1, '2026-01-15', 7, NULL),
    (3, 5, '2026-01-14', 7, NULL),
    (3, 6, '2026-01-15', 8, 'Back pain is the worst'),
    (3, 4, '2026-01-14', 5, NULL),
    (3, 10, '2026-01-16', 5, NULL),
    (3, 13, '2026-01-13', 6, 'Irritable day before period');

-- Priya's mood logs
INSERT INTO mood_logs (user_id, mood_id, log_date, intensity, notes) VALUES
    (3, 8, '2025-10-09', 5, 'Stressed before period'),
    (3, 2, '2025-10-10', 4, NULL),
    (3, 7, '2025-10-11', 5, 'Completely wiped out'),
    (3, 4, '2025-10-12', 3, NULL),
    (3, 1, '2025-10-20', 4, 'Great day mid-cycle'),
    (3, 4, '2025-11-10', 5, 'So irritable'),
    (3, 2, '2025-11-11', 5, 'Cried at a commercial'),
    (3, 7, '2025-11-12', 4, NULL),
    (3, 5, '2025-12-01', 3, NULL),
    (3, 1, '2025-12-13', 3, 'Not as bad this month'),
    (3, 8, '2026-01-13', 4, NULL),
    (3, 2, '2026-01-14', 4, NULL),
    (3, 7, '2026-01-15', 5, 'So exhausted');

-- Priya's medication logs
INSERT INTO medication_logs (user_id, medication_id, log_date, dosage, notes) VALUES
    (3, 1, '2025-10-10', '600mg', NULL),
    (3, 1, '2025-10-11', '600mg', NULL),
    (3, 3, '2025-10-10', '65mg', 'Iron for heavy flow'),
    (3, 3, '2025-10-11', '65mg', NULL),
    (3, 1, '2025-11-11', '800mg', 'Needed max dose'),
    (3, 1, '2025-11-12', '600mg', NULL),
    (3, 3, '2025-11-11', '65mg', NULL),
    (3, 5, '2025-12-01', '400mg', 'Starting magnesium daily'),
    (3, 5, '2025-12-13', '400mg', NULL),
    (3, 1, '2025-12-13', '400mg', 'Less ibuprofen needed'),
    (3, 1, '2026-01-14', '600mg', NULL),
    (3, 3, '2026-01-14', '65mg', NULL),
    (3, 5, '2026-01-14', '400mg', NULL);
