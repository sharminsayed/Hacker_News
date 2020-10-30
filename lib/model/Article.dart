
class Article {
  String by;
  int descendants;
  int id;
  List<int> kids;
  int score;
  int time;
  String title;
  String type;
  String url;

  Article.fromJsonMap(Map<String, dynamic> map):
  /*
	 * Mapping json data to article object
	 * */
        by = map["by"]==null?null:map["by"],
        descendants = map["descendants"]==null?null:map["descendants"],
        id = map["id"]==null?null:map["id"],
        kids = List<int>.from(map["kids"]),
        score = map["score"]==null?null:map["score"],
        time = map["time"]==null?null:map["time"],
        title = map["title"]==null?null:map["title"],
        type = map["type"]==null?null:map["type"],
        url = map["url"]==null?null:map["url"];

  Map<String, dynamic> toJson() {
    /*
	 * Convert article object to json data
	 * */
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['by'] = by;
    data['descendants'] = descendants;
    data['id'] = id;
    data['kids'] = kids;
    data['score'] = score;
    data['time'] = time;
    data['title'] = title;
    data['type'] = type;
    data['url'] = url;
    return data;
  }

  @override
  String toString() {
    return 'TopStories{by: $by, descendants: $descendants, id: $id, kids: $kids, score: $score, time: $time, title: $title, type: $type, url: $url}';
  }
}
