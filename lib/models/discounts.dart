class Discounts{
  int? id, percentage;
  String? code;

  Discounts({this.id, this.code, this.percentage});

  factory Discounts.fromMap(dynamic data) => Discounts(
    id: data['id'],
    code: data['code'],
    percentage: data['percentage'],
  );

  Map<String, dynamic> toJson()=> {
    'id': id,
    'code': code,
    'percentage': percentage,
  };

}