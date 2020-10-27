class User{
  final int id, coin;
  final String rifCompany, nameCompany, addressCompany, phoneCompany, email, name, address, phone;

  User({this.id, this.rifCompany, this.nameCompany, this.addressCompany, this.phoneCompany, this.email, this.name, this.address, this.phone, this.coin});

  factory User.fromMap(dynamic data) => User(
    id: data['id'],
    rifCompany: data['rifCompany'],
    nameCompany: data['nameCompany'],
    addressCompany: data['addressCompany'],
    phoneCompany: data['phoneCompany'],
    email: data['email'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
    coin: data['coin'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'rifCompany': rifCompany,
    'nameCompany': nameCompany,
    'addressCompanyCompany': addressCompany,
    'phoneCompany': phoneCompany,
    'email': email,
    'name': name,
    'address': address,
    'phone': phone,
    'coin': coin,
  };

}