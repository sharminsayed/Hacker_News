import 'package:animated_card/animated_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/model/Comment.dart';
import 'package:flutter_hacker_news/model/TopStories.dart';
import 'package:flutter_hacker_news/service/Network.dart';
import 'package:intl/intl.dart';
import 'package:tabbar/tabbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' show parse;


class NewsShowPage extends StatefulWidget {
  var id;

  NewsShowPage(this.id);

  @override
  _NewsShowPage createState() => _NewsShowPage(this.id);
}

class _NewsShowPage extends State<NewsShowPage> {
  final Set<Factory> gestureRecognizers = [
    Factory(() => EagerGestureRecognizer()),
  ].toSet();
  final controller = PageController();
  List<Comment> _commentlist;
  bool _loading;
  var id;
  TopStories _topStories;

  _NewsShowPage(this.id);

  @override
  void initState() {
    super.initState();
    _loading = true;
    List<Comment> commentlist = new List<Comment>();

    Network.getArticleDetails(id).then((topstories) {
      setState(() {
        _topStories = topstories;
        if (topstories != null && topstories.kids != null) {
          for (int i = 0; i < _topStories.kids.length; i++) {
            Network.getComment(_topStories.kids[i]).then((comment) {
              setState(() {
                if (comment != null) {
                  commentlist.add(comment);
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
          Container(child: _buildPosts(context, _commentlist)),
        ],
      ),
    );
  }

  ListView _buildArticleSection(TopStories topStories) {
    if (topStories != null) {
      print('null title');
      print(topStories.url);
      return ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: 20,
                top: 10,
                right: 20,
                bottom: 0),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.person),
                    Text(
                      (topStories != null
                          ? topStories.by.toString()
                          : 'by'),
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
                          ? DateFormate(topStories.time)
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

            width: MediaQuery
                .of(context)
                .size
                .width,

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
              height:500,
              child:
              WebView(initialUrl: topStories.url,
                gestureRecognizers:gestureRecognizers,
              javascriptMode:JavascriptMode.unrestricted,)
          ),

          // Text(
          //   topStories.url,
          //   style: TextStyle(
          //       color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          //   textAlign: TextAlign.center,
          //   maxLines: 2,
          //
          // ),

          Container(
            margin: EdgeInsets.only(
                left: 20,
                top: 10,
                right: 20,
                bottom: 0),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              crossAxisAlignment:
              CrossAxisAlignment.start,
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

  ListView _buildPosts(BuildContext context, List<Comment> commentlist) {
    return ListView.builder(
        itemCount: null == commentlist ? 0 : commentlist.length,
        padding: EdgeInsets.all(5),
        itemBuilder: (context, index) {
          return
            AnimatedCard(
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
                child:

                      ListTile(
                        leading: CircleAvatar(
                        ),
                        title: Text(
                          (commentlist[index] != null ? commentlist[index].by : 'by'),
                          // commentlist[index].by,
                          textAlign: TextAlign.left,
                          textScaleFactor: 1,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(
                          (commentlist[index] != null ? _parseHtmlString(commentlist[index].text) : 'text'),
                          // commentlist[index].by,
                          textAlign: TextAlign.left,
                          textScaleFactor: 1,

                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),

                        trailing: Icon(Icons.more_vert),
                      ),

                      // Container(
                      //   margin: EdgeInsets.only(
                      //       left: 20,
                      //       top: 10,
                      //       right: 20,
                      //       bottom: 0),
                      //   child: Row(
                      //     mainAxisAlignment:
                      //     MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment:
                      //     CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       Row(
                      //         children: <Widget>[
                      //           Icon(Icons.confirmation_number),
                      //           Text(
                      //             ( _topStories != null
                      //                 ? _topStories.descendants.toString()
                      //                 : 'descendants'),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(
                      //         width: 100,
                      //       ),
                      //       Row(
                      //
                      //         children: <Widget>[
                      //           IconButton(
                      //             icon: Icon(Icons.android),
                      //             onPressed: () {
                      //               _childcomment(context, commentlist);
                      //
                      //             },
                      //           ),
                      //
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),


                    // ListTile(
                    //   leading: CircleAvatar(
                    //   ),
                    //   title: Text(
                    //     (commentlist[index] != null ? commentlist[index].by : 'by'),
                    //     // commentlist[index].by,
                    //     textAlign: TextAlign.left,
                    //     textScaleFactor: 1,
                    //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    //   ),
                    //   subtitle: Text(
                    //     (commentlist[index] != null ? commentlist[index].text : 'text'),
                    //     // commentlist[index].by,
                    //     textAlign: TextAlign.left,
                    //     textScaleFactor: 1,
                    //
                    //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    //   ),
                    //
                    //   trailing: Icon(Icons.more_vert),
                    // ),




              )
          );
        });
  }

  String DateFormate(int time){
    var date = DateTime.fromMillisecondsSinceEpoch(time);
    var formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate.toString();


  }
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

}
