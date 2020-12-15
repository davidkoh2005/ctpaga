class Balance{
  // ignore: non_constant_identifier_names
  int id, user_id, commerce_id, coin;
  // ignore: non_constant_identifier_names
  String total;
  // ignore: non_constant_identifier_names
  Balance({this.id, this.user_id, this.commerce_id, this.total, this.coin});

  factory Balance.fromMap(dynamic data) => Balance(
    id: data['id'],
    user_id: data['user_id'],
    commerce_id: data['commerce_id'],
    total: data['total'],
    coin: data['coin'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'user_id': user_id,
    'commerce_id': commerce_id,
    'total': total,
    'coin': coin,
  };

}