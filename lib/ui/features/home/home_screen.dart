import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mausam_app/data/models/persona_type.dart';
import 'package:mausam_app/data/models/weather_data.dart';
import 'package:mausam_app/viewmodels/persona_viewmodel.dart';
import 'package:mausam_app/viewmodels/weather_viewmodel.dart';
import 'package:mausam_app/ui/core/widgets/offline_banner.dart';
import 'package:mausam_app/ui/features/settings/settings_screen.dart';
import 'widgets/hero_weather_header.dart';
import 'widgets/persona_selector_bar.dart';
import 'widgets/cards/health_card.dart';
import 'widgets/cards/outdoor_fitness_card.dart';
import 'widgets/cards/beach_surfer_card.dart';
import 'widgets/cards/traveler_card.dart';
import 'widgets/cards/parents_families_card.dart';
import 'widgets/cards/agriculture_card.dart';
import 'widgets/cards/commuter_card.dart';
import 'widgets/cards/event_planner_card.dart';
import 'widgets/mobile_dashboard_view.dart';
import '../location/location_search_modal.dart';

enum AppViewMode {
  auto,
  mobile,
  web,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  AppViewMode _viewMode = AppViewMode.auto;

  @override
  void initState() {
    super.initState();
    try {
      final modeParam = Uri.base.queryParameters['mode'] ?? Uri.base.queryParameters['view'];
      if (modeParam == 'mobile') {
        _viewMode = AppViewMode.mobile;
      } else if (modeParam == 'web' || modeParam == 'desktop') {
        _viewMode = AppViewMode.web;
      }
    } catch (_) {}

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final personaVm = context.read<PersonaViewModel>();
    final weatherVm = context.read<WeatherViewModel>();

    if (weatherVm.weatherData == null) {
      weatherVm.changeCity(
        personaVm.defaultCity,
        isOfflineMode: personaVm.isOfflineDemoMode,
      );
    }
  }

