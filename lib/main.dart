import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hello_movies/models/movie.dart';
import 'package:hello_movies/widgets/moviesWidget.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _App createState() => _App();
}

class _App extends State<App> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<Movie> _movies = new List<Movie>();
  bool isSearching = false;
  String error = '';
  bool istyping = false;

  @override
  void initState() {
    super.initState();
    if (_searchText.isNotEmpty) {
      _populateAllMovies();
    }
  }

  void _populateAllMovies() async {
    final movies = await _fetchAllMovies();
    setState(() {
      _movies = movies;
      isSearching = false;
    });
  }

  Future<List<Movie>> _fetchAllMovies() async {
    setState(() {
      isSearching = true;
    });
    final response = await http
        .get("http://www.omdbapi.com/?s=$_searchText&apikey=c4e214f3");

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      Iterable list = result["Search"];
      setState(() {
        error = '';
      });
      return list.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      setState(() {
        error = 'please try searching for full movie name';
        isSearching = false;
      });
      throw Exception("Failed to load movies!");
    }
  }

  Widget body() {
    void _clearSearch() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _searchController.clear());
      setState(() {
        _searchText = '';
      });
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 20),
            child: Text(
              'Home',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            //height: 50,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                border: InputBorder.none,
                hintText: 'Try Searching Superman',
                // prefixIcon: Icon(
                //   Icons.search,
                //   color: Theme.of(context).accentColor.withOpacity(0.6),
                //   size: 30.0,
                // ),
                suffixIcon: _searchText.trim().isEmpty
                    ? Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 30.0,
                      )
                    : IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      ),
                // filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
                //_setupUsers();
              },
              onSubmitted: (input) {
                if (input.trim().isNotEmpty) {
                  _populateAllMovies();
                }
              },
            ),
          ),
        ),
        isSearching
            ? Center(child: Text('Seaching'))
            : _movies.isNotEmpty
                ? error.isEmpty
                    ? Container(
                        height: 580, child: MoviesWidget(movies: _movies))
                    : Center(child: Text(error))
                : Center(child: Text('Try Searching For Some Movies Please type specifice name as much as you can')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Movies App", home: Scaffold(body: SafeArea(child: body())));
  }
}
