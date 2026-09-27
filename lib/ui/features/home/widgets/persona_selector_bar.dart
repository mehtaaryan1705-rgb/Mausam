import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/persona_type.dart';

class PersonaSelectorBar extends StatelessWidget {
  final List<PersonaType> activePersonas;
  final PersonaType? selectedFilter;
  final ValueChanged<PersonaType?> onFilterChanged;
  final VoidCallback onEditPersonas;

  const PersonaSelectorBar({
    super.key,
    required this.activePersonas,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onEditPersonas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // "All Active" Filter Chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: selectedFilter == null,
              showCheckmark: false,
              label: Text('All Feed (${activePersonas.length})'),
              onSelected: (_) => onFilterChanged(null),
              selectedColor: const Color(0xFF003366),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: selectedFilter == null ? Colors.white : Colors.black87,
              ),
              backgroundColor: Colors.white,
            ),
          ),

          // Chips for each active persona
          ...activePersonas.map((persona) {
            final isSelected = selectedFilter == persona;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                showCheckmark: false,
                avatar: Icon(
                  persona.icon,
                  size: 15,
                  color: isSelected ? Colors.white : persona.accentColor,
                ),
                label: Text(persona.title),
                onSelected: (selected) {
                  onFilterChanged(selected ? persona : null);
                },
                selectedColor: persona.accentColor,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            );
          }).toList(),

          // "+ Customize Personas" Action Chip
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: const Icon(Icons.tune_rounded, size: 15, color: Color(0xFF003366)),
              label: const Text('Customize', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              backgroundColor: const Color(0xFFE8EEF5),
              onPressed: onEditPersonas,
            ),
          ),
        ],
      ),
    );
  }
}
