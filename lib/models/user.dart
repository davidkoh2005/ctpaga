class User{
  int id;
  String email, name, address, phone;

  User({this.id, this.email, this.name, this.address, this.phone});

  factory User.fromMap(dynamic data) => User(
    id: data['id'],
    email: data['email'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'email': email,
    'name': name,
    'address': address,
    'phone': phone,
  };

}