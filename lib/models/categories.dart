class Categories{
  // ignore: non_constant_identifier_names
  int id, commerce_id, type;
  String name, url;

  // ignore: non_constant_identifier_names
  Categories({this.id, this.name, this.commerce_id, this.type});

  factory Categories.fromMap(dynamic data) => Categories(
    id: data['id'],
    name: data['name'],
    commerce_id: data['commerce_id'],
    type: data['type'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'name': name,
    'commerce_id': commerce_id,
    'type': type,
  };

}