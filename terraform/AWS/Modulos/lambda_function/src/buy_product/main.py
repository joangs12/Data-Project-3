import psycopg2
import json
import os

def lambda_handler(event, context):
    try:
        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASS'],
            dbname=os.environ['DB_NAME']
        )
        cur = conn.cursor()
        cur.execute("SELECT id, title FROM movies")
        rows = cur.fetchall()
        cur.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps([{"id": r[0], "title": r[1]} for r in rows])
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
