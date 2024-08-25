import 'package:flutter/material.dart';
import 'package:agritek/styles/app_color.dart';

class Movie {
  final String title;
  final String director;
  final String imageUrl;
  final double rating;

  Movie({
    required this.title,
    required this.director,
    required this.imageUrl,
    required this.rating,
  });
}

class HomePage extends StatelessWidget {
  final List<Movie> movies = [
    Movie(
      title: 'Forrest Gump',
      director: 'Robert Zemickis',
      imageUrl: 'assets/images/fgump.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Fight Club',
      director: 'david Fincher',
      imageUrl: 'assets/images/fclub.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Fantastic Mr. Fox',
      director: 'Wes Anderson',
      imageUrl: 'assets/images/fmrfox.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Avengers: Infinity War',
      director: 'Anthony and Joe Russo',
      imageUrl: 'assets/images/infinitywar.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Whiplash',
      director: 'Damien Chazelle',
      imageUrl: 'assets/images/whiplash.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Grand Budapest Hotel',
      director: 'Wes Anderson',
      imageUrl: 'assets/images/ghotel.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Gone Girl',
      director: 'David Fincher ',
      imageUrl: 'assets/images/ggirl.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Little Women',
      director: 'Greta Gerwig',
      imageUrl: 'assets/images/lwomen.jpg',
      rating: 10,
    ),
    Movie(
      title: 'La La Land',
      director: 'Damien Chazelle',
      imageUrl: 'assets/images/lalaland.jpg',
      rating: 10,
    ),
    Movie(
      title: 'The Shining',
      director: 'Stanley Kubrick',
      imageUrl: 'assets/images/shining.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Eternal Sunshine of the Spotless Mind',
      director: 'Michel Gondrey',
      imageUrl: 'assets/images/eternal.jpg',
      rating: 10,
    ),
    Movie(
      title: 'Spiderman: Across  the Spider-Verse',
      director: 'Joaquim Dos Santos,Justin Thompson, Kemp Powers',
      imageUrl: 'assets/images/spiderverse.jpg',
      rating: 10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: Text('My Movie List'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _buildMovieItem(context, movies[index]);
        },
      ),
    );
  }

  Widget _buildMovieItem(BuildContext context, Movie movie) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                movie.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  movie.director,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow),
                    SizedBox(width: 5),
                    Text(
                      movie.rating.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
