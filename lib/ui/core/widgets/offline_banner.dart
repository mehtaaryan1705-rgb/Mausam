import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OfflineBanner extends StatelessWidget {
  final DateTime? lastUpdated;
  final VoidCallback onRetry;

  const OfflineBanner({
    super.key,
    required this.lastUpdated,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final timeString = lastUpdated != null
        ? DateFormat('hh:mm a, dd MMM').format(lastUpdated!)
        : 'Earlier';

    return Container(
      width: double.infinity,
      color: const Color(0xFFFFF3E0), // Soft amber
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            color: Color(0xFFE65100),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Working Offline (Degraded Mode)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFFE65100),
                  ),
                ),
                Text(
                  'Showing cached data from $timeString',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6D4C41),
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 16, color: Color(0xFFE65100)),
            label: const Text(
              'Retry',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFFE65100),
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
