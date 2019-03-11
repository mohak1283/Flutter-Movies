import 'dart:async';
import 'package:movies_bloc/models/item_model.dart';
import 'package:movies_bloc/models/movie_detail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:movies_bloc/resources/repository.dart';

class MovieDetailBloc {

  final _repository = Repository();
  final _movieId = PublishSubject<int>();
  final _similarMovies = BehaviorSubject<Future<ItemModel>>();
  final _movieDetail = BehaviorSubject<Future<MovieDetail>>();

  Function(int) get fetchTrailersById => _movieId.sink.add;

  Function(int) get fetchSimilarMoviesById => _movieId.sink.add;
  Observable<Future<ItemModel>> get similarMovies => _similarMovies.stream;

  Function(int) get fetchMovieDetailById => _movieId.sink.add;
  Observable<Future<MovieDetail>> get movieDetail => _movieDetail.stream;



  MovieDetailBloc() {
    _movieId.stream.transform(_similarMovieItemTransformer()).pipe(_similarMovies);
    _movieId.stream.transform(_movieDetailTransformer()).pipe(_movieDetail);
  }

  dispose() async {
    _movieId?.close();
    _similarMovies?.close();
    _movieDetail?.close();
  }



  _similarMovieItemTransformer() {
    return ScanStreamTransformer(
      (Future<ItemModel> itemModel, int id, int index) {
        print("MOVIE ID : $id");
        itemModel =_repository.fetchSimilarMovies(id);
        return itemModel;
      },
    );
  }

  _movieDetailTransformer() {
    return ScanStreamTransformer(
      (Future<MovieDetail> movieDetail, int id, int index) {
        print("MOVIE ID : $id");
        movieDetail =_repository.fetchMovieDetail(id);
        return movieDetail;
      },
    );
  }

}