class User{
  int id, status;
  String email, name, address, phone, tokenFCM;
  bool statusShipping;

  User({this.id, this.email, this.name, this.address, this.phone, this.statusShipping, this.tokenFCM, this.status});

  factory User.fromMap(dynamic data) => User(
    id: data['id'],
    email: data['email'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
    statusShipping: data['statusShipping'],
    tokenFCM: data['tokenFCM'],
    status: data['status'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'email': email,
    'name': name,
    'address': address,
    'phone': phone,
    'statusShipping': statusShipping,
    'tokenFCM': tokenFCM,
    'status': status,
  };

}