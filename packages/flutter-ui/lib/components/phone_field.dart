import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class MoroccanPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const MoroccanPhoneField({
    Key? key,
    required this.controller,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: WasslniColors.lightBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          // Flag and country code badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: WasslniColors.emerald50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: WasslniColors.emerald800.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.flag_rounded, color: Color(0xFFC1272D), size: 18),
                SizedBox(width: 6),
                Text(
                  '+212',
                  style: TextStyle(
                    color: WasslniColors.emerald800,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Phone Input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: WasslniColors.lightTextPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              decoration: const InputDecoration(
                hintText: '6 12 34 56 78',
                hintStyle: TextStyle(
                  color: WasslniColors.lightTextTertiary,
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
