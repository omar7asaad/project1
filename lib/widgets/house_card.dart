// widgets/house_card.dart
import 'package:flutter/material.dart';
import '../models/house.dart';

class HouseCard extends StatelessWidget {
  final House house;
  final VoidCallback onTap;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const HouseCard({
    super.key,
    required this.house,
    required this.onTap,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  static const Color _primary = Color(0xFF054239);
  static const Color _gold = Color(0xFFB9A779);

  String _formatPrice(int v) {
    final s = v.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
  }

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
        child: Icon(Icons.image_not_supported_rounded, color: Colors.black.withOpacity(.45), size: 34),
      ),
    );
  }

  Widget _pill(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.black12.withOpacity(.06)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  child: Stack(
                    children: [
                      SizedBox(height: 210, width: double.infinity, child: _image()),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(.20),
                                Colors.black.withOpacity(.00),
                                Colors.black.withOpacity(.62),
                              ],
                              stops: const [0.0, 0.55, 1.0],
                            ),
                          ),
                        ),
                      ),
                      Positioned(right: 14, top: 14, child: _pill(Icons.meeting_room_rounded, '${house.rooms} غرف')),
                      Positioned(
                        left: 14,
                        top: 14,
                        child: InkWell(
                          onTap: onToggleFavorite,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.20),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isFavorite ? Colors.redAccent : Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        bottom: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
                            color: _primary,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: _primary.withOpacity(.25),
                                blurRadius: 18,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Text(
                            '\$${_formatPrice(house.price)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14.5),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 14,
                        left: 140,
                        bottom: 16,
                        child: Text(
                          house.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15.5),
                        ),
                      ),
                      Positioned(
                        right: 14,
                        bottom: 44,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            color: _gold.withOpacity(.20),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            house.address,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Text(
                    house.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black.withOpacity(.65),
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
