import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.field,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => onChanged(quantity - 1),
            icon: Icon(
              quantity <= 1 ? Icons.delete_outline : Icons.remove,
              size: 18,
            ),
          ),
          Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w700)),
          IconButton(
            onPressed: () => onChanged(quantity + 1),
            icon: const Icon(Icons.add, color: AppColors.primary, size: 18),
          ),
        ],
      ),
    );
  }
}
