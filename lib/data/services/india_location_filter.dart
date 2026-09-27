/// Strict India-Only Location Filter & Validator
/// Mandate: Ministry of Earth Sciences (IMD) - Smart India Hackathon 2026
class IndiaLocationFilter {
  IndiaLocationFilter._();

  static const Set<String> blockedForeignLocations = {
    'switzerland', 'london', 'united kingdom', 'uk', 'england', 'britain',
    'united states', 'usa', 'america', 'new york', 'california', 'texas',
    'dubai', 'uae', 'united arab emirates', 'abu dhabi',
    'tokyo', 'japan', 'paris', 'france', 'berlin', 'germany',
    'canada', 'toronto', 'vancouver', 'australia', 'sydney', 'melbourne',
    'singapore', 'russia', 'moscow', 'china', 'beijing', 'shanghai',
    'pakistan', 'lahore', 'karachi', 'islamabad', 'bangladesh', 'dhaka',
    'sri lanka', 'colombo', 'nepal', 'kathmandu', 'bhutan', 'thimphu',
    'afghanistan', 'kabul', 'italy', 'rome', 'spain', 'madrid',
    'thailand', 'bangkok', 'malaysia', 'kuala lumpur', 'indonesia', 'jakarta',
    'maldives', 'male', 'europe', 'africa', 'north america', 'south america',
    'brazil', 'mexico', 'south africa', 'turkey', 'istanbul', 'egypt', 'cairo',
    'saudi arabia', 'riyadh', 'qatar', 'doha', 'kuwait', 'oman', 'muscat',
    'iran', 'tehran', 'iraq', 'baghdad', 'israel', 'netherlands', 'amsterdam',
    'belgium', 'brussels', 'sweden', 'stockholm', 'norway', 'oslo',
    'finland', 'helsinki', 'denmark', 'copenhagen', 'poland', 'warsaw',
    'ukraine', 'kyiv', 'greece', 'athens', 'portugal', 'lisbon',
    'austria', 'vienna', 'new zealand', 'auckland',
  };

  /// Checks if a query is attempting to search for an international/foreign place
  static bool isForeignQuery(String query) {
    final clean = query.trim().toLowerCase();
    if (clean.isEmpty) return false;

    // Direct match or contains foreign location token
    for (final foreign in blockedForeignLocations) {
      if (clean == foreign || clean.contains(foreign)) {
        return true;
      }
    }
    return false;
  }

  /// Checks if a location name or POI should be rejected as non-Indian
  static bool shouldRejectLocationName(String name) {
    final lower = name.toLowerCase();
    // Reject any embassy, consulate, or named after foreign place
    if (lower.contains('consulate') ||
        lower.contains('embassy') ||
        lower.contains('high commission')) {
      return true;
    }
    for (final foreign in blockedForeignLocations) {
      if (lower == foreign || lower.contains(foreign)) {
        return true;
      }
    }
    return false;
  }
}
