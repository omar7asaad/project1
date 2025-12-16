// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_apartment_screen.dart';
import '../controllers/house_controller.dart';
import '../widgets/house_card.dart';
import 'details_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HouseController controller = Get.isRegistered<HouseController>()
      ? Get.find<HouseController>()
      : Get.put(HouseController(), permanent: true);

  static const Color _primary = Color(0xFF054239);
  static const Color _gold = Color(0xFFB9A779);

  Future<void> _openFilters(BuildContext context) async {
    final govCtrl = TextEditingController(text: controller.governorate.value);
    final cityCtrl = TextEditingController(text: controller.city.value);
    final minCtrl = TextEditingController(text: controller.minPrice.value?.toString() ?? '');
    final maxCtrl = TextEditingController(text: controller.maxPrice.value?.toString() ?? '');
    final roomsCtrl = TextEditingController(text: controller.rooms.value?.toString() ?? '');

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('فلترة الشقق', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),

                TextField(
                  controller: govCtrl,
                  decoration: const InputDecoration(labelText: 'المحافظة', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: cityCtrl,
                  decoration: const InputDecoration(labelText: 'المدينة', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: minCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'أقل سعر', border: OutlineInputBorder()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: maxCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'أعلى سعر', border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: roomsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'عدد الغرف', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await controller.applyFilters(
                            governorateValue: '',
                            cityValue: '',
                            minPriceValue: null,
                            maxPriceValue: null,
                            roomsValue: null,
                          );
                        },
                        child: const Text('مسح الفلترة'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () async {
                          int? toInt(String s) => int.tryParse(s.trim());
                          Navigator.pop(context);
                          await controller.applyFilters(
                            governorateValue: govCtrl.text,
                            cityValue: cityCtrl.text,
                            minPriceValue: minCtrl.text.trim().isEmpty ? null : toInt(minCtrl.text),
                            maxPriceValue: maxCtrl.text.trim().isEmpty ? null : toInt(maxCtrl.text),
                            roomsValue: roomsCtrl.text.trim().isEmpty ? null : toInt(roomsCtrl.text),
                          );
                        },
                        child: const Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _gold.withOpacity(.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _gold.withOpacity(.30)),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black.withOpacity(.75)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
  onPressed: () => Get.to(() => const AddApartmentScreen()),
  backgroundColor: const Color(0xFF054239),
  child: const Icon(Icons.add_rounded, color: Colors.white),
),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('العقارات', style: TextStyle(fontWeight: FontWeight.w900)),
          actions: [
            IconButton(
              tooltip: 'فلترة',
              onPressed: () => _openFilters(context),
              icon: const Icon(Icons.tune_rounded, color: Colors.black87),
            ),
          ],
        ),
        body: Column(
          children: [
            // بحث + مفضلة فقط
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.setSearch,
                      decoration: InputDecoration(
                        hintText: 'ابحث (عنوان، مدينة، وصف...)',
                        prefixIcon: const Icon(Icons.search_rounded),
                        filled: true,
                        fillColor: Colors.black.withOpacity(.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(() {
                    final onlyFav = controller.favoritesOnly.value;
                    return InkWell(
                      onTap: controller.toggleFavoritesOnly,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: onlyFav ? _primary : Colors.black.withOpacity(.04),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          onlyFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: onlyFav ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // شرائح فلاتر حالية
            Obx(() {
              final chips = <Widget>[];
              if (controller.governorate.value.isNotEmpty) chips.add(_chip('المحافظة: ${controller.governorate.value}'));
              if (controller.city.value.isNotEmpty) chips.add(_chip('المدينة: ${controller.city.value}'));
              if (controller.minPrice.value != null) chips.add(_chip('من: ${controller.minPrice.value}'));
              if (controller.maxPrice.value != null) chips.add(_chip('إلى: ${controller.maxPrice.value}'));
              if (controller.rooms.value != null) chips.add(_chip('غرف: ${controller.rooms.value}'));
              if (chips.isEmpty) return const SizedBox.shrink();

              return SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) => chips[i],
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemCount: chips.length,
                ),
              );
            }),

            const SizedBox(height: 6),

            // قائمة الشقق
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(controller.error.value, textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: controller.fetchHouses,
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final list = controller.visibleHouses;
                if (list.isEmpty) return const Center(child: Text('لا توجد نتائج'));

                return RefreshIndicator(
                  onRefresh: controller.fetchHouses,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 6, bottom: 20),
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final h = list[i];
                      final fav = controller.favorites.contains(h.id);

                      return HouseCard(
                        house: h,
                        isFavorite: fav,
                        onToggleFavorite: () => controller.toggleFavorite(h.id),
                        onTap: () => Get.to(() => DetailsScreen(house: h)),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
