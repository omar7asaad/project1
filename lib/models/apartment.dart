// models/apartment.dart
class Apartment {
  final int id;
  final String title;
  final String description;
  final String governorate;
  final String city;
  final int price;
  final int rooms;
  final String image; // URL أو مسار

  const Apartment({
    required this.id,
    required this.title,
    required this.description,
    required this.governorate,
    required this.city,
    required this.price,
    required this.rooms,
    required this.image,
  });

  String get address => '$governorate - $city';

  factory Apartment.fromJson(Map<String, dynamic> json) {
    int _toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    return Apartment(
      id: _toInt(json['id']),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      governorate: (json['governorate'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      price: _toInt(json['price']),
      rooms: _toInt(json['rooms']),
      image: (json['image'] ?? '').toString(),
    );
  }
}
