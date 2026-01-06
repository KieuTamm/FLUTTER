import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onSelected;

  const FilterChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;
          return ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (_) => onSelected(cat),
            selectedColor: const Color(0xFF1976D2),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          );
        },
      ),
    );
  }
}
