const movies = [
  { title: "Regreso al Futuro", description: "Marty viaja a 1955 en un DeLorean." },
  { title: "Terminator", description: "Un cyborg asesino viaja al pasado." },
  { title: "Ghostbusters", description: "Científicos cazan fantasmas en Nueva York." },
  { title: "Blade Runner", description: "Cazador de replicantes en un futuro distópico." }
];

const movieList = document.getElementById("movie-list");
const movieDetails = document.getElementById("movie-details");
const movieTitle = document.getElementById("movie-title");
const movieDescription = document.getElementById("movie-description");
const rentButton = document.getElementById("rent-button");

movies.forEach((movie, index) => {
  const card = document.createElement("div");
  card.className = "movie-card";
  card.innerHTML = `<h3>${movie.title}</h3>`;
  card.onclick = () => showDetails(index);
  movieList.appendChild(card);
});

function showDetails(index) {
  const movie = movies[index];
  movieTitle.textContent = movie.title;
  movieDescription.textContent = movie.description;
  movieDetails.classList.remove("hidden");

  rentButton.onclick = () => {
    alert(`¡Has alquilado "${movie.title}"! 🎉`);
    closeDetails();
  };
}

function closeDetails() {
  movieDetails.classList.add("hidden");
}
