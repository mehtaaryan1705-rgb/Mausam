import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/persona_viewmodel.dart';
import '../onboarding/onboarding_screen.dart';
import '../home/home_screen.dart';

class LanguageScreen extends StatefulWidget {
  final bool isSettingsMode;

  const LanguageScreen({super.key, this.isSettingsMode = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    final personaVm = context.read<PersonaViewModel>();
    _selectedLanguage = personaVm.languageCode ?? 'en';
  }

  Future<void> _saveLanguage() async {
    final personaVm = context.read<PersonaViewModel>();
    await personaVm.setLanguageCode(_selectedLanguage);

    if (!mounted) return;

    if (widget.isSettingsMode) {
      Navigator.of(context).pop(_selectedLanguage);
    } else {
      if (personaVm.hasCompletedOnboarding) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.isSettingsMode
          ? AppBar(
              title: const Text('Change Language • भाषा बदलें'),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.isSettingsMode) ...[
                const SizedBox(height: 20),
                // Government Emblem / Branding Header
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003366).withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.translate_rounded,
                      size: 48,
                      color: Color(0xFF003366),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Center(
                  child: Column(
                    children: const [
                      Text(
                        'MAUSAM • मौसम',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: Color(0xFF003366),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ministry of Earth Sciences, Govt. of India',
                        style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Header Title
              const Text(
                'Choose Your Language\nअपनी भाषा चुनें',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select preferred language for official IMD weather forecasts, severe alerts, and radar bulletins.\nमौसम पूर्वानुमान और चेतावनियों के लिए अपनी पसंदीदा भाषा चुनें।',
                style: TextStyle(fontSize: 12.5, color: Colors.black54, height: 1.4),
              ),
              const SizedBox(height: 28),

              // Language Option 1: English
              _buildLanguageCard(
                code: 'en',
                title: 'English',
                subtitle: 'Official National English',
                tag: 'EN',
                tagColor: const Color(0xFF003366),
                sampleText: 'Sunny, AQI 72 • IMD Live Telemetry',
              ),

              const SizedBox(height: 16),

              // Language Option 2: Hindi
              _buildLanguageCard(
                code: 'hi',
                title: 'हिंदी (Hindi)',
                subtitle: 'भारत की राजभाषा',
                tag: 'हिं',
                tagColor: const Color(0xFFE65100),
                sampleText: 'धूप / साफ मौसम, AQI 72 • आईएमडी लाइव',
              ),

              const Spacer(),

              // Confirmation Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _saveLanguage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedLanguage == 'hi'
                            ? 'आगे बढ़ें (Continue)'
                            : 'Continue to Mausam',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'You can change this anytime in Settings • सेटिंग्स में कभी भी बदलें',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required String code,
    required String title,
    required String subtitle,
    required String tag,
    required Color tagColor,
    required String sampleText,
  }) {
    final isSelected = _selectedLanguage == code;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: isSelected ? 3 : 0.5,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLanguage = code;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF003366) : Colors.grey.shade200,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: tagColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sampleText,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? const Color(0xFF003366) : Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? const Color(0xFF003366) : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF003366) : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
