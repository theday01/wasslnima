import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class PriceNegotiationStepper extends StatelessWidget {
  final int currentPriceMad;
  final int referencePriceMad;
  final ValueChanged<int> onPriceChanged;
  final int step;

  const PriceNegotiationStepper({
    Key? key,
    required this.currentPriceMad,
    required this.referencePriceMad,
    required this.onPriceChanged,
    this.step = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'اقترح سعرك للرحلة (درهم مغربي)',
            style: TextStyle(
              color: WasslniColors.lightTextSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decrease Button
              _buildStepButton(
                icon: Icons.remove,
                onPressed: () {
                  if (currentPriceMad > 10) {
                    onPriceChanged(currentPriceMad - step);
                  }
                },
              ),
              const SizedBox(width: 24),
              // Price Display
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$currentPriceMad',
                    style: const TextStyle(
                      color: WasslniColors.emerald800,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'MAD',
                    style: TextStyle(
                      color: WasslniColors.gold500,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              // Increase Button
              _buildStepButton(
                icon: Icons.add,
                onPressed: () {
                  onPriceChanged(currentPriceMad + step);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: WasslniColors.lightSurfaceRaised,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'السعر الموصى به: $referencePriceMad MAD',
              style: const TextStyle(
                color: WasslniColors.lightTextTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: WasslniColors.emerald50,
          shape: BoxShape.circle,
          border: Border.all(color: WasslniColors.emerald800.withOpacity(0.3)),
        ),
        child: Icon(icon, color: WasslniColors.emerald800, size: 22),
      ),
    );
  }
}
