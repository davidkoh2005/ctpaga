class User{
  final String rifCompany, nameCompany, addressCompany, phoneCompany, email, name, address, phone;

  User({this.rifCompany, this.nameCompany, this.addressCompany, this.phoneCompany, this.email, this.name, this.address, this.phone});

  factory User.fromMap(dynamic data) => User(
    rifCompany: data['rifCompany'],
    nameCompany: data['nameCompany'],
    addressCompany: data['addressCompany'],
    phoneCompany: data['phoneCompany'],
    email: data['email'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
  );

  Map<String, dynamic> toJson()=> {
    'rifCompany': rifCompany,
    'nameCompany': nameCompany,
    'addressCompanyCompany': addressCompany,
    'phoneCompany': phoneCompany,
    'email': email,
    'name': name,
    'address': address,
    'phone': phone,
  };

}