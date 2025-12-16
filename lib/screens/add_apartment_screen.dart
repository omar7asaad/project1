// screens/add_apartment_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/house_controller.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final HouseController controller = Get.find<HouseController>();

  final _formKey = GlobalKey<FormState>();

  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final govCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final roomsCtrl = TextEditingController();

  String? imagePath;

  static const Color _primary = Color(0xFF054239);

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    govCtrl.dispose();
    cityCtrl.dispose();
    priceCtrl.dispose();
    roomsCtrl.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (file != null) {
      setState(() => imagePath = file.path);
    }
  }

  int? _toInt(String s) => int.tryParse(s.trim());

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (imagePath == null || imagePath!.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'الرجاء اختيار صورة للشقة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    final price = _toInt(priceCtrl.text);
    final rooms = _toInt(roomsCtrl.text);

    if (price == null || price <= 0 || rooms == null || rooms <= 0) {
      Get.snackbar(
        'خطأ',
        'تأكد من السعر وعدد الغرف',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    try {
      await controller.addApartment(
        title: titleCtrl.text,
        description: descCtrl.text,
        governorate: govCtrl.text,
        city: cityCtrl.text,
        price: price,
        rooms: rooms,
        imagePath: imagePath!,
      );

      Get.snackbar(
        'تم',
        'تمت إضافة الشقة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );

      Get.back(); // رجوع للقائمة
 } catch (e) {
  final msg = e.toString().replaceFirst('Exception: ', '');

  Get.snackbar(
    'فشل',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
  );
}

  }

  InputDecoration _dec(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon == null ? null : Icon(icon),
      filled: true,
      fillColor: Colors.black.withOpacity(.04),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('إضافة شقة جديدة', style: TextStyle(fontWeight: FontWeight.w900)),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // صورة
                InkWell(
                  onTap: pickImage,
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    height: 210,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.black.withOpacity(.04),
                      border: Border.all(color: Colors.black12.withOpacity(.06)),
                    ),
                    child: imagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_rounded, size: 38, color: Colors.black.withOpacity(.45)),
                              const SizedBox(height: 10),
                              Text('اضغط لاختيار صورة', style: TextStyle(color: Colors.black.withOpacity(.65), fontWeight: FontWeight.w700)),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(File(imagePath!), fit: BoxFit.cover),
                          ),
                  ),
                ),

                const SizedBox(height: 14),

                TextFormField(
                  controller: titleCtrl,
                  decoration: _dec('عنوان الشقة', icon: Icons.title_rounded),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'العنوان مطلوب' : null,
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: govCtrl,
                  decoration: _dec('المحافظة', icon: Icons.map_rounded),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'المحافظة مطلوبة' : null,
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: cityCtrl,
                  decoration: _dec('المدينة', icon: Icons.location_city_rounded),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'المدينة مطلوبة' : null,
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _dec('السعر', icon: Icons.payments_rounded),
                        validator: (v) => (v == null || int.tryParse(v.trim()) == null) ? 'أدخل رقم صحيح' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: roomsCtrl,
                        keyboardType: TextInputType.number,
                        decoration: _dec('عدد الغرف', icon: Icons.meeting_room_rounded),
                        validator: (v) => (v == null || int.tryParse(v.trim()) == null) ? 'أدخل رقم صحيح' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: descCtrl,
                  decoration: _dec('وصف الشقة', icon: Icons.description_rounded),
                  minLines: 4,
                  maxLines: 7,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'الوصف مطلوب' : null,
                ),

                const SizedBox(height: 16),

                Obx(() {
                  final loading = controller.isLoading.value;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: loading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('نشر الشقة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
