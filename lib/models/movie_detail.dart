class MovieDetail {
  bool _adult;
  String _backdropPath;
  List<Genres> _genres;
  String _homepage;
  int _id;

  MovieDetail(
      {bool adult,
      String backdropPath,
      List<Genres> genres,
      String homepage,
      int id,
      }) {
    this._adult = adult;
    this._backdropPath = backdropPath;
    this._genres = genres;
    this._homepage = homepage;
    this._id = id;
  }

  bool get adult => _adult;
  set adult(bool adult) => _adult = adult;
  String get backdropPath => _backdropPath;
  set backdropPath(String backdropPath) => _backdropPath = backdropPath;

  List<Genres> get genres => _genres;
  set genres(List<Genres> genres) => _genres = genres;
  String get homepage => _homepage;
  set homepage(String homepage) => _homepage = homepage;
  int get id => _id;
  set id(int id) => _id = id;
  

  MovieDetail.fromJson(Map<String, dynamic> json) {
    _adult = json['adult'];
    _backdropPath = json['backdrop_path'];
    if (json['genres'] != null) {
      _genres = new List<Genres>();
      json['genres'].forEach((v) {
        _genres.add(new Genres.fromJson(v));
      });
    }
    _homepage = json['homepage'];
    _id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adult'] = this._adult;
    data['backdrop_path'] = this._backdropPath;
    if (this._genres != null) {
      data['genres'] = this._genres.map((v) => v.toJson()).toList();
    }
    data['homepage'] = this._homepage;
    data['id'] = this._id;
    return data;
  }
}

class Genres {
  int _id;
  String _name;

  Genres({int id, String name}) {
    this._id = id;
    this._name = name;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;

  Genres.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    return data;
  }
}

