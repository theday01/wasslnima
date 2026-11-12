import 'package:flutter/material.dart';
import '../wasslni_theme.dart';

class SosAlertButton extends StatelessWidget {
  final VoidCallback onTrigger;

  const SosAlertButton({Key? key, required this.onTrigger}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTrigger,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: WasslniColors.error.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: WasslniColors.error, width: 1.5),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, color: WasslniColors.error, size: 18),
            SizedBox(width: 6),
            Text(
              'SOS طوارئ (19/15)',
              style: TextStyle(
                color: WasslniColors.error,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

