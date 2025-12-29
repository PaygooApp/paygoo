class Venue {
  final String id;
  final String name;
  final String logoUrl;
  final String tableNumber;

  const Venue({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.tableNumber,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String,
      tableNumber: json['tableNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'tableNumber': tableNumber,
    };
  }
}

