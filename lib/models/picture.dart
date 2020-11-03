class Picture{
  // ignore: non_constant_identifier_names
  int id, commerce_id;
  String description, url;

  // ignore: non_constant_identifier_names
  Picture({this.id, this.description, this.url, this.commerce_id});

  factory Picture.fromMap(dynamic data) => Picture(
    id: data['id'],
    description: data['description'],
    url: data['url'],
    commerce_id: data['commerce_id'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'description': description,
    'url': url,
    'commerce_id': commerce_id,
  };

}