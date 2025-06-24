import pg8000
import os
from dotenv import load_dotenv
import logging

load_dotenv()

logging.basicConfig(level=logging.INFO)

def handler(event, context):
   
    result = add_row(event)
    return {"statusCode": 200, "body": result}

def add_row(product):
    HOST_DB = os.getenv('HOST_DB')
    PORT_DB = int(os.getenv('PORT_DB'))
    DB_NAME = os.getenv('DB_NAME')
    USER_DB = os.getenv('USER_DB')
    PASSWORD_DB = os.getenv('PASSWORD_DB')
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
        cur.execute("INSERT INTO tabla (valores) VALUES (%s, %s)", (product['valor1'], product['valor2']))
        
        cur.close()
        conn.close()
        if row:
            return str(row)
        else:
            return "No row found with that id."
    except Exception as e:
        return f"Error: {e}"