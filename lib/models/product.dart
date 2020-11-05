class Product{
  // ignore: non_constant_identifier_names
  int id, commerce_id, coin, stock;
  String name, url, price, description, categories;
  bool publish, postPurchase;

  // ignore: non_constant_identifier_names
  Product({this.id, this.commerce_id, this.url, this.name, this.price, this.coin, this.description, this.categories, this.publish, this.stock, this.postPurchase});

  factory Product.fromMap(dynamic data) => Product(
    id: data['id'],
    commerce_id: data['commerce_id'],
    url: data['url'],
    name: data['name'],
    price: data['price'],
    coin: data['coin'],
    description: data['description'],
    categories: data['categories'],
    publish: data['publish'],
    stock: data['stock'],
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
    'stock': stock,
    'postPurchase': postPurchase,
  };

}