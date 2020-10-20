class User{
  final String rif, nameCompany, addressCompany, phoneCompany;

  User({this.rif, this.nameCompany, this.addressCompany, this.phoneCompany});

  factory User.fromMap(dynamic data) => User(
    rif: data['rif'],
    nameCompany: data['nameCompany'],
    addressCompany: data['addressCompany'],
    phoneCompany: data['phoneCompany'],
  );

  Map<String, dynamic> toJson()=> {
    'rif': rif,
    'nameCompany': nameCompany,
    'addressCompanyCompany': addressCompany,
    'phoneCompany': phoneCompany,
  };

}