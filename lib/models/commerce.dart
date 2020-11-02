class Commerce{
  int id;
  String rif, name, address, phone;

  Commerce({this.id, this.rif, this.name, this.address, this.phone});

  factory Commerce.fromMap(dynamic data) => Commerce(
    id: data['id'],
    rif: data['rif'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'rif': rif,
    'name': name,
    'address': address,
    'phone': phone,


  };

}