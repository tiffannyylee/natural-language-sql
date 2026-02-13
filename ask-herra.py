import json
from openai import OpenAI
import os
import sqlite3
from dotenv import load_dotenv

load_dotenv()

DB_PATH = "herra.db"

SCHEMA = """
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    date_of_birth DATE,
    email TEXT UNIQUE NOT NULL
);

CREATE TABLE symptoms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    category TEXT NOT NULL  -- 'physical', 'emotional', 'digestive', 'skin', 'sleep'
);

CREATE TABLE symptom_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    symptom_id INTEGER NOT NULL,
    log_date DATE NOT NULL,
    severity INTEGER CHECK(severity BETWEEN 1 AND 10),
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (symptom_id) REFERENCES symptoms(id)
);

CREATE TABLE moods (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE mood_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    mood_id INTEGER NOT NULL,
    log_date DATE NOT NULL,
    intensity INTEGER CHECK(intensity BETWEEN 1 AND 5),
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (mood_id) REFERENCES moods(id)
);

CREATE TABLE cycles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    flow_level TEXT CHECK(flow_level IN ('light', 'medium', 'heavy')),
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE medications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    type TEXT  -- 'painkiller', 'supplement', 'hormonal', 'prescription'
);

CREATE TABLE medication_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    medication_id INTEGER NOT NULL,
    log_date DATE NOT NULL,
    dosage TEXT,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (medication_id) REFERENCES medications(id)
);
"""


def init_db():
    """Initialize the database by running setup.sql and seed_data.sql."""
    db_exists = os.path.exists(DB_PATH)
    conn = sqlite3.connect(DB_PATH)
    if not db_exists:
        with open("setup.sql", "r") as f:
            conn.executescript(f.read())
        with open("seed_data.sql", "r") as f:
            conn.executescript(f.read())
    return conn


def run_query(conn, sql):
    """Execute a SQL query and return the results."""
    cursor = conn.cursor()
    cursor.execute(sql)
    columns = [desc[0] for desc in cursor.description] if cursor.description else []
    rows = cursor.fetchall()
    return columns, rows


def get_sql_from_gpt(client, question):
    """Send a natural language question to GPT and get back a SQL query."""
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {
                "role": "system",
                "content": (
                    "You are a SQL expert for a women's health symptom tracking app called Herra. "
                    "Given a natural language question, generate a valid SQLite SELECT query to answer it. "
                    "Return ONLY the raw SQL query, no markdown, no explanation, no code fences. "
                    "IMPORTANT RULES:\n"
                    "- users.name stores FULL names (e.g. 'Maria Santos'). When filtering by name, use LIKE with a wildcard: u.name LIKE 'Maria%'\n"
                    "- All string comparisons should be case-insensitive. Use LOWER() on both sides, e.g. LOWER(s.name) = LOWER('Cramps')\n"
                    "- 'Cycle length' means the number of days between one cycle's start_date and the next cycle's start_date for the same user, NOT end_date - start_date (that is period duration).\n"
                    "Here is the database schema:\n\n" + SCHEMA
                ),
            },
            {"role": "user", "content": question},
        ],
        temperature=0,
    )
    return response.choices[0].message.content.strip()


def get_friendly_response(client, question, columns, rows, sql):
    """Send query results back to GPT to get a friendly, human-readable answer."""
    if not rows:
        results_text = "The query returned no results."
    else:
        results_text = f"Columns: {columns}\nRows:\n"
        for row in rows:
            results_text += f"  {row}\n"

    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {
                "role": "system",
                "content": (
                    "You are a friendly and empathetic health assistant for a women's symptom tracking app called Herra. "
                    "Given a user's original question, the SQL query that was run, and the results, "
                    "provide a warm, helpful, and easy-to-understand response. "
                    "Use the data to give insights. Be supportive and conversational. "
                    "If relevant, gently suggest patterns or things the user might want to discuss with their doctor."
                ),
            },
            {
                "role": "user",
                "content": (
                    f"My question was: {question}\n\n"
                    f"The SQL query run was:\n{sql}\n\n"
                    f"The results were:\n{results_text}"
                ),
            },
        ],
        temperature=0.7,
    )
    return response.choices[0].message.content.strip()


def ask_herra(conn, client, question):
    """Full pipeline: Question -> GPT -> SQL -> Results -> GPT -> Friendly response."""
    print(f"\n{'='*60}")
    print(f"Question: {question}")
    print(f"{'='*60}")

    # Step 1: Get SQL from GPT
    sql = get_sql_from_gpt(client, question)
    print(f"\nGenerated SQL:\n  {sql}")

    # Step 2: Execute the SQL
    try:
        columns, rows = run_query(conn, sql)
        print(f"\nQuery Results:")
        print(f"  Columns: {columns}")
        for row in rows:
            print(f"  {row}")
    except Exception as e:
        print(f"\nSQL Error: {e}")
        print("The generated query failed to execute.")
        return

    # Step 3: Get friendly response from GPT
    friendly = get_friendly_response(client, question, columns, rows, sql)
    print(f"\nHerra says:\n  {friendly}")


if __name__ == "__main__":
    conn = init_db()
    client = OpenAI()

    questions = [
        # "What are Maria's most common symptoms during her period?",
        # "Which user has the highest average cramp severity?",
        # "What mood does Lena most often feel the day before her period starts?",
        # "How many times has Priya taken ibuprofen, and what was the highest dose?",
        # "Show me all symptoms Priya logged with severity 7 or higher",
        # "What is the average cycle length for each user?",
        "What supplements does Maria take on which days?",
        "Which symptoms does Priya log most?",
    ]

    for q in questions:
        ask_herra(conn, client, q)

    conn.close()
