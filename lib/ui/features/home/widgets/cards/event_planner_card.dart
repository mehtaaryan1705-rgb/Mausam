import 'package:flutter/material.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/ui/core/widgets/weather_badge.dart';

/// EventPlannerCard: Tailored for Wedding, Concert, Sports & Event Organizers
/// Features:
/// - Extended 7-10 day weather forecast trend
/// - Daily rain probability timeline
/// - Computed "Comfort Index" (0-100 formula combining temp, humidity, and wind)
/// - Event feasibility verdict (Ideal, Fair, Challenging)
///
/// Data Source Integration Point:
/// TODO: [IMD API] India Meteorological Department - Extended Range Forecast (ERF 7-15 days)
/// Real endpoint: https://mausam.imd.gov.in/api/forecast/extended_range
class EventPlannerCard extends StatelessWidget {
  final WeatherData weatherData;

  const EventPlannerCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final event = weatherData.eventPlanner;
    final theme = Theme.of(context);

    Color scoreColor;
    if (event.comfortIndexScore >= 80) {
      scoreColor = const Color(0xFF2E7D32); // Ideal
    } else if (event.comfortIndexScore >= 60) {
      scoreColor = const Color(0xFFF57C00); // Moderate
    } else {
      scoreColor = const Color(0xFFC62828); // Challenging
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
                    color: PersonaType.eventPlanners.accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    PersonaType.eventPlanners.icon,
                    color: PersonaType.eventPlanners.accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Planning & Outlook',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'IMD Extended Range Forecast (ERF)',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                WeatherBadge(
                  label: '${event.comfortIndexScore}/100 Comfort',
                  backgroundColor: scoreColor.withOpacity(0.12),
                  textColor: scoreColor,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Computed Comfort Index Display
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scoreColor.withOpacity(0.08),
                    scoreColor.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: scoreColor.withOpacity(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: scoreColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${event.comfortIndexScore}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.comfortCategory,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: scoreColor,
                              ),
                            ),
                            Text(
                              event.comfortFormulaBreakdown,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: event.comfortIndexScore / 100.0,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 7-Day Extended Forecast Scrollable Row
            Text(
              '7-Day Extended Weather Horizon',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 125,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: event.extendedForecast.length,
                separatorBuilder: (context, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final day = event.extendedForecast[index];
                  final isRainHigh = day.rainProbability > 50;

                  return Container(
                    width: 78,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isRainHigh ? const Color(0xFFE1F5FE) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isRainHigh ? const Color(0xFF81D4FA) : Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          day.day,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Text(
                          day.date,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                        Text(
                          '${day.tempMax.round()}° / ${day.tempMin.round()}°',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.umbrella_rounded,
                              size: 11,
                              color: isRainHigh ? const Color(0xFF0277BD) : Colors.grey,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${day.rainProbability}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isRainHigh ? const Color(0xFF0277BD) : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
