import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/model/TopStories.dart';
import 'package:flutter_hacker_news/service/Network.dart';
import 'package:flutter_hacker_news/ui/DetailsPage.dart';
import 'package:animated_card/animated_card.dart';
import 'package:date_format/date_format.dart';

class HomePage extends StatefulWidget {
  // var id;
  //
  // HomePage2(this.id);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TopStories> _topstorieslist;
  bool _loading;
  var id;

  @override
  void initState() {
    super.initState();
    _loading = true;
    List<TopStories> topstorieslist = new List<TopStories>();
    for (int i = 0; i < Network.topstories.length; i++) {
      Network.getArticleDetails(Network.topstories[i]).then((stories) {
        // print("need print "+id);
        setState(() {
          if (stories != null) {
            topstorieslist.add(stories);
          }
        });
      });
    }
    _topstorieslist = topstorieslist;
    _loading = false;
    print(_topstorieslist);
  }

  @override
  Widget build(BuildContext context) {
    const curveHeight = 50.0;
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  shape: const MyShapeBorder(curveHeight),
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.amber,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      "Hacker News",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ];
            },
            body: ListView(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.65,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        null == _topstorieslist ? 0 : _topstorieslist.length,
                    itemBuilder: (BuildContext context, int index) {
                      TopStories topStories = _topstorieslist[index];

                      /// print("agdumbagdum" + topStories.toString());
                      return AnimatedCard(
                        direction: AnimatedCardDirection.left,
                        //Initial animation direction
                        initDelay: Duration(milliseconds: 0),
                        //Delay to initial animation
                        duration: Duration(seconds: 1),
                        //Initial animation duration//Implement this action to active dismiss
                        curve: Curves.bounceOut,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              color: Colors.amber,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: InkWell(
                                splashColor: Colors.amberAccent.withAlpha(50),
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          NewsShowPage(topStories.id));
                                  Navigator.push(context, route);
                                  print(topStories.id);
                                },
                                child: Container(
                                    child: Column(
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
                                              Icon(Icons.confirmation_number),
                                              Text(
                                                (topStories != null
                                                    ? topStories.id.toString()
                                                    : 'id'),
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

                                              Text((topStories != null
                                                    ? topStories.time.toString()
                                                    : 'time'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(15.0),
                                      color: Colors.white,
                                      height: 70,
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        (topStories != null
                                            ? topStories.title
                                            : 'title'),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
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
                                                    ? topStories.descendants
                                                        .toString()
                                                    : 'descendants'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 200,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.score),
                                              Text(
                                                (topStories != null
                                                    ? topStories.score
                                                        .toString()
                                                    : 'score'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          top: 0,
                                          right: 20,
                                          bottom: 0),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Author:",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              topStories != null
                                                  ? topStories.by.toString()
                                                  : 'by',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ]),
                                    ),
                                    SizedBox(
                                      height: 12.0,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          top: 0,
                                          right: 20,
                                          bottom: 0),
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.link),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Text(
                                                topStories != null
                                                    ? topStories.url.toString()
                                                    : 'url',
                                                style: TextStyle(
                                                  color: Colors.lightBlue
                                                      .withOpacity(0.8),
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ]),
                                    ),
                                  ],
                                )),
                              ),
                            )),
                      );
                    }),
              ),
            ])));
  }
}

class MyShapeBorder extends ContinuousRectangleBorder {
  const MyShapeBorder(this.curveHeight);

  final double curveHeight;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(
      rect.size.width / 2,
      rect.size.height + curveHeight * 1,
      rect.size.width,
      rect.size.height,
    )
    ..lineTo(rect.size.width, 0)
    ..close();
}
