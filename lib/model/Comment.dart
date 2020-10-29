
class Comment {
	String by;
  int id;
  List<int> kids;
  int parent;
  String text;
  int time;
  String type;

	Comment.fromJsonMap(Map<String, dynamic> map): 
		by = map["by"]==null?null:map["by"],
		id = map["id"]==null?null:map["id"],
		kids = List<int>.from(map["kids"]),
		parent = map["parent"]==null?null:map["parent"],
		text = map["text"]==null?null:map["text"],
		time = map["time"]==null?null:map["time"],
		type = map["type"]==null?null:map["type"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['by'] = by;
		data['id'] = id;
		data['kids'] = kids;
		data['parent'] = parent;
		data['text'] = text;
		data['time'] = time;
		data['type'] = type;
		return data;
	}

	@override
  String toString() {
    return 'Comment{by: $by, id: $id, kids: $kids, parent: $parent, text: $text, time: $time, type: $type}';
  }
}
