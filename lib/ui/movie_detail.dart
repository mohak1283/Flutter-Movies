import 'package:flutter/material.dart';
import 'package:movies_bloc/blocs/movie_detail_bloc.dart';
import 'package:movies_bloc/blocs/movie_detail_bloc_provider.dart';
import 'package:movies_bloc/models/item_model.dart';
import 'package:movies_bloc/models/movie_detail.dart';


class MovieDetailScreen extends StatefulWidget {
  final posterUrl;
  final description;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetailScreen({
    this.title,
    this.posterUrl,
    this.description,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  MovieDetailBloc bloc;
  final List<String> genresList = List<String>();

  @override
  void didChangeDependencies() {
    bloc = MovieDetailBlocProvider.of(context).bloc;
    bloc.fetchTrailersById(widget.movieId);
    bloc.fetchSimilarMoviesById(widget.movieId);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                  "https://image.tmdb.org/t/p/w500${widget.posterUrl}",
                  fit: BoxFit.cover,
                )),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 50.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    RaisedButton.icon(
                      onPressed: () {},
                      textColor: Colors.white,
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Reviews'),
                      ),
                      shape: StadiumBorder(),
                      color: Colors.red,
                      icon: Icon(Icons.rate_review, color: Colors.white),
                    )
                  ],
                ),

                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1.0, right: 1.0),
                    ),
                    Text(
                      widget.voteAverage,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    Text(
                      widget.releaseDate,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Text(widget.description),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),

                StreamBuilder(
                  stream: bloc.movieDetail,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FutureBuilder(
                        future: snapshot.data,
                        builder:
                            (context, AsyncSnapshot<MovieDetail> snapshot) {
                          if (snapshot.hasData) {
                            return chipLayout(snapshot.data);
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),

                // Chip(
                //   label: Text('Drama'),
                // ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Text(
                  "Similar Movies",
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                StreamBuilder(
                  stream: bloc.similarMovies,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FutureBuilder(
                        future: snapshot.data,
                        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
                          if (snapshot.hasData) {
                            return similarMoviesLayout(snapshot.data);
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget chipLayout(MovieDetail data) {
    List<Widget> children = List<Widget>();

    if (data.genres.isNotEmpty) {
      var genres = data.genres;
      for (var i = 0; i < genres.length; i++) {
        String name = genres[i].name;
        print("Inside first loop");
        genresList.add(name);
      }

      for (var i = 0; i < genresList.length; i++) {
        print("Inside second loop");
        children.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Chip(
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(genresList[i]),
            ),
          ),
        ));
      }

      return Wrap(direction: Axis.horizontal, children: children);
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 80.0, right: 20.0),
        child: Text(
          'No Genres Found',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic),
        ),
      );
    }
  }

  Widget similarMoviesLayout(ItemModel data) {
    // if (data.results.length > 1) {
    if (data.results.isNotEmpty) {
      print('Inside if');
      return Row(
        // scrollDirection: Axis.horizontal,
        children: <Widget>[
          similarItem(data, 0),
          similarItem(data, 1),
          // similarItem(data, 2),
          // similarItem(data, 3),
        ],
      );
    } else {
      print('Inside else');
      return Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 80.0, right: 20.0),
        child: Text(
          'No Similar Movies Found',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic),
        ),
      );
    }
  }

  similarItem(ItemModel data, int index) {
    print('Index : $index');
    return Expanded(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return MovieDetailBlocProvider(
                  child: MovieDetailScreen(
                    title: data.results[index].title,
                    posterUrl: data.results[index].poster_path,
                    description: data.results[index].overview,
                    releaseDate: data.results[index].release_date,
                    voteAverage: data.results[index].vote_average.toString(),
                    movieId: data.results[index].id,
                  ),
                );
              }));
            },
            child: Container(
              margin: EdgeInsets.all(5.0),
              height: 100.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://image.tmdb.org/t/p/w185${data.results[index].poster_path}'),
                      fit: BoxFit.cover)),
            ),
          ),
          Text(
            data.results[index].title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
