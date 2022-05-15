class Shipping{
  int? id, coin;
  String? description, price;

  Shipping({this.id, this.description, this.price, this.coin});

  factory Shipping.fromMap(dynamic data) => Shipping(
    id: data['id'],
    description: data['description'],
    price: data['price'],
    coin: data['coin'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'description': description,
    'price': price,
    'coin': coin,
  };

}