# Herra: Women's Health Symptom Tracker - Text-to-SQL

### Database Schema
![Herra DB Schema](schema.png)

Herra is a women's health tracking database that stores data about menstrual cycles, symptoms, moods, and medications. Users can ask natural language questions about their health data, and the system translates them into SQL queries using GPT-4o, then provides a friendly, empathetic response with insights.

## Prompting Strategies

The system uses a **zero-shot** approach — the full database schema is included in the system prompt, and questions are sent directly with no example SQL pairs. GPT is instructed to return only raw SQL with no markdown or explanation.

I also tried a **few-shot** approach by including 2-3 example question/SQL pairs in the system prompt. The few-shot strategy produced slightly more accurate queries for complex questions (like date arithmetic or multi-join queries), but for straightforward questions the zero-shot approach worked just as well. The few-shot approach was noticeably better at handling SQLite-specific functions like `JULIANDAY()` since it could learn the syntax from the examples.

## Sample Questions

### Correct Response
Strategy: zero-shot<br/>
Model: gpt-4o

Question:<br/>
What is the average cycle length for each user?

Generated SQL:
```sqlite
SELECT user_id, AVG(JULIANDAY(end_date) - JULIANDAY(start_date)) AS average_cycle_length
FROM cycles
WHERE end_date IS NOT NULL
GROUP BY user_id;
```

Query Results:<br/>
Columns: ['user_id', 'average_cycle_length']<br/>
(1, 4.2)<br/>
(2, 3.8333333333333335)<br/>
(3, 5.25)

Herra says:<br/>
Hello there! Let's take a look at the average cycle lengths for each user based on the data you provided:

- **User 1** has an average cycle length of about **4.2 days**.
- **User 2** experiences a cycle around **3.8 days**.
- **User 3** sees an average cycle of approximately **5.25 days**.

These numbers represent the average length of the cycles recorded. It's interesting to see how cycle lengths can vary from person to person, and even for the same person over time.

If these average lengths seem different from what you were expecting, or if they are considerably shorter than the typical menstrual cycle (which usually ranges from 21 to 35 days), it might be worth discussing with your healthcare provider to ensure everything is well. They can provide guidance tailored to your unique situation.

Remember, every body is different, and having accurate records can really help in understanding your body's patterns better. If you have any more questions or need further clarity, feel free to ask. Take care!

### Incorrect Response
This query returned no results because Lena may not have logged her mood on the exact day before her period started. The SQL logic is technically correct (using `DATE(c.start_date, '-1 day')`), but the seed data doesn't have mood entries that line up with exactly one day before a cycle start date.

Strategy: zero-shot<br/>
Model: gpt-4o

Question:<br/>
What mood does Lena most often feel the day before her period starts?

Generated SQL:
```sqlite
SELECT m.name, COUNT(*) AS frequency
FROM mood_logs ml
JOIN moods m ON ml.mood_id = m.id
JOIN cycles c ON ml.user_id = c.user_id
JOIN users u ON ml.user_id = u.id
WHERE u.name = 'Lena' AND ml.log_date = DATE(c.start_date, '-1 day')
GROUP BY m.name
ORDER BY frequency DESC
LIMIT 1;
```

Query Results:<br/>
Columns: ['name', 'frequency']<br/>
*(no rows returned)*

Herra says:<br/>
Hi there! It looks like we didn't find any specific mood data for Lena the day before her period starts. This could mean a couple of things: Lena might not have logged her mood on those specific days, or there might be a gap in the data we have.

Tracking moods consistently can be really helpful in spotting patterns or changes over time, especially around your menstrual cycle. If Lena wants to see more insights in the future, she might consider logging her mood daily or more frequently, especially as her period approaches.

If Lena has noticed any particular mood changes or patterns that concern her, it could be beneficial to discuss them with a healthcare professional. They can provide guidance and support tailored to her individual needs. If you have any more questions or need further assistance, feel free to reach out!

### More Examples

#### Example 1
Strategy: zero-shot<br/>
Model: gpt-4o

Question:<br/>
What are Maria's most common symptoms during her period?

Generated SQL:
```sqlite
-- TODO: paste generated SQL here
```

Query Results:<br/>
<!-- TODO: paste results here -->

Herra says:<br/>
<!-- TODO: paste response here -->

#### Example 2
Strategy: zero-shot<br/>
Model: gpt-4o

Question:<br/>
Which user has the highest average cramp severity?

Generated SQL:
```sqlite
-- TODO: paste generated SQL here
```

Query Results:<br/>
<!-- TODO: paste results here -->

Herra says:<br/>
<!-- TODO: paste response here -->

#### Example 3
Strategy: zero-shot<br/>
Model: gpt-4o

Question:<br/>
How many times has Priya taken ibuprofen, and what was the highest dose?

Generated SQL:
```sqlite
-- TODO: paste generated SQL here
```

Query Results:<br/>
<!-- TODO: paste results here -->

Herra says:<br/>
<!-- TODO: paste response here -->

#### Example 4
Strategy: zero-shot<br/>
Model: gpt-4o

Question:<br/>
Show me all symptoms Priya logged with severity 7 or higher

Generated SQL:
```sqlite
-- TODO: paste generated SQL here
```

Query Results:<br/>
<!-- TODO: paste results here -->

Herra says:<br/>
<!-- TODO: paste response here -->

#### Example 5
Strategy: zero-shot<br/>
Model: gpt-4o

Question:<br/>
<!-- TODO: add a question -->

Generated SQL:
```sqlite
-- TODO: paste generated SQL here
```

Query Results:<br/>
<!-- TODO: paste results here -->

Herra says:<br/>
<!-- TODO: paste response here -->

#### Example 6
Strategy: zero-shot<br/>
Model: gpt-4o

Question:<br/>
<!-- TODO: add a question -->

Generated SQL:
```sqlite
-- TODO: paste generated SQL here
```

Query Results:<br/>
<!-- TODO: paste results here -->

Herra says:<br/>
<!-- TODO: paste response here -->
