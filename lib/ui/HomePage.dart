import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/utils/DateUtils.dart';

import 'package:flutter_hacker_news/model/Article.dart';
import 'package:flutter_hacker_news/service/Network.dart';
import 'package:flutter_hacker_news/ui/DetailsPage.dart';
import 'package:animated_card/animated_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Article> _topstorieslist; //A list of item contains topstories
  bool _loading; //For text loading view

  @override
  void initState() {
    super.initState();
    _loading = true;

    List<Article> topstorieslist = new List<Article>();
    for (int i = 0; i < Network.topstories.length; i++) {
      //Get Article  From TopStories List

      Network.getArticle(Network.topstories[i]).then((stories) {
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
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
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
                // Building Listview with previously fetched topstories
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        null == _topstorieslist ? 0 : _topstorieslist.length,
                    itemBuilder: (BuildContext context, int index) {
                      Article topStories = _topstorieslist[index];

                      return AnimatedCard(
                        direction: AnimatedCardDirection.left,
                        //Initial animation direction
                        initDelay: Duration(milliseconds: 0),
                        //Delay to initial animation
                        duration: Duration(seconds: 1),
                        //Initial animation duration
                        curve: Curves.bounceOut,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Card(
                              color: Colors.amber,
                              //initial elevation of card
                              elevation: 5,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),

                              //for implement onTap in card
                              child: InkWell(
                                splashColor: Colors.amberAccent.withAlpha(50),
                                onTap: () {
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          NewsShowPage(topStories.id));

                                  Navigator.push(context, route);
                                },
                                //for implement card view credentilal
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
                                              Text(
                                                (topStories != null
                                                    ? DateUtils.DateFormate(
                                                        topStories.time)
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
  /*
    * This function converts shape appbar.
    * @param rect: for size
    * @param textDirection: for directon of curve
    * */
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
