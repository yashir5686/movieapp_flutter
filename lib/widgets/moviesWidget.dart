import 'package:flutter/material.dart';
import 'package:hello_movies/models/movie.dart';

class MoviesWidget extends StatelessWidget {
  final List<Movie> movies;

  MoviesWidget({this.movies});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return ListTile(
            title: Padding(
              padding: const EdgeInsets.only(
                left: 6.0,
                bottom: 20,
                top: 10,
              ),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 53.0),
                  child: Container(
                      height: 120,
                      width: width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 30,
                            )
                          ]),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 5, left: 140,),
                            child: Text(
                              movie.title,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                          Text(movie.year),
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 160,
                      width: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 30,
                            )
                          ]),
                      child: Image.network(movie.poster, fit: BoxFit.fitWidth,),
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }
}
