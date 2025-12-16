// screens/details_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/house.dart';
import '../controllers/house_controller.dart';

class DetailsScreen extends StatelessWidget {
  final House house;

  DetailsScreen({super.key, required this.house});

  final HouseController controller = Get.find<HouseController>();

  static const Color _primary = Color(0xFF054239);

  Widget _image() {
    if (house.isAssetImage) {
      return Image.asset(house.image, fit: BoxFit.cover);
    }
    return Image.network(
      house.image,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: Icon(Icons.image_not_supported_rounded, color: Colors.black.withOpacity(.45), size: 36),
      ),
    );
  }

  Widget _specChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: _primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(label, style: TextStyle(color: Colors.black.withOpacity(.55), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFav = controller.favorites.contains(house.id);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              tooltip: 'مفضلة',
              onPressed: () => controller.toggleFavorite(house.id),
              icon: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: isFav ? Colors.redAccent : Colors.white,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              width: double.infinity,
              child: _image(),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.black.withOpacity(.35),
                      Colors.black.withOpacity(.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.40,
              child: Container(
                padding: const EdgeInsets.only(top: 18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // السعر + العنوان
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${controller.formatPrice(house.price)}',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              color: _primary.withOpacity(.10),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'منذ قليل',
                              style: TextStyle(color: _primary, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(house.address, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                      const SizedBox(height: 16),

                      // مواصفات
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _specChip(Icons.meeting_room_rounded, '${house.rooms}', 'عدد الغرف'),
                          _specChip(Icons.bed_rounded, '${house.beds}', 'غرف نوم'),
                          _specChip(Icons.bathtub_rounded, '${house.baths}', 'حمامات'),
                          _specChip(Icons.square_foot_rounded, house.area == 0 ? '—' : '${house.area}', 'المساحة'),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Text('الوصف', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                      Text(
                        house.description,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // زر احجز الآن
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (range == null) return;

                try {
                  await controller.bookNow(
                    apartmentId: house.id,
                    start: range.start,
                    end: range.end,
                  );

                  Get.snackbar(
                    'تم',
                    'تم إرسال طلب الحجز بنجاح',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                  );
                } catch (e) {
                  final msg = e.toString();
                  final conflict = msg.contains('409');

                  Get.snackbar(
                    'تنبيه',
                    conflict ? 'التاريخ محجوز، اختر فترة أخرى' : 'فشل الحجز: $msg',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: conflict ? Colors.orange : Colors.red,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('احجز الآن', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
          ),
        ),
      ),
    );
  }
}
