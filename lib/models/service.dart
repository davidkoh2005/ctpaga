class Service{
  // ignore: non_constant_identifier_names
  int? id, commerce_id, coin;
  String? name, url, price, description, categories, postPurchase;
  bool? publish;

  // ignore: non_constant_identifier_names
  Service({this.id, this.commerce_id, this.url, this.name, this.price, this.coin, this.description, this.categories, this.publish, this.postPurchase});

  factory Service.fromMap(dynamic data) => Service(
    id: data['id'],
    commerce_id: data['commerce_id'],
    url: data['url'],
    name: data['name'],
    price: data['price'],
    coin: data['coin'],
    description: data['description'],
    categories: data['categories'],
    publish: data['publish'],
    postPurchase: data['postPurchase'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'commerce_id': commerce_id,
    'url': url,
    'name': name,
    'price': price,
    'coin': coin,
    'description': description,
    'categories': categories,
    'publish': publish,
    'postPurchase': postPurchase,
  };

}