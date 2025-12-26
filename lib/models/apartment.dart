// models/apartment.dart
// ============================================================
// apartment_model.dart - نموذج الشقة
// ============================================================

class Apartment {
  final int id;
  final String title;
  final String description;
  final String governorate;
  final String city;
  final double price;
  final int rooms;
  final String image; // URL أو مسار حسب الباك

  Apartment({
    required this.id,
    required this.title,
    required this.description,
    required this.governorate,
    required this.city,
    required this.price,
    required this.rooms,
    required this.image,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    return Apartment(
      id: toInt(json['id']),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      governorate: (json['governorate'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      price: toDouble(json['price']),
      rooms: toInt(json['rooms']),
      image: (json['image'] ?? '').toString(),
    );
  }
}
