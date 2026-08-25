# Schema-Aware Natural Language to SQL

A Flask-based Natural Language to SQL application that uses database schema information and a knowledge graph to provide context to an LLM for SQL query generation.

## How It Works

1. The user uploads a SQLite database.
2. SQLAlchemy reflects the database schema.
3. A NetworkX knowledge graph is constructed from tables, columns, and foreign-key relationships.
4. A schema summary is generated from the knowledge graph.
5. The schema summary and natural-language query are provided to the LLM.
6. The generated SQLite-compatible SQL query is executed against the database.
7. The query results are displayed in the web application.

## Technologies Used

- Python
- Flask
- SQLAlchemy
- NetworkX
- Matplotlib
- OpenAI API
- SQLite

## Project Structure

```text
schema-aware-nl-to-sql/
├── app.py
├── hospital.db
├── hospital.sql
├── requirements.txt
├── .gitignore
├── templates/
│   └── index.html
└── static/
    └── knowledge_graph.png