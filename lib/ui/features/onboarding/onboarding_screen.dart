import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/data/services/mock_weather_data.dart';
import 'package:mausam_app/viewmodels/persona_viewmodel.dart';
import 'package:mausam_app/viewmodels/weather_viewmodel.dart';
import 'package:mausam_app/ui/features/home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Set<PersonaType> _selectedPersonas = {
    PersonaType.healthConscious,
    PersonaType.outdoorFitness,
    PersonaType.commuters,
  };
  String _selectedCity = 'New Delhi';

  void _togglePersona(PersonaType persona) {
    setState(() {
      if (_selectedPersonas.contains(persona)) {
        if (_selectedPersonas.length > 1) {
          _selectedPersonas.remove(persona);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please select at least one persona profile to personalize your feed.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        _selectedPersonas.add(persona);
      }
    });
  }

  Future<void> _completeOnboarding() async {
    final personaVm = context.read<PersonaViewModel>();
    final weatherVm = context.read<WeatherViewModel>();

    await personaVm.setPersonas(_selectedPersonas.toList());
    await personaVm.setDefaultCity(_selectedCity);
    await personaVm.completeOnboarding();

    await weatherVm.changeCity(_selectedCity, isOfflineMode: personaVm.isOfflineDemoMode);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF003366), Color(0xFF0D47A1)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.wb_cloudy_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'मौसम • MAUSAM',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Ministry of Earth Sciences • Govt. of India',
                            style: TextStyle(fontSize: 11, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Personalize Your Weather Experience',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Select one or more profiles that match your lifestyle. Mausam adapts its forecast priorities to you.',
                    style: TextStyle(fontSize: 12.5, color: Color(0xFFE0E0E0)),
                  ),
                ],
              ),
            ),

            // Scrollable Selection Area
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // Location Chooser Section
                  const Text(
                    '1. Select Primary Location',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MockWeatherData.availableCities.map((city) {
                      final isSelected = _selectedCity == city;
                      final isCoastal = city == 'Mumbai' || city == 'Chennai';
                      return ChoiceChip(
                        selected: isSelected,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(city),
                            if (isCoastal) ...[
                              const SizedBox(width: 4),
                              const Icon(Icons.waves, size: 12),
                            ],
                          ],
                        ),
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedCity = city);
                        },
                        selectedColor: const Color(0xFF003366),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // 8 Personas Multi-Select Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '2. Choose Your Personas',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_selectedPersonas.length} Selected',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // List of 8 Personas
                  ...PersonaType.values.map((persona) {
                    final isSelected = _selectedPersonas.contains(persona);

                    return GestureDetector(
                      onTap: () => _togglePersona(persona),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? persona.accentColor.withOpacity(0.08)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? persona.accentColor
                                : Colors.grey.shade300,
                            width: isSelected ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? persona.accentColor
                                    : persona.accentColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                persona.icon,
                                color: isSelected ? Colors.white : persona.accentColor,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    persona.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? persona.accentColor
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    persona.description,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Source: ${persona.dataSourceName}',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w500,
                                      color: persona.accentColor.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: isSelected,
                              activeColor: persona.accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              onChanged: (_) => _togglePersona(persona),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            // Bottom CTA Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _completeOnboarding,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Continue to Mausam'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
