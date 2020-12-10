class Paid{
  // ignore: non_constant_identifier_names
  int id, user_id, commerce_id, coin, shipping_id, percentage;
  // ignore: non_constant_identifier_names
  String codeUrl, nameClient,total, email, nameShopping, numberShopping, addressShopping, detailsShopping, nameCompanyPayments;

  // ignore: non_constant_identifier_names
  Paid({this.id, this.user_id, this.commerce_id, this.codeUrl, this.nameClient, this.total, this.coin, this.email, this.nameShopping, this.numberShopping, this.addressShopping, this.detailsShopping, this.shipping_id, this.percentage, this.nameCompanyPayments});

  factory Paid.fromMap(dynamic data) => Paid(
    id: data['id'],
    user_id: data['user_id'],
    commerce_id: data['commerce_id'],
    codeUrl: data['codeUrl'],
    nameClient: data['nameClient'],
    total: data['total'],
    coin: data['coin'],
    email: data['email'],
    nameShopping: data['nameShopping'],
    numberShopping: data['numberShopping'],
    addressShopping: data['addressShopping'],
    detailsShopping: data['detailsShopping'],
    shipping_id: data['shipping_id'],
    percentage: data['percentage'],
    nameCompanyPayments: data['nameCompanyPayments'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'user_id': user_id,
    'commerce_id': commerce_id,
    'codeUrl': codeUrl,
    'nameClient': nameClient,
    'total': total,
    'coin': coin,
    'email': email,
    'nameShopping': nameShopping,
    'numberShopping': numberShopping,
    'addressShopping': addressShopping,
    'detailsShopping': detailsShopping,
    'shipping_id': shipping_id,
    'percentage': percentage,
    'nameCompanyPayments': nameCompanyPayments,
  };

}