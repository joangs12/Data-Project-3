from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

# Almacenamiento en memoria (simulado)
movies = [
    {"id": 1, "title": "El Padrino", "description": "Mafia, poder y familia."},
    {"id": 2, "title": "Matrix", "description": "Realidad virtual y liberación."},
    {"id": 3, "title": "Inception", "description": "Sueños dentro de sueños."},
    {"id": 4, "title": "Interstellar", "description": "Viaje a través del espacio y el tiempo."},
    {"id": 5, "title": "Gladiator", "description": "Venganza en la antigua Roma."},
    {"id": 6, "title": "Titanic", "description": "Amor trágico en el océano."}


    
]

@app.route("/")
def index():
    return render_template("index.html", movies=movies)

@app.route("/movie/<int:movie_id>")
def movie_detail(movie_id):
    movie = next((m for m in movies if m["id"] == movie_id), None)
    if movie:
        return render_template("detail.html", movie=movie)
    return "Película no encontrada", 404

@app.route("/add", methods=["POST"])
def add_movie():
    title = request.form.get("title")
    description = request.form.get("description")
    if title and description:
        new_id = max(m["id"] for m in movies) + 1 if movies else 1
        movies.append({"id": new_id, "title": title, "description": description})
    return redirect(url_for("index"))

if __name__ == "__main__":
     app.run(host='0.0.0.0', port=8080, debug=True)