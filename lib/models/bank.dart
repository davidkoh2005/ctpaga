class Bank{
  String? coin, country, accountName, accountNumber, idCard, route, swift, address, bankName, accountType;

  Bank({this.coin, this.country, this.accountName, this.accountNumber, this.idCard, this.route, this.swift, this.address, this.bankName, this.accountType});

  factory Bank.fromMap(dynamic data) => Bank(
    coin: data['coin'],
    country: data['country'],
    accountName: data['accountName'],
    accountNumber: data['accountNumber'],
    idCard: data['idCard'],
    route: data['route'],
    swift: data['swift'],
    address: data['address'],
    bankName: data['bankName'],
    accountType: data['accountType'],
  );

  Map<String, dynamic> toJson()=> {
    'coin': coin,
    'country': country,
    'accountName': accountName,
    'accountNumber': accountNumber,
    'idCard': idCard,
    'route': route,
    'swift': swift,
    'address': address,
    'bankName': bankName,
    'accountType': accountType,
  };

}