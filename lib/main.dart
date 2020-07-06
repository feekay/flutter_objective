import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'detailScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie List',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Movie List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Movie>> futureMovies;

  @override
  void initState() {
    super.initState();
    futureMovies = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: snapshot.data[index].urlToImage == null
                      ? Image.asset('assets/placeholder.png')
                      : Image.network(snapshot.data[index].urlToImage),
                  title: Text(snapshot.data[index].title,
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DetailScreen(movie: snapshot.data[index]),
                    ));
                  },
                );
              });
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
        'https://api.themoviedb.org/3/discover/movie?api_key=441f37d4d70b37a51aca2e31e767b4c5');

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      Iterable list = result['results'];
      return list.map((model) => Movie.fromJson(model)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class Movie {
  String title;
  String urlToImage;
  String description;

  Movie({this.title, this.description, this.urlToImage});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        title: json['title'],
        description: json['overview'],
        urlToImage: 'https://image.tmdb.org/t/p/w500' + json['poster_path']);
  }
}
