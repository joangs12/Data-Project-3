import pg8000
import os
import logging



logging.basicConfig(level=logging.INFO)

def handler(event, context):
   
    row_id = event.get('id')
    if not row_id:
        return {"statusCode": 400, "body": "No id provided in event."}
    result = get_row_by_id(row_id)
    return {"statusCode": 200, "body": result}

def get_row_by_id(row_id):
    HOST_DB = "postgres-db.cr4ei2qco23l.eu-central-1.rds.amazonaws.com"
    PORT_DB = int("5432")
    DB_NAME = "postgresdb"
    USER_DB = "postgres"
    PASSWORD_DB = "edem2425"
    try:
        conn = pg8000.connect(
            host=HOST_DB,
            port=PORT_DB,
            database=DB_NAME,
            user=USER_DB,
            password=PASSWORD_DB
        )
        logging.info("Conexión a la base de datos exitosa.")
        cur = conn.cursor()
        cur.execute("""
            CREATE TABLE IF NOT EXISTS moviesdb (
            id SERIAL PRIMARY KEY,
            title VARCHAR(255) NOT NULL,
            director VARCHAR(255),
            genre VARCHAR(100),
            release_year INT,
            duration_minutes INT,
            rating VARCHAR(10),
            available BOOLEAN DEFAULT TRUE,
            created_at TIMESTAMPTZ DEFAULT NOW()
            );
            """)
        cur.execute(
            """
            INSERT INTO moviesdb 
            (title, director, genre, release_year, duration_minutes, rating, available)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            """,
            (
                "El Club de la Lucha",      # title
                "David Fincher",            # director
                "Drama",                    # genre
                1999,                       # release_year
                139,                        # duration_minutes
                "R",                        # rating
                True                        # available
            )
        )
        conn.commit()
        cur.execute("SELECT * FROM moviesdb WHERE id = %s", (row_id,))
        row = cur.fetchone()
        cur.close()
        conn.close()
        if row:
            return str(row)
        else:
            return "No row found with that id."
    except Exception as e:
        return f"Error: {e}"

