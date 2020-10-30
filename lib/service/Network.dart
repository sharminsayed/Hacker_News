import 'dart:convert';

import 'package:flutter_hacker_news/model/Comment.dart';
import 'package:flutter_hacker_news/model/Article.dart';
import 'package:http/http.dart' as http;

class Network {
  static const List<int> topstories = [
    24919569,
    24920183,
    24918538,
    24919710,
    24920043,
    24921183,
    24919464,
    24920789,
    24920904,
    24920758,
    24921031,
    24919006,
    24917841,
    24919565,
    24901244,
    24919931,
    24917721,
    24919204,
    24915497,
    24920314,
    24918927,
    24919354,
    24906739,
    24917752,
    24917107
  ];

  // Base_url for API
  static const String Base_url = "https://hacker-news.firebaseio.com/v0";



  static Future<Article> getArticle(int id) async {
    /*
    * This function retrieves Article from API using network connectivity.
    *  @param id: int variable contains id of article
    * @return Article: An object of Article class fetched from API.
    * */

    String url = Base_url + "/item/" + id.toString() + ".json";
    try {
      final response = await http.get(url);
      if (200 == response.statusCode) {
        final jsonResponse = json.decode(response.body);
        Article topStories = new Article.fromJsonMap(jsonResponse);
        return topStories;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Comment> getComment(int id) async {
    /*
    * This function retrieves Comment from API using network connectivity.
    *  @param id: int variable contains id of comment
    * @return Comment: An object of Comment class fetched from API.
    * */
    String url = Base_url + "/item/" + id.toString() + ".json";
    try {
      final response = await http.get(url);
      if (200 == response.statusCode) {
        final jsonResponse = json.decode(response.body);
        print(response.body);
        Comment comment = new Comment.fromJsonMap(jsonResponse);
        return comment;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
