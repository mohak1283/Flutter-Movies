import 'package:movies_bloc/models/item_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:movies_bloc/resources/repository.dart';

class MoviesBloc {

  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get allMovies => _moviesFetcher.stream;

  fetchAllMovies() async {
    ItemModel itemModel = await _repository.fetchMoviesList();
    _moviesFetcher.sink.add(itemModel); 
  }

  dispose() {
    _moviesFetcher?.close();
  }
}
final bloc = MoviesBloc();