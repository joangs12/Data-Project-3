import psycopg2
import os

def lambda_handler(event, context):
    # Configuración de conexión desde variables de entorno
    conn = psycopg2.connect(
        host=os.environ['DB_HOST'],
        database=os.environ['DB_NAME'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD']
    )
    cursor = conn.cursor()

    # Crear tabla si no existe
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS peliculas (
            id SERIAL PRIMARY KEY,
            titulo TEXT NOT NULL,
            genero TEXT,
            anio INT
        );
    """)

    # Verificar si hay datos
    cursor.execute("SELECT COUNT(*) FROM peliculas;")
    count = cursor.fetchone()[0]

    # Insertar datos iniciales si la tabla está vacía
    if count == 0:
        cursor.execute("""
            INSERT INTO peliculas (titulo, genero, anio) VALUES
            ('Regreso al Futuro', 'Ciencia Ficción', 1985),
            ('Pulp Fiction', 'Crimen', 1994),
            ('Matrix', 'Acción', 1999);
        """)
    
    conn.commit()
    cursor.close()
    conn.close()

    return {
        "statusCode": 200,
        "body": "Setup completado correctamente."
    }
