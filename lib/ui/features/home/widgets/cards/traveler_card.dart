import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';

/// TravelerCard: Tailored for Travelers & Commuters Visiting Other Cities
/// Features:
/// - Saved destinations list with live conditions and severe alerts
/// - Add/Remove destination dialog
/// - Rule-based packing suggestion generator
///
/// Data Source Integration Point:
/// TODO: [IMD API] India Meteorological Department - Multi-City All India Forecast & Warnings
/// Real endpoint: https://mausam.imd.gov.in/api/national/city_warnings
class TravelerCard extends StatelessWidget {
  final WeatherData weatherData;
  final VoidCallback? onManageDestinations;

  const TravelerCard({
    super.key,
    required this.weatherData,
    this.onManageDestinations,
  });

  @override
  Widget build(BuildContext context) {
    final traveler = weatherData.traveler;
    final theme = Theme.of(context);

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
                    color: PersonaType.travelers.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PersonaType.travelers.icon,
                    color: PersonaType.travelers.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Travel & Destination Hub',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'IMD Multi-City Radar & Warnings',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_location_alt_outlined, size: 20),
                  tooltip: 'Manage Destinations',
                  onPressed: onManageDestinations,
                  color: PersonaType.travelers.accentColor,
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Saved Destinations Carousel / Cards
            Text(
              'Saved Travel Destinations',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 105,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: traveler.savedDestinations.length,
                separatorBuilder: (context, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final dest = traveler.savedDestinations[index];
                  final hasAlert = dest.alert != null;

                  return Container(
                    width: 160,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: hasAlert
                          ? const Color(0xFFFFF8E1)
                          : const Color(0xFFF3E5F5).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: hasAlert
                            ? const Color(0xFFFFB300)
                            : const Color(0xFFBA68C8).withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              dest.city,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${dest.temp.round()}°C',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dest.condition,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        if (hasAlert) ...[
                          Row(
                            children: [
                              const Icon(Icons.warning_rounded, size: 12, color: Color(0xFFE65100)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  dest.alert!,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFBF360C),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            children: [
                              const Icon(Icons.umbrella_rounded, size: 12, color: Colors.blue),
                              const SizedBox(width: 4),
                              Text(
                                '${dest.rainProbability}% Rain',
                                style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Rule-Based Packing Suggestion Generator
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7F6).withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFD1C4E9)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.backpack_rounded, size: 18, color: Color(0xFF5E35B1)),
                      SizedBox(width: 8),
                      Text(
                        'Smart Packing Assistant',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Color(0xFF4527A0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...traveler.packingSuggestions.map((tip) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5E35B1))),
                          Expanded(
                            child: Text(
                              tip,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF311B92)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
