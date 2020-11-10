class Commerce{
  int id;
  String rif, name, address, phone, descriptionShopping;
  bool statusShopping;

  Commerce({this.id, this.rif, this.name, this.address, this.phone, this.statusShopping, this.descriptionShopping});

  factory Commerce.fromMap(dynamic data) => Commerce(
    id: data['id'],
    rif: data['rif'],
    name: data['name'],
    address: data['address'],
    phone: data['phone'],
    statusShopping: data['statusShopping'],
    descriptionShopping: data['descriptionShopping'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'rif': rif,
    'name': name,
    'address': address,
    'phone': phone,
    'statusShopping': statusShopping,
    'descriptionShopping': descriptionShopping,
  };

}