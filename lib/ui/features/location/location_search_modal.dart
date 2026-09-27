import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/location_result.dart';
import '../../../data/services/india_location_filter.dart';
import '../../../viewmodels/weather_viewmodel.dart';
import '../../../viewmodels/persona_viewmodel.dart';

class LocationSearchModal extends StatefulWidget {
  const LocationSearchModal({super.key});

  static Future<LocationResult?> show(BuildContext context) {
    return showModalBottomSheet<LocationResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LocationSearchModal(),
    );
  }

  @override
  State<LocationSearchModal> createState() => _LocationSearchModalState();
}

class _LocationSearchModalState extends State<LocationSearchModal> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;

  List<LocationResult> _searchResults = [];
  bool _isSearching = false;
  bool _isGpsLoading = false;
  String? _gpsError;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    _debounceTimer?.cancel();

    if (query.length < 2) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 350), () async {
      if (!mounted) return;
      final weatherVm = context.read<WeatherViewModel>();
      final results = await weatherVm.searchLocations(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  Future<void> _handleGpsLocation() async {
    setState(() {
      _isGpsLoading = true;
      _gpsError = null;
    });

    final weatherVm = context.read<WeatherViewModel>();
    final personaVm = context.read<PersonaViewModel>();

    final err = await weatherVm.useCurrentGpsLocation(
      isOfflineMode: personaVm.isOfflineDemoMode,
    );

    if (mounted) {
      setState(() {
        _isGpsLoading = false;
        _gpsError = err;
      });

      if (err == null) {
        Navigator.of(context).pop(weatherVm.currentLocation);
      }
    }
  }

  void _selectLocation(LocationResult location) {
    final weatherVm = context.read<WeatherViewModel>();
    final personaVm = context.read<PersonaViewModel>();

    weatherVm.selectLocation(
      location,
      isOfflineMode: personaVm.isOfflineDemoMode,
    );

    Navigator.of(context).pop(location);
  }

  @override
  Widget build(BuildContext context) {
    final weatherVm = context.watch<WeatherViewModel>();
    final query = _searchController.text.trim();
    final isShowingRecents = query.length < 2;
    final recentLocations = weatherVm.recentLocations;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle & Top Bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4.5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.location_searching_rounded, color: Color(0xFF003366), size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Select Location • स्थान चुनें',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003366),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          // Search Input Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Search Indian city, district, or town... • भारतीय स्थान खोजें',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF003366)),
                suffixIcon: _isSearching
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.cancel_rounded, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchResults = [];
                              });
                            },
                          )
                        : null,
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF003366), width: 1.5),
                ),
              ),
            ),
          ),

          // GPS Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Material(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _isGpsLoading ? null : _handleGpsLocation,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                  child: Row(
                    children: [
                      _isGpsLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Color(0xFF0D47A1),
                              ),
                            )
                          : const Icon(Icons.my_location_rounded, color: Color(0xFF0D47A1), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Use Current Location (GPS)',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            Text(
                              'Auto-detect nearest IMD weather telemetry',
                              style: TextStyle(fontSize: 11, color: Color(0xFF1565C0)),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Color(0xFF0D47A1), size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (_gpsError != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Text(
                _gpsError!,
                style: const TextStyle(color: Colors.red, fontSize: 11.5),
              ),
            ),

          const Divider(height: 16),

          // Section Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 6),
            child: Row(
              children: [
                Icon(
                  isShowingRecents ? Icons.history_rounded : Icons.search_rounded,
                  size: 15,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Text(
                  isShowingRecents
                      ? 'RECENT & SAVED LOCATIONS'
                      : 'SEARCH RESULTS (${_searchResults.length})',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),

          // List View
          Expanded(
            child: isShowingRecents
                ? _buildRecentLocationsList(recentLocations, weatherVm.currentLocation)
                : _buildSearchResultsList(_searchResults, weatherVm.currentLocation),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentLocationsList(
    List<LocationResult> recents,
    LocationResult current,
  ) {
    if (recents.isEmpty) {
      return const Center(
        child: Text(
          'No recent searches. Search any place to get started.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: recents.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final loc = recents[index];
        final isSelected = loc.name.toLowerCase() == current.name.toLowerCase();
        return _buildLocationTile(loc, isSelected);
      },
    );
  }

  Widget _buildSearchResultsList(
    List<LocationResult> results,
    LocationResult current,
  ) {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (results.isEmpty) {
      final isForeign = IndiaLocationFilter.isForeignQuery(_searchController.text);
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isForeign ? Icons.flag_circle_rounded : Icons.location_off_rounded,
                size: 44,
                color: isForeign ? const Color(0xFFE65100) : Colors.grey.shade400,
              ),
              const SizedBox(height: 10),
              Text(
                isForeign
                    ? 'India-Only Scope (MoES / IMD Mandate)'
                    : 'No matching Indian locations found',
                style: TextStyle(
                  fontSize: 14.5,
                  color: isForeign ? const Color(0xFFE65100) : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                isForeign
                    ? 'Mausam is officially developed exclusively for Indian meteorological territories. International places cannot be searched or displayed.'
                    : 'Try searching for any Indian city, district, taluk, or coastal town.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final loc = results[index];
        final isSelected = loc.name.toLowerCase() == current.name.toLowerCase();
        return _buildLocationTile(loc, isSelected);
      },
    );
  }

  Widget _buildLocationTile(LocationResult loc, bool isSelected) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      onTap: () => _selectLocation(loc),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF003366)
              : (loc.isCoastal ? const Color(0xFFE0F7FA) : const Color(0xFFF5F5F5)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          loc.isCoastal
              ? Icons.waves_rounded
              : Icons.location_on_rounded,
          color: isSelected
              ? Colors.white
              : (loc.isCoastal
                  ? const Color(0xFF00838F)
                  : const Color(0xFF003366)),
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              loc.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 14.5,
                color: isSelected ? const Color(0xFF003366) : Colors.black87,
              ),
            ),
          ),
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(left: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF003366),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Active',
                style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            loc.state != null && loc.state!.isNotEmpty
                ? '${loc.state}, ${loc.country}'
                : loc.country,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (loc.isCoastal)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF80CBC4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.waves, size: 10, color: Color(0xFF00695C)),
                      const SizedBox(width: 3),
                      Text(
                        loc.coastDistanceKm != null
                            ? 'Coastal • ${loc.coastDistanceKm} km'
                            : 'Coastal Zone',
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00695C),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Text(
                    loc.coastDistanceKm != null
                        ? 'Inland • ${loc.coastDistanceKm!.round()} km to coast'
                        : 'Inland City',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }
}
