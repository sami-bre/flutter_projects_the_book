import 'package:flutter/material.dart';

import 'package:movies/movie.dart';
import 'http_helper.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int moviesCount = 0;
  List<Movie>? movies;
  late String result;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  late HttpHelper helper;
  Icon visibleIcon = const Icon(Icons.search);
  Widget searchBar = const Text('Movies');

  @override
  void initState() {
    result = 'waiting ...';
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  void initialize() async {
    movies = []; // I don't get it. what is this for?
    movies = await helper.getUpcoming() as List<Movie>;
    setState(
      () {
        moviesCount = movies?.length ?? 0;
        movies = movies;
      },
    );
  }

  void search(String text) async {
    movies = await helper.findMovies(text) as List<Movie>;
    setState(() {
      moviesCount = movies?.length ?? 0;
      movies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    Image image;
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (visibleIcon.icon == Icons.search) {
                  visibleIcon = const Icon(Icons.cancel);
                  searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    onSubmitted: (value) => search(value),
                  );
                } else {
                  visibleIcon = const Icon(Icons.search);
                  searchBar = const Text('Movies');
                }
              });
            },
            icon: visibleIcon,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: moviesCount,
        itemBuilder: (context, index) {
          image = (movies![index].posterPath != null)
              ? Image.network(iconBase + movies![index].posterPath!)
              : Image.network(defaultImage);
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              title: Text(movies![index].title),
              subtitle: Text(
                'Released: ${movies![index].releaseDate} - Vote: ${movies![index].voteAverage}',
              ),
              leading: CircleAvatar(backgroundImage: image.image),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieDetail(movies![index])),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
