import 'package:movies_bloc/models/item_model.dart';
import 'package:movies_bloc/models/movie_detail.dart';
import 'movie_api_provider.dart';
import 'dart:async';


class Repository {

  final MovieApiProvider _movieApiProvider = MovieApiProvider();

  
  Future<ItemModel> fetchMoviesList() => _movieApiProvider.fetchMovieList();

  Future<ItemModel> fetchSimilarMovies(int movieId) => _movieApiProvider.fetchSimilarMovies(movieId);

  Future<MovieDetail> fetchMovieDetail(int movieId) => _movieApiProvider.fetchMovieDetail(movieId);
  

}