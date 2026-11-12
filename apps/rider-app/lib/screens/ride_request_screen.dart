import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'live_offers_screen.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({Key? key}) : super(key: key);

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  int _suggestedPriceMad = 30;
  final int _referencePriceMad = 28;
  String _selectedCategory = 'ECO';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasslniColors.darkCanvas,
      appBar: AppBar(
        backgroundColor: WasslniColors.darkSurface,
        elevation: 0,
        title: const Text(
          'طلب رحلة جديدة',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address & Landmark Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: WasslniColors.darkSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: WasslniColors.darkBorder),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.circle, color: Color(0xFF10B981), size: 14),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'الانطلاق: شارع الزرقطوني (المعاريف)',
                            style: TextStyle(
                              color: WasslniColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: WasslniColors.darkBorder, height: 18),
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Color(0xFFEF4444), size: 16),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'الوجهة: موروكو مول، عين الذياب',
                            style: TextStyle(
                              color: WasslniColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Moroccan Landmark info box
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: WasslniColors.darkSurfaceRaised,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: WasslniColors.gold500, size: 16),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'المعلم: "قبالة الباب رقم 2 حدا النافورة الكبيرة"',
                              style: TextStyle(
                                color: WasslniColors.gold500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Categories Row
              Row(
                children: [
                  _buildCategoryCard('ECO', 'اقتصادي', '28 MAD', '🚗'),
                  const SizedBox(width: 8),
                  _buildCategoryCard('CONFORT', 'مريح', '38 MAD', '🚘'),
                  const SizedBox(width: 8),
                  _buildCategoryCard('WOMEN', 'سائقة فقط', '28 MAD', '👩'),
                ],
              ),

              const SizedBox(height: 20),

              // Moroccan inDrive Price Stepper Component
              PriceNegotiationStepper(
                currentPriceMad: _suggestedPriceMad,
                referencePriceMad: _referencePriceMad,
                onPriceChanged: (newPrice) {
                  setState(() => _suggestedPriceMad = newPrice);
                },
              ),

              const SizedBox(height: 16),

              // Payment method
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: WasslniColors.darkSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: WasslniColors.darkBorder),
                ),
                child: const Row(
                  children: [
                    Text('💵', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'طريقة الدفع: نقداً (كاش للسائق)',
                        style: TextStyle(
                          color: WasslniColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      'تغيير',
                      style: TextStyle(
                        color: WasslniColors.gold500,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              WasslniButton(
                text: 'ابحث عن سائقين بـ $_suggestedPriceMad MAD',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LiveOffersScreen(suggestedPriceMad: _suggestedPriceMad),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String id, String title, String fare, String emoji) {
    final isSelected = _selectedCategory == id;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = id),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? WasslniColors.gold500.withOpacity(0.12) : WasslniColors.darkSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? WasslniColors.gold500 : WasslniColors.darkBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: WasslniColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                fare,
                style: const TextStyle(
                  color: WasslniColors.gold500,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