  void _openAddDestinationDialog(BuildContext context) {
    final controller = TextEditingController();
    final personaVm = context.read<PersonaViewModel>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Saved Travel City'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add any Indian travel destination (e.g. Goa, Manali, Shimla, Kochi, Jaipur) to track weather and packing suggestions.',
                style: TextStyle(fontSize: 12.5, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'City Name',
                  hintText: 'e.g. Goa, Manali, Kochi, Jaipur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flight_takeoff_rounded),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  personaVm.addSavedDestination(controller.text.trim());
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${controller.text.trim()} to travel destinations'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Add City'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPersonaCard(PersonaType persona, WeatherData data) {
    final weatherVm = context.read<WeatherViewModel>();
    final personaVm = context.read<PersonaViewModel>();

    switch (persona) {
      case PersonaType.healthConscious:
        return HealthCard(key: const ValueKey('card_health'), weatherData: data);
      case PersonaType.outdoorFitness:
        return OutdoorFitnessCard(key: const ValueKey('card_fitness'), weatherData: data);
      case PersonaType.beachgoersSurfers:
        return BeachSurferCard(
          key: const ValueKey('card_beach'),
          weatherData: data,
          onSelectCoastalCity: (city) {
            weatherVm.changeCity(city, isOfflineMode: personaVm.isOfflineDemoMode);
          },
        );
      case PersonaType.travelers:
        return TravelerCard(
          key: const ValueKey('card_traveler'),
          weatherData: data,
          onManageDestinations: () => _openAddDestinationDialog(context),
        );
      case PersonaType.parentsFamilies:
        return ParentsFamiliesCard(key: const ValueKey('card_parents'), weatherData: data);
      case PersonaType.agricultureGardeners:
        return AgricultureCard(key: const ValueKey('card_agro'), weatherData: data);
      case PersonaType.commuters:
        return CommuterCard(key: const ValueKey('card_commuter'), weatherData: data);
      case PersonaType.eventPlanners:
        return EventPlannerCard(key: const ValueKey('card_event'), weatherData: data);
    }
  }

  Widget _buildViewModeToggle() {
    return PopupMenuButton<AppViewMode>(
      tooltip: 'Switch View: Mobile / Web / Auto',
      initialValue: _viewMode,
      onSelected: (mode) {
        setState(() {
          _viewMode = mode;
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              mode == AppViewMode.mobile
                  ? '📱 Switched to Mobile View (420px Phone Frame)'
                  : (mode == AppViewMode.web
                      ? '💻 Switched to Web / Desktop View (Wide Layout)'
                      : '🔄 Switched to Auto Responsive View'),
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _viewMode == AppViewMode.mobile
                  ? Icons.phone_android_rounded
                  : (_viewMode == AppViewMode.web ? Icons.desktop_windows_rounded : Icons.devices_rounded),
              size: 15,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              _viewMode == AppViewMode.mobile
                  ? 'Mobile'
                  : (_viewMode == AppViewMode.web ? 'Web' : 'Auto'),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white70),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: AppViewMode.mobile,
          child: Row(
            children: [
              Icon(
                Icons.phone_android_rounded,
                color: _viewMode == AppViewMode.mobile ? const Color(0xFF003366) : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '📱 Mobile Phone View',
                    style: TextStyle(
                      fontWeight: _viewMode == AppViewMode.mobile ? FontWeight.bold : FontWeight.w600,
                      color: _viewMode == AppViewMode.mobile ? const Color(0xFF003366) : Colors.black87,
                    ),
                  ),
                  const Text('Framed phone screen (420px)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppViewMode.web,
          child: Row(
            children: [
              Icon(
                Icons.desktop_windows_rounded,
                color: _viewMode == AppViewMode.web ? const Color(0xFF003366) : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '💻 Web / Desktop View',
                    style: TextStyle(
                      fontWeight: _viewMode == AppViewMode.web ? FontWeight.bold : FontWeight.w600,
                      color: _viewMode == AppViewMode.web ? const Color(0xFF003366) : Colors.black87,
                    ),
                  ),
                  const Text('Wide layout for large monitors', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppViewMode.auto,
          child: Row(
            children: [
              Icon(
                Icons.devices_rounded,
                color: _viewMode == AppViewMode.auto ? const Color(0xFF003366) : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🔄 Auto Responsive',
                    style: TextStyle(
                      fontWeight: _viewMode == AppViewMode.auto ? FontWeight.bold : FontWeight.w600,
                      color: _viewMode == AppViewMode.auto ? const Color(0xFF003366) : Colors.black87,
                    ),
                  ),
                  const Text('Adapts to browser window size', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.wb_sunny_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'MAUSAM • मौसम',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
              Text(
                'Ministry of Earth Sciences',
                style: TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
      actions: [
        _buildViewModeToggle(),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Settings & Personas',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedNavIndex,
      onDestinationSelected: (index) {
        if (index == 2) {
          LocationSearchModal.show(context);
          return;
        }
        if (index == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          );
          return;
        }
        setState(() {
          _selectedNavIndex = index;
        });
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.dynamic_feed_outlined),
          selectedIcon: const Icon(Icons.dynamic_feed_rounded),
          label: Localizations.localeOf(context).languageCode == 'hi' ? 'फ़ीड' : 'Feed',
        ),
        NavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard_rounded),
          label: Localizations.localeOf(context).languageCode == 'hi' ? 'डैशबोर्ड' : 'Dashboard',
        ),
        NavigationDestination(
          icon: const Icon(Icons.search_rounded),
          label: Localizations.localeOf(context).languageCode == 'hi' ? 'खोजें' : 'Search',
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings_rounded),
          label: Localizations.localeOf(context).languageCode == 'hi' ? 'सेटिंग्स' : 'Settings',
        ),
      ],
    );
  }

  Widget _buildPersonaCardsSliver(
    List<PersonaType> activePersonas,
    PersonaType? filterPersona,
    WeatherData weatherData,
    bool isWide,
  ) {
    if (filterPersona != null) {
      return SliverToBoxAdapter(
        child: _buildPersonaCard(filterPersona, weatherData),
      );
    }

    if (!isWide || activePersonas.length <= 1) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildPersonaCard(activePersonas[index], weatherData);
          },
          childCount: activePersonas.length,
        ),
      );
    }

    final col1 = <PersonaType>[];
    final col2 = <PersonaType>[];
    for (int i = 0; i < activePersonas.length; i++) {
      if (i % 2 == 0) {
        col1.add(activePersonas[i]);
      } else {
        col2.add(activePersonas[i]);
      }
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: col1.map((p) => _buildPersonaCard(p, weatherData)).toList(),
              ),
            ),
            Expanded(
              child: Column(
                children: col2.map((p) => _buildPersonaCard(p, weatherData)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final personaVm = context.watch<PersonaViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();

    final weatherData = weatherVm.weatherData;
    final isLoading = weatherVm.isLoading && weatherData == null;
    final isOffline = weatherVm.isOffline;
    final activePersonas = personaVm.selectedPersonas;
    final filterPersona = weatherVm.activeFilterPersona;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobileForced = _viewMode == AppViewMode.mobile;
    final isDesktopForced = _viewMode == AppViewMode.web;
    final isPhoneChassis = isMobileForced && screenWidth > 520;
    final isWideDesktop = isDesktopForced || (_viewMode == AppViewMode.auto && screenWidth >= 900);

    final mainBodyContent = RefreshIndicator(
      onRefresh: () => weatherVm.refresh(isOfflineMode: personaVm.isOfflineDemoMode),
      color: const Color(0xFF003366),
      child: isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Fetching IMD / CPCB / INCOIS Telemetry...'),
                ],
              ),
            )
          : weatherData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text('Unable to load weather forecast'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => weatherVm.loadWeather(
                          forceRefresh: true,
                          isOfflineMode: personaVm.isOfflineDemoMode,
                        ),
                        child: const Text('Retry Connection'),
                      ),
                    ],
                  ),
                )
              : _selectedNavIndex == 1
                  ? MobileDashboardView(
                      weatherData: weatherData,
                      isOffline: isOffline,
                      lastUpdated: weatherVm.lastUpdated,
                      onCityChanged: (city) {
                        weatherVm.changeCity(
                          city,
                          isOfflineMode: personaVm.isOfflineDemoMode,
                        );
                      },
                    )
                  : CustomScrollView(
                      slivers: [
                        // Offline Banner if serving cached data
                        if (isOffline)
                          SliverToBoxAdapter(
                            child: OfflineBanner(
                              lastUpdated: weatherVm.lastUpdated,
                              onRetry: () => weatherVm.refresh(
                                isOfflineMode: personaVm.isOfflineDemoMode,
                              ),
                            ),
                          ),

                        // Hero Weather Summary Header
                        SliverToBoxAdapter(
                          child: HeroWeatherHeader(
                            weatherData: weatherData,
                            isOffline: isOffline,
                            lastUpdated: weatherVm.lastUpdated,
                            onCityChanged: (city) {
                              weatherVm.changeCity(
                                city,
                                isOfflineMode: personaVm.isOfflineDemoMode,
                              );
                            },
                          ),
                        ),

                        // Active Persona Selector & Filter Bar
                        SliverToBoxAdapter(
                          child: PersonaSelectorBar(
                            activePersonas: activePersonas,
                            selectedFilter: filterPersona,
                            onFilterChanged: (persona) {
                              weatherVm.setActiveFilterPersona(persona);
                            },
                            onEditPersonas: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SettingsScreen()),
                              );
                            },
                          ),
                        ),

                        // Feed Section Header
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(18, 12, 18, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  filterPersona != null
                                      ? 'FILTERED: ${filterPersona.title.toUpperCase()}'
                                      : 'YOUR PERSONALIZED WEATHER CARDS',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.7,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                Text(
                                  '${filterPersona != null ? 1 : activePersonas.length} active',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Dynamically Rendered Persona Cards
                        _buildPersonaCardsSliver(
                          activePersonas,
                          filterPersona,
                          weatherData,
                          isWideDesktop,
                        ),

                        // Bottom Spacing
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 32),
                        ),
                      ],
                    ),
    );

    if (isPhoneChassis) {
      return Scaffold(
        backgroundColor: const Color(0xFFE5E9F0),
        appBar: _buildAppBar(context),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 420,
            constraints: BoxConstraints(maxHeight: (screenHeight - 80).clamp(500.0, 880.0)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: const Color(0xFF003366), width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // Simulated phone notch/speaker
                Container(
                  height: 24,
                  color: const Color(0xFF003366),
                  alignment: Alignment.center,
                  child: Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(child: mainBodyContent),
                _buildBottomNavBar(context),
              ],
            ),
          ),
        ),
      );
    }

    final double contentMaxWidth = isWideDesktop ? 1100.0 : 720.0;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentMaxWidth),
          child: mainBodyContent,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentMaxWidth),
            child: _buildBottomNavBar(context),
          ),
        ),
      ),
    );
  }
}
