import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/data/services/mock_weather_data.dart';
import 'package:mausam_app/viewmodels/persona_viewmodel.dart';
import 'package:mausam_app/viewmodels/weather_viewmodel.dart';
import 'package:mausam_app/ui/features/onboarding/onboarding_screen.dart';
import 'package:mausam_app/ui/features/language/language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showDataSourceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.account_balance_rounded, color: Color(0xFF003366), size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Official Government Data Sources',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildSourceRow(
                title: 'IMD (India Meteorological Department)',
                subtitle: 'Surface AWS, Doppler Radar Nowcast, Extended Range & Agromet (GKMS)',
                color: const Color(0xFF0D47A1),
              ),
              const SizedBox(height: 10),
              _buildSourceRow(
                title: 'CPCB (Central Pollution Control Board)',
                subtitle: 'National Air Quality Index (NAQI) & CAAQMS Pollutant Feeds (PM2.5/PM10)',
                color: const Color(0xFF00796B),
              ),
              const SizedBox(height: 10),
              _buildSourceRow(
                title: 'INCOIS (Indian National Centre for Ocean Info)',
                subtitle: 'Ocean State Forecast (OSF), Swell Surge alerts, High/Low Tide tables',
                color: const Color(0xFF0277BD),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildSourceRow({
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 11.5, color: Colors.black87)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final personaVm = context.watch<PersonaViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Preferences'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Persona Customization
          Text(
            'ACTIVE PERSONA PROFILES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Turn cards on or off based on your current routine and activities.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: PersonaType.values.map((persona) {
                final isSelected = personaVm.selectedPersonas.contains(persona);
                return SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: persona.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(persona.icon, color: persona.accentColor, size: 20),
                  ),
                  title: Text(
                    persona.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    persona.description,
                    style: const TextStyle(fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  value: isSelected,
                  activeColor: persona.accentColor,
                  onChanged: (_) => personaVm.togglePersona(persona),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Section 2: Language Preference
          Text(
            'LANGUAGE • भाषा',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF003366).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.translate_rounded, color: Color(0xFF003366), size: 20),
              ),
              title: Text(
                personaVm.languageCode == 'hi' ? 'हिंदी (Hindi)' : 'English',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Text(
                personaVm.languageCode == 'hi'
                    ? 'भारत की राजभाषा • Tap to switch language'
                    : 'Official National English • भाषा बदलने के लिए टैप करें',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const LanguageScreen(isSettingsMode: true),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Section 3: Primary Location
          Text(
            'PRIMARY CITY',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Icons.location_city_rounded, color: Color(0xFF003366)),
              title: Text(
                personaVm.defaultCity,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Default weather station for app launch'),
              trailing: DropdownButton<String>(
                value: personaVm.defaultCity,
                underline: const SizedBox(),
                items: MockWeatherData.availableCities.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (newCity) {
                  if (newCity != null) {
                    personaVm.setDefaultCity(newCity);
                    weatherVm.changeCity(newCity, isOfflineMode: personaVm.isOfflineDemoMode);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Section 3: Offline & Caching Controls
          Text(
            'OFFLINE & CACHING (SIH DEMO)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Test the offline-first resiliency with simulated connectivity drops.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 8),

          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.cloud_off_rounded, color: Color(0xFFE65100)),
                  title: const Text('Offline Demo Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Forces app to serve last-cached SharedPreferences payload'),
                  value: personaVm.isOfflineDemoMode,
                  activeColor: const Color(0xFFE65100),
                  onChanged: (_) async {
                    await personaVm.toggleOfflineDemoMode();
                    await weatherVm.loadWeather(
                      forceRefresh: false,
                      isOfflineMode: personaVm.isOfflineDemoMode,
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline_rounded, color: Color(0xFF00796B)),
                  title: const Text('Data Source Attribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('View IMD, CPCB & INCOIS integration endpoints'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showDataSourceModal(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restart_alt_rounded, color: Colors.red),
                  title: const Text('Re-run Persona Onboarding', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Reset persona setup and restart onboarding'),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Footer
          Center(
            child: Column(
              children: const [
                Text(
                  'Mausam 2.0 • SIH 2026 PS 26076',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Ministry of Earth Sciences, Government of India',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
