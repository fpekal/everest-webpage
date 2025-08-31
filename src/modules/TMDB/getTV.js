import moviedbpromise from 'moviedb-promise';
const MovieDb = moviedbpromise.MovieDb;

export default async function getTV(name) {
	const API_KEY = process.env.TMDB_API_KEY;
	const moviedb = new MovieDb(API_KEY);

	const result = await moviedb.searchTv({ query: name, page: 1, language: "pl"});

	console.log(result);
	return result.results;
}
