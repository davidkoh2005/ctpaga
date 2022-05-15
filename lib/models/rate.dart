class Rate{
  // ignore: non_constant_identifier_names
  int? id;
  String? rate, date;

  // ignore: non_constant_identifier_rates
  Rate({this.id, this.rate,  this.date});

  factory Rate.fromMap(dynamic data) => Rate(
    id: data['id'],
    rate: data['rate'],
    date: data['date'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'rate': rate,
    'date': date,
  };

}