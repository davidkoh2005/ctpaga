class Picture{
  final int id;
  final String description, url;

  Picture({this.id, this.description, this.url});

  factory Picture.fromMap(dynamic data) => Picture(
    id: data['id'],
    description: data['description'],
    url: data['url'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'description': description,
    'url': url,
  };

}