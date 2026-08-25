import os
import tempfile
from flask import Flask, request, render_template, flash
from sqlalchemy import create_engine, MetaData
import networkx as nx
import openai
from sqlalchemy import text
import webbrowser
import threading

# Load your OpenAI API key from the environment.
# Make sure you set OPENAI_API_KEY in your environment variables.
# Load your OpenAI API key from the environment.
openai.api_key = os.getenv("OPENAI_API_KEY")

if not openai.api_key:
    raise ValueError("Please set the OPENAI_API_KEY environment variable.")

app = Flask(__name__)
app.secret_key = 'your-secret-key'  # Replace with a secure key in production

def open_browser():
    webbrowser.open_new("http://127.0.0.1:5000/")

def build_schema_graph(engine):
    """
    Reflect the database schema using SQLAlchemy and build a knowledge graph.
    Nodes represent tables and columns; edges represent column membership and foreign key relationships.
    """
    metadata = MetaData()
    metadata.reflect(bind=engine)
    G = nx.DiGraph()
    # Add table nodes and column nodes with edges from table to column.
    for table_name, table in metadata.tables.items():
        G.add_node(table_name, type="table")
        for column in table.columns:
            col_node = f"{table_name}.{column.name}"
            G.add_node(col_node, type="column", data_type=str(column.type))
            G.add_edge(table_name, col_node, relation="has_column")
    # Add foreign key edges
    for table in metadata.tables.values():
        for fk in table.foreign_keys:
            source = f"{table.name}.{fk.parent.name}"
            target = f"{fk.column.table.name}.{fk.column.name}"
            G.add_edge(source, target, relation="foreign_key")
    return G

def graph_summary(G):
    """
    Generate a human-readable summary of the schema graph.
    Lists each table and its columns (with data types).
    """
    summary = ""
    for node, data in G.nodes(data=True):
        if data.get("type") == "table":
            summary += f"Table: {node}\n"
            for neighbor in G.successors(node):
                if G.nodes[neighbor].get("type") == "column":
                    summary += f"  - {neighbor.split('.')[-1]} ({G.nodes[neighbor]['data_type']})\n"
            summary += "\n"
    return summary

def generate_sql_query(nl_query, schema_summary):
    """
    Build a prompt using the schema summary and natural language query,
    then call OpenAI's GPT-3.5-turbo to generate an SQL query.
    """
    prompt = f"""You are a SQL query generator for SQLite.
Given the following database schema:
{schema_summary}
Generate a valid SQLite-compatible SQL query for the following request:
{nl_query}
Use only functions and syntax supported by SQLite.
Provide only the SQL query without any extra explanation.
"""

    response = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "system", "content": prompt}],
        temperature=0,
    )
    sql_query = response.choices[0].message['content'].strip()
    return sql_query

@app.route("/", methods=["GET", "POST"])
def index():
    generated_query = None
    query_result = None

    if request.method == "POST":
        # Handle file upload
        uploaded_file = request.files.get("sql_file")
        if uploaded_file and uploaded_file.filename:
            # Save the uploaded file to a temporary directory
            temp_dir = tempfile.gettempdir()
            file_path = os.path.join(temp_dir, uploaded_file.filename)
            uploaded_file.save(file_path)

            # Construct the SQLAlchemy URI for an SQLite database.
            db_uri = f"sqlite:///{file_path}"
            try:
                engine = create_engine(db_uri)
                # Build a knowledge graph of the schema and generate a summary
                schema_graph = build_schema_graph(engine)
                schema_text = graph_summary(schema_graph)
                import matplotlib
                matplotlib.use("Agg")
                import matplotlib.pyplot as plt

                plt.figure(figsize=(12, 8))
                pos = nx.spring_layout(schema_graph, k=0.5)
                nx.draw(schema_graph, pos, with_labels=True, node_size=2000, node_color="lightblue", font_size=8, font_weight="bold")
                edge_labels = nx.get_edge_attributes(schema_graph, 'relation')
                nx.draw_networkx_edge_labels(schema_graph, pos, edge_labels=edge_labels, font_size=6)
                plt.title("Database Schema Knowledge Graph")
                plt.savefig("static/knowledge_graph.png")  # Save image for web
                plt.close()

                
                
            except Exception as e:
                flash(f"Error reading database: {e}")
                return render_template("index.html")

            
            nl_query = request.form.get("query", "").strip()
            if nl_query:
                try:
                    # Generate the SQL query using the LLM and schema context
                    generated_query = generate_sql_query(nl_query, schema_text)
                    # Optionally, execute the generated query
                    with engine.connect() as connection:
                        result_proxy = connection.execute(text(generated_query))
                        query_result = result_proxy.fetchall()
                except Exception as e:
                    flash(f"Error generating/executing query: {e}")
        else:
            flash("Please upload a database file.")

    return render_template("index.html", generated_query=generated_query, query_result=query_result)

if __name__ == "__main__":
    threading.Timer(1.5, open_browser).start()  
    app.run(debug=True)


