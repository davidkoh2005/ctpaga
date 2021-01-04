class User{
  int id;
  String email, name, address, phone;
  bool statusShipping;

  User({this.id, this.email, this.name, this.address, this.phone, this.statusShipping});

  factory User.fromMap(dynamic data) => User(
    id: data['id'],
    email: data['email'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
    statusShipping: data['statusShipping'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'email': email,
    'name': name,
    'address': address,
    'phone': phone,
    'statusShipping': statusShipping,
  };

}