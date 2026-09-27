import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/ui/core/widgets/weather_badge.dart';

/// AgricultureCard: Tailored for Farmers, Agronomists & Gardeners
/// Features:
/// - Estimated Soil Moisture %
/// - 48-hour rainfall forecast in mm
/// - Frost and Heatwave warnings
/// - Monthly & regional seasonal planting advisory
/// - Recommended pesticide / irrigation interventions
///
/// Data Source Integration Point:
/// TODO: [IMD API] India Meteorological Department - Agromet Advisory Services (AAS / GKMS)
/// Real endpoint: https://agromet.imd.gov.in/district_bulletin_api
class AgricultureCard extends StatelessWidget {
  final WeatherData weatherData;

  const AgricultureCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final agro = weatherData.agriculture;
    final theme = Theme.of(context);

    if (!weatherData.isIndia) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: PersonaType.agricultureGardeners.accentColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      PersonaType.agricultureGardeners.icon,
                      color: PersonaType.agricultureGardeners.accentColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Agriculture & Gardening',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const WeatherBadge(
                    label: 'MoES Mandate',
                    backgroundColor: Color(0xFFE8F5E9),
                    textColor: Color(0xFF2E7D32),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'IMD Agromet Advisory Services (GKMS) and district agricultural bulletins are provided for Indian agricultural zones under the Ministry of Earth Sciences mandate.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: PersonaType.agricultureGardeners.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PersonaType.agricultureGardeners.icon,
                    color: PersonaType.agricultureGardeners.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agriculture & Gardening',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'IMD Agromet Advisory (GKMS)',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                WeatherBadge(
                  label: '${agro.soilMoisturePercent}% Moisture',
                  backgroundColor: const Color(0xFFE8F5E9),
                  textColor: const Color(0xFF2E7D32),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Frost or Heatwave Alert
            if (agro.frostAlert || agro.heatwaveAlert) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEF9A9A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Color(0xFFC62828), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        agro.frostAlert
                            ? 'FROST ALERT: Cover sensitive seedlings and irrigate during night.'
                            : 'HEATWAVE ALERT: High crop evapotranspiration. Frequent light irrigation required.',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFFC62828)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Soil Moisture Gauge & 48h Rain Prediction
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFDCEDC8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estimated Soil Moisture',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF33691E)),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${agro.soilMoisturePercent}%',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF33691E)),
                            ),
                            const Spacer(),
                            const Icon(Icons.grass_rounded, color: Color(0xFF558B2F), size: 28),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: agro.soilMoisturePercent / 100.0,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF558B2F)),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB3E5FC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rainfall (Next 48h)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF01579B)),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${agro.rainfallPrediction48hMm} mm',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF01579B)),
                            ),
                            const Spacer(),
                            const Icon(Icons.grain_rounded, color: Color(0xFF0288D1), size: 28),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          agro.rainfallPrediction48hMm > 15 ? 'Significant rain expected' : 'Light scattered showers',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF0277BD)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Seasonal Planting Tip & Field Action
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.eco_rounded, size: 16, color: Color(0xFF2E7D32)),
                      SizedBox(width: 6),
                      Text(
                        'Seasonal Agromet Advice',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    agro.seasonalCropTip,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.checklist_rounded, size: 16, color: Color(0xFFF57F17)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Action: ${agro.recommendedAction}',
                            style: const TextStyle(fontSize: 11.5, color: Color(0xFF5D4037)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
