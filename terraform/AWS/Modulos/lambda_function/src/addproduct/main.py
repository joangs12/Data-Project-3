import psycopg2
import json
import os

def lambda_handler(event, context):
    try:
        data = json.loads(event["body"])
        title = data.get("title")

        if not title:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Title is required"})
            }

        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASS'],
            dbname=os.environ['DB_NAME']
        )
        cur = conn.cursor()
        cur.execute("INSERT INTO movies (title) VALUES (%s)", (title,))
        conn.commit()
        cur.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Movie added"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
