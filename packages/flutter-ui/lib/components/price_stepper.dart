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
        color: WasslniColors.darkSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: WasslniColors.darkBorder),
      ),
      child: Column(
        children: [
          const Text(
            'اقترح سعرك للرحلة (درهم مغربي)',
            style: TextStyle(
              color: WasslniColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
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
                      color: WasslniColors.textPrimary,
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'MAD',
                    style: TextStyle(
                      color: WasslniColors.gold500,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
          Text(
            'السعر الموصى به: $referencePriceMad MAD',
            style: const TextStyle(
              color: WasslniColors.textTertiary,
              fontSize: 12,
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
          color: WasslniColors.darkSurfaceRaised,
          shape: BoxShape.circle,
          border: Border.all(color: WasslniColors.darkBorder),
        ),
        child: Icon(icon, color: WasslniColors.gold500, size: 22),
      ),
    );
  }
}

