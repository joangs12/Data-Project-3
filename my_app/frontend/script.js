const api = "https://YOUR_CLOUD_RUN_URL"; // reemplaza con tu endpoint

async function fetchMovies() {
  const res = await fetch(`${api}/movies`);
  const data = await res.json();
  const ul = document.getElementById("movie-list");
  ul.innerHTML = "";
  data.forEach(movie => {
    const li = document.createElement("li");
    li.innerText = movie.title;
    const btn = document.createElement("button");
    btn.innerText = "🛒";
    btn.onclick = () => addToCart(movie.id);
    li.appendChild(btn);
    ul.appendChild(li);
  });
}

async function addMovie() {
  const title = document.getElementById("new-title").value;
  await fetch(`${api}/add`, {
    method: "POST",
    body: JSON.stringify({ title }),
    headers: { "Content-Type": "application/json" },
  });
  fetchMovies();
}

async function addToCart(movieId) {
  await fetch(`${api}/cart`, {
    method: "POST",
    body: JSON.stringify({ movie_id: movieId }),
    headers: { "Content-Type": "application/json" },
  });
  const ul = document.getElementById("cart-list");
  const li = document.createElement("li");
  li.innerText = `Película ${movieId} añadida`;
  ul.appendChild(li);
}

fetchMovies();
