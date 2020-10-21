class User{
  final String rif, nameCompany, addressCompany, phoneCompany, email, name, address, phone;

  User({this.rif, this.nameCompany, this.addressCompany, this.phoneCompany, this.email, this.name, this.address, this.phone});

  factory User.fromMap(dynamic data) => User(
    rif: data['rif'],
    nameCompany: data['nameCompany'],
    addressCompany: data['addressCompany'],
    phoneCompany: data['phoneCompany'],
    email: data['email'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
  );

  Map<String, dynamic> toJson()=> {
    'rif': rif,
    'nameCompany': nameCompany,
    'addressCompanyCompany': addressCompany,
    'phoneCompany': phoneCompany,
    'email': email,
    'name': name,
    'address': address,
    'phone': phone,
  };

}