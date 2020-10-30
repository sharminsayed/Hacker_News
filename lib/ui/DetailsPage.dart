import 'dart:core';

import 'package:animated_card/animated_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/utils/DateUtils.dart';
import 'package:flutter_hacker_news/model/Comment.dart';
import 'package:flutter_hacker_news/model/Article.dart';
import 'package:flutter_hacker_news/service/Network.dart';
import 'package:intl/intl.dart';
import 'package:tabbar/tabbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' show parse;

class NewsShowPage extends StatefulWidget {
  var id; //for article id
  NewsShowPage(this.id);

  @override
  _NewsShowPage createState() => _NewsShowPage(this.id);
}

class _NewsShowPage extends State<NewsShowPage> {
  final Set<Factory> gestureRecognizers = [
    Factory(() => EagerGestureRecognizer()),
  ].toSet();
  final controller = PageController();
  List<Comment> _commentlist; //A list of item contains comment
  List<Comment> childCommentList =
      new List<Comment>(); //A list of item contains child comment
  bool _loading; //For text loading view
  var id;
  Article _topStories;

  _NewsShowPage(this.id);

  @override
  void initState() {
    super.initState();
    _loading = true;
    List<Comment> commentlist = new List<Comment>();

    //Get Single Article  From Article
    Network.getArticle(id).then((topstories) {
      setState(() {
        _topStories = topstories;
        if (topstories != null && topstories.kids != null) {
          for (int i = 0; i < _topStories.kids.length; i++) {
            Network.getComment(_topStories.kids[i]).then((comment) {
              setState(() {
                if (comment != null) {
                  commentlist.add(comment);
                  if (comment.kids != null && comment.kids.length != 0) {
                    for (int i = 0; i < comment.kids.length; i++) {
                      Network.getComment(comment.kids[i])
                          .then((childComment) => {
                                if (childComment != null)
                                  {childCommentList.add(childComment)}
                              });
                    }
                  }
                }
              });
            });
          }
          _commentlist = commentlist;
        }

        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(_loading ? 'Loading.....' : 'Article'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabbarHeader(
            backgroundColor: Colors.amber,
            controller: controller,
            tabs: [
              // TopStories topStories = _topstorieslist[index],
              Tab(
                text: 'Article',
              ),
              Tab(text: "Comment"),
            ],
          ),
        ),
      ),
      body: TabbarContent(
        controller: controller,
        children: <Widget>[
          Container(child: _buildArticleSection(_topStories)),
          Container(child: _buildComment(context, _commentlist)),
        ],
      ),
    );
  }

  ListView _buildArticleSection(Article topStories) {
    // Building Listview with previously fetched single article

    if (topStories != null) {
      print('null title');
      print(topStories.url);
      return ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    Text(
                      (topStories != null ? topStories.by.toString() : 'by'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.timer),
                    Text(
                      (topStories != null
                          ? DateUtils.DateFormate(topStories.time)
                          : 'time'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              topStories.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 550,
              child: WebView(
                initialUrl: topStories.url,
                gestureRecognizers: gestureRecognizers,
                javascriptMode: JavascriptMode.unrestricted,
              )),
          Container(
            margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.comment),
                    Text(
                      (topStories != null
                          ? topStories.descendants.toString()
                          : 'descendants'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.score),
                    Text(
                      (topStories != null
                          ? topStories.score.toString()
                          : 'score'),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      Text('try again');
    }
  }

  ListView _buildComment(BuildContext context, List<Comment> commentlist) {
    // Building Listview with previously fetched comment
    return ListView.builder(
        itemCount: null == commentlist ? 0 : commentlist.length,
        padding: EdgeInsets.all(5),
        itemBuilder: (context, index) {
          return AnimatedCard(
              direction: AnimatedCardDirection.right,
              //Initial animation direction
              initDelay: Duration(milliseconds: 0),
              //Delay to initial animation
              duration: Duration(seconds: 1),
              //Initial animation duration//Implement this action to active dismiss
              curve: Curves.bounceOut,
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ExpansionTile(
                      leading: CircleAvatar(),
                      title: Text(
                        (commentlist[index] != null
                            ? commentlist[index].by
                            : 'by'), //name
                        // commentlist[index].by,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        (commentlist[index] != null
                            ? _parseHtmlString(commentlist[index].text)
                            : 'text'), //comment
                        // commentlist[index].by,
                        textAlign: TextAlign.left,
                        textScaleFactor: 1,

                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      trailing: Icon(Icons.more_vert),
                      children: <Widget>[
                        new Column(
                          children: _newchildbuilder(
                              context, commentlist[index].kids),
                        )
                      ])));
        });
  }

  String DateFormate(int time) {
    /*
    * This function converts milliseconds to formatted string..
    * @param time: time in milliseconds
    * @return String: Formatted date (ex:jan 20,2020)
    * */
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    var formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate.toString();
  }

  //this function is for removing html tag
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  List<Widget> _newchildbuilder(BuildContext context, List<int> kids) {
    /*
    * Builds child comments list using kids
    * @param context: BuildContext of page
    * @param kids: List of child comment id.
    * @return columnContent:  List of widgets
    * */
    List<Widget> columnContent = [];
    List<Comment> subList =
        childCommentList.where((element) => kids.contains(element.id)).toList();
    if (subList.length == 0) {
      columnContent.add(new ListTile(
        title: Text('No reply yet'),
      ));
      return columnContent;
    }
    for (Comment comment in subList) {
      columnContent.add(new ListTile(
        title: new Text(comment.text),
      ));
    }
    return columnContent;
  }
}
