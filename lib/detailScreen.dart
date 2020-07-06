import 'package:flutter/material.dart';
import 'package:objective/main.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;


  DetailScreen({Key key, @required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Column(
        children:[
          Image.network(movie.urlToImage),
          Text(movie.description),
        ]
      ),
    );
  }
}