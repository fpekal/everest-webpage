import moviedbpromise from 'moviedb-promise';
const MovieDb = moviedbpromise.MovieDb;

export default async function getMovie(name) {
	const API_KEY = process.env.TMDB_API_KEY;
	const moviedb = new MovieDb(API_KEY);

	const result = await moviedb.searchMovie({ query: name, page: 1, language: "pl"});
	return result.results;
}
