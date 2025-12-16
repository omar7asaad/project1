// models/house.dart
class House {
  // ✅ id ضروري للباك (apartments/{id} و booking)
  final int id;

  // بيانات الشقة
  final String title;
  final String governorate;
  final String city;
  final String image; // URL أو assets
  final int price;
  final int rooms; // عدد الغرف (من الباك)
  final String description;

  // ✅ حقول لواجهاتك القديمة (اختيارية)
  final int beds;
  final int baths;
  final double area;

  const House({
    required this.id,
    required this.title,
    required this.governorate,
    required this.city,
    required this.image,
    required this.price,
    required this.rooms,
    required this.description,
    this.beds = 0,
    this.baths = 1,
    this.area = 0,
  });

  String get address => '$governorate - $city';
  bool get isAssetImage => image.startsWith('assets/');

  factory House.fromJson(Map<String, dynamic> json, {required String baseUrl}) {
    int toInt(dynamic v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    double toDouble(dynamic v) {
      if (v is double) return v;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    String img = (json['image'] ?? '').toString();
    // إذا رجع مسار مثل /media/xx.jpg نركّبه على baseUrl
    if (img.isNotEmpty &&
        !(img.startsWith('http://') || img.startsWith('https://')) &&
        !img.startsWith('assets/')) {
      img = '$baseUrl$img';
    }

    final rooms = toInt(json['rooms']);

    return House(
      id: toInt(json['id']),
      title: (json['title'] ?? '').toString(),
      governorate: (json['governorate'] ?? '').toString(),
      city: (json['city'] ?? '').toString(),
      image: img,
      price: toInt(json['price']),
      rooms: rooms,
      description: (json['description'] ?? '').toString(),

      // واجهاتك (قِيَم افتراضية لطيفة)
      beds: rooms == 0 ? 1 : rooms,
      baths: toInt(json['baths']) == 0 ? 1 : toInt(json['baths']), // إن وجد
      area: toDouble(json['area']), // إن وجد
    );
  }
}
