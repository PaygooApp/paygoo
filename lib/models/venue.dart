class Venue {
  final String id;
  final String name;
  final String logoUrl;
  final String tableNumber;
  final double tableBillTotal;

  const Venue({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.tableNumber,
    required this.tableBillTotal,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      tableNumber: json['tableNumber'] as String,
      tableBillTotal: (json['tableBillTotal'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'tableNumber': tableNumber,
      'tableBillTotal': tableBillTotal,
    };
  }
}
