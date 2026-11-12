import 'package:flutter/material.dart';
import 'package:flutter_ui/flutter_ui.dart';
import 'live_offers_screen.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({Key? key}) : super(key: key);

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _destController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  int _suggestedPriceMad = 25;
  int _referencePriceMad = 25;
  String _selectedCategory = 'ECO';

  @override
  void dispose() {
    _pickupController.dispose();
    _destController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _handleSubmitRequest() {
    final pickup = _pickupController.text.trim();
    final dest = _destController.text.trim();
    final landmark = _landmarkController.text.trim();

    if (pickup.isEmpty || dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('المرجو إدخال نقطة الانطلاق والوجهة أولاً'),
          backgroundColor: WasslniColors.error,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LiveOffersScreen(
          suggestedPriceMad: _suggestedPriceMad,
          pickupLocation: pickup,
          destinationLocation: dest,
          landmarkNote: landmark.isNotEmpty ? landmark : null,
          category: _selectedCategory,
        ),
      ),
    );
  }

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
              // Real Interactive Inputs for Pickup & Destination
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WasslniColors.darkSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: WasslniColors.darkBorder),
                ),
                child: Column(
                  children: [
                    // Pickup input
                    Row(
                      children: [
                        const Icon(Icons.circle, color: Color(0xFF10B981), size: 14),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _pickupController,
                            style: const TextStyle(
                              color: WasslniColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'من أين تنطلق؟ (مثال: محطة القطار، المعاريف...)',
                              hintStyle: TextStyle(
                                color: WasslniColors.textTertiary,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: WasslniColors.darkBorder, height: 20),
                    // Destination input
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFFEF4444), size: 16),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _destController,
                            style: const TextStyle(
                              color: WasslniColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'إلى أين تريد الذهاب؟ (مثال: موروكو مول، كازابورت...)',
                              hintStyle: TextStyle(
                                color: WasslniColors.textTertiary,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: WasslniColors.darkBorder, height: 20),
                    // Optional Landmark
                    Row(
                      children: [
                        const Icon(Icons.bookmark_border, color: WasslniColors.gold500, size: 16),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _landmarkController,
                            style: const TextStyle(
                              color: WasslniColors.gold500,
                              fontSize: 13,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'معلم قريب لتسهيل اللقاء (اختياري: حدا الصيدلية، قبالة بيم...)',
                              hintStyle: TextStyle(
                                color: WasslniColors.textTertiary,
                                fontSize: 12,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Categories Row with Professional Vector Icons
              Row(
                children: [
                  _buildCategoryCard('ECO', 'اقتصادي', '25 MAD', Icons.directions_car),
                  const SizedBox(width: 8),
                  _buildCategoryCard('CONFORT', 'مريح VIP', '35 MAD', Icons.airline_seat_recline_extra),
                  const SizedBox(width: 8),
                  _buildCategoryCard('WOMEN', 'سائقة فقط', '25 MAD', Icons.female),
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

              // Payment method with Vector Icon
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: WasslniColors.darkSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: WasslniColors.darkBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.payments_outlined, color: WasslniColors.gold500, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'طريقة الدفع: نقداً (كاش مباشرة للسائق)',
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
                onPressed: _handleSubmitRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String id, String title, String fare, IconData icon) {
    final isSelected = _selectedCategory == id;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedCategory = id;
            if (id == 'CONFORT') {
              _suggestedPriceMad = 35;
              _referencePriceMad = 35;
            } else {
              _suggestedPriceMad = 25;
              _referencePriceMad = 25;
            }
          });
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? WasslniColors.emerald800.withOpacity(0.4) : WasslniColors.darkSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? WasslniColors.gold500 : WasslniColors.darkBorder,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? WasslniColors.gold500 : WasslniColors.textSecondary,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : WasslniColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                fare,
                style: TextStyle(
                  color: isSelected ? WasslniColors.gold500 : WasslniColors.textTertiary,
                  fontSize: 10,
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
