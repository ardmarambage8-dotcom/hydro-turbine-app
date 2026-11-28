import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'turbine_data.dart';

const String kFirebaseDbUrl =
    'https://eagle-power-maduruoya-default-rtdb.asia-southeast1.firebasedatabase.app';

void main() {
  runApp(const HydroTurbineApp());
}

class HydroTurbineApp extends StatelessWidget {
  const HydroTurbineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eagle Power • Maduruoya',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1120),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF10B981),
          surface: Color(0xFF1E293B),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0F172A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
      home: const PinLockScreen(),
    );
  }
}

// ============================================================================
// SECURITY PIN SCREEN
// ============================================================================
class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _savedPin = '1234';
  String _errorMessage = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPin();
  }

  Future<void> _loadPin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPin = prefs.getString('app_pin') ?? '1234';
      _isLoading = false;
    });
  }

  void _verifyPin() {
    if (_pinController.text.trim() == _savedPin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const MainDashboardScreen(),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Incorrect PIN. Please try again.';
        _pinController.clear();
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    '1795510508002.jpg',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.bolt,
                      size: 80,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'EAGLE POWER',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Hydro Operational Suite • Cloud Sync',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Enter Security PIN',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _pinController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        decoration: const InputDecoration(
                          counterText: '',
                          hintText: '••••',
                          hintStyle: TextStyle(
                            letterSpacing: 8,
                            color: Color(0xFF475569),
                          ),
                        ),
                        onSubmitted: (_) => _verifyPin(),
                      ),
                      if (_errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Color(0xFFF87171),
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _verifyPin,
                          icon: const Icon(Icons.lock_open, size: 18),
                          label: const Text(
                            'UNLOCK SUITE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Default PIN: 1234',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// COMMON DIALOGS (CHANGE PIN & ABOUT)
// ============================================================================
void showCommonChangePinDialog(BuildContext context) {
  final newPinCtrl = TextEditingController();
  final confirmPinCtrl = TextEditingController();
  String dialogError = '';

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.lock_reset, color: Color(0xFF38BDF8)),
                SizedBox(width: 8),
                Text('Change Security PIN', style: TextStyle(fontSize: 18)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newPinCtrl,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'New PIN (4-6 digits)',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPinCtrl,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New PIN',
                    counterText: '',
                  ),
                ),
                if (dialogError.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    dialogError,
                    style:
                        const TextStyle(color: Color(0xFFF87171), fontSize: 12),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final p1 = newPinCtrl.text.trim();
                  final p2 = confirmPinCtrl.text.trim();
                  if (p1.length < 4) {
                    setDialogState(() {
                      dialogError = 'PIN must be at least 4 digits.';
                    });
                    return;
                  }
                  if (p1 != p2) {
                    setDialogState(() {
                      dialogError = 'PINs do not match.';
                    });
                    return;
                  }
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('app_pin', p1);
                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Security PIN updated successfully!'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                },
                child: const Text('Save PIN'),
              ),
            ],
          );
        },
      );
    },
  );
}

void showCommonAboutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1E293B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                '1795510508002.jpg',
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.bolt,
                  size: 60,
                  color: Color(0xFF38BDF8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'EAGLE POWER',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF38BDF8)),
              ),
              child: const Text(
                'Version 3.1.0 • Shift Log Edition',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38BDF8),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFF334155)),
            const SizedBox(height: 8),
            const Text(
              'Maduruoya Hydro Power Plant • Operational Suite',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF10B981),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Daily Generation (9:00 AM Report)\n'
              '2. Turbine Running Calculator & CEB Reduction\n'
              '3. Water Discharge Up / Down Alert\n'
              '4. 9:30 AM Meter Reading Report\n'
              '5. Internal Shift Log & Fault Alerts\n'
              '• Live Firebase Cloud Sync (@Maduruoya#)',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFCBD5E1),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            const Divider(color: Color(0xFF334155)),
            const SizedBox(height: 8),
            const Text(
              'Developed by',
              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 2),
            const Text(
              'Aruna Ruwandipa',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(height: 4),
            const SelectableText(
              'arunaruwandeepamarambage@gmail.com',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF38BDF8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

// ============================================================================
// MAIN HOME DASHBOARD (5 ACTION CARDS)
// ============================================================================
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  bool _isCloudConnected = false;
  bool _isChecking = false;
  String _cloudBannerText = 'Checking Cloud Sync...';
  int _activeFaultCount = 0;

  @override
  void initState() {
    super.initState();
    _checkCloudStatus();
  }

  Future<void> _checkCloudStatus() async {
    if (_isChecking) return;
    setState(() {
      _isChecking = true;
      _cloudBannerText = 'Connecting to Cloud...';
    });

    try {
      final uri = Uri.parse('$kFirebaseDbUrl/maduruoya/latest.json');
      final res = await http.get(uri).timeout(const Duration(seconds: 7));
      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        String lastDate = '';
        if (decoded != null && decoded is Map<String, dynamic>) {
          lastDate = (decoded['updated_date'] ?? '').toString();
        }

        int faultCount = 0;
        try {
          final chatUri =
              Uri.parse('$kFirebaseDbUrl/maduruoya/shift_chat.json');
          final chatRes =
              await http.get(chatUri).timeout(const Duration(seconds: 6));
          if (chatRes.statusCode == 200) {
            final chatDecoded = jsonDecode(chatRes.body);
            if (chatDecoded != null && chatDecoded is Map<String, dynamic>) {
              chatDecoded.forEach((_, val) {
                if (val is Map<String, dynamic>) {
                  final tag = (val['tag'] ?? '').toString();
                  if (tag == 'FAULT / FAIL') {
                    faultCount++;
                  }
                }
              });
            }
          }
        } catch (_) {}

        if (mounted) {
          setState(() {
            _isCloudConnected = true;
            _activeFaultCount = faultCount;
            _cloudBannerText = lastDate.isNotEmpty
                ? 'Cloud Synced • Last 9 AM Save: $lastDate'
                : 'Cloud Connected • @Maduruoya#';
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isCloudConnected = false;
            _cloudBannerText = 'Offline Mode • Using Local Storage';
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isCloudConnected = false;
          _cloudBannerText = 'Offline Mode • Using Local Storage';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isChecking = false);
      }
    }
  }

  String _todayLabel() {
    final now = DateTime.now();
    return '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
  }

  Widget _buildMenuCard({
    required String number,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required List<Color> gradientColors,
    required VoidCallback onTap,
    String? badgeText,
    Color badgeColor = const Color(0xFFEF4444),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accentColor.withOpacity(0.75), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: accentColor.withOpacity(0.6)),
              ),
              child: Icon(icon, size: 28, color: accentColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (badgeText != null && badgeText.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: badgeColor, width: 1),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeColor,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFCBD5E1),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: accentColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                '1795510508002.jpg',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.bolt,
                  color: Color(0xFF38BDF8),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EAGLE POWER',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  'Maduruoya • ${_todayLabel()}',
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Change PIN',
            icon: const Icon(Icons.lock_outline, color: Color(0xFFF59E0B)),
            onPressed: () => showCommonChangePinDialog(context),
          ),
          IconButton(
            tooltip: 'About App',
            icon: const Icon(Icons.info_outline, color: Color(0xFF38BDF8)),
            onPressed: () => showCommonAboutDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _isCloudConnected
                      ? const Color(0xFF064E3B).withOpacity(0.45)
                      : const Color(0xFF78350F).withOpacity(0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isCloudConnected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isCloudConnected ? Icons.cloud_done : Icons.cloud_off,
                      size: 18,
                      color: _isCloudConnected
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _cloudBannerText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _isCloudConnected
                              ? const Color(0xFFA7F3D0)
                              : const Color(0xFFFDE68A),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _isChecking ? null : _checkCloudStatus,
                      child: const Icon(
                        Icons.refresh,
                        size: 18,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 1. DAILY GENERATION (9:00 AM)
              _buildMenuCard(
                number: '1',
                title: 'Daily Generation',
                subtitle: '9:00 AM Meter Readings, Cloud Sync & WhatsApp Report',
                icon: Icons.assignment_turned_in_rounded,
                accentColor: const Color(0xFF10B981),
                gradientColors: const [Color(0xFF064E3B), Color(0xFF0F172A)],
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DailyGenerationScreen(),
                    ),
                  );
                  _checkCloudStatus();
                },
              ),
              const SizedBox(height: 14),

              // 2. TURBINE RUNNING CALCULATOR
              _buildMenuCard(
                number: '2',
                title: 'Turbine Running Calculator',
                subtitle: 'Water Level, Outflow (BA, WGA, EF) & CEB Reduction %',
                icon: Icons.calculate_rounded,
                accentColor: const Color(0xFF38BDF8),
                gradientColors: const [Color(0xFF0C4A6E), Color(0xFF0F172A)],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TurbineCalculatorScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 3. WATER DISCHARGE (UP / DOWN)
              _buildMenuCard(
                number: '3',
                title: 'Water Discharge',
                subtitle: 'Up / Down Discharge, Mahaweli & Power WhatsApp Alert',
                icon: Icons.water_drop_rounded,
                accentColor: const Color(0xFFF59E0B),
                gradientColors: const [Color(0xFF78350F), Color(0xFF0F172A)],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const WaterDischargeScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 4. 9.30 READING
              _buildMenuCard(
                number: '4',
                title: '9.30 Reading',
                subtitle: 'T1, T2, NDEP VA & CEB (Mwh) WhatsApp Message Builder',
                icon: Icons.access_time_filled_rounded,
                accentColor: const Color(0xFFA855F7),
                gradientColors: const [Color(0xFF4C1D95), Color(0xFF0F172A)],
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const Reading930Screen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 5. SHIFT LOG & FAULT ALERTS (INTERNAL OPERATORS ONLY)
              _buildMenuCard(
                number: '5',
                title: 'Shift Log & Fault Alerts',
                subtitle: 'Operator Fault Alerts, CEB Notes & Shift Handover Log',
                icon: Icons.forum_rounded,
                accentColor: const Color(0xFFEF4444),
                gradientColors: const [Color(0xFF7F1D1D), Color(0xFF0F172A)],
                badgeText: _activeFaultCount > 0
                    ? '$_activeFaultCount ACTIVE FAULT'
                    : null,
                badgeColor: const Color(0xFFF87171),
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ShiftLogScreen(),
                    ),
                  );
                  _checkCloudStatus();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 1: DAILY GENERATION REPORT (9:00 AM RECORD)
// ============================================================================
class DailyGenerationScreen extends StatefulWidget {
  const DailyGenerationScreen({super.key});

  @override
  State<DailyGenerationScreen> createState() => _DailyGenerationScreenState();
}

class _DailyGenerationScreenState extends State<DailyGenerationScreen> {
  final TextEditingController _prevPanelG1Ctrl = TextEditingController();
  final TextEditingController _prevPanelG2Ctrl = TextEditingController();
  final TextEditingController _todayPanelG1Ctrl = TextEditingController();
  final TextEditingController _todayPanelG2Ctrl = TextEditingController();

  final TextEditingController _prevCumG1Ctrl = TextEditingController();
  final TextEditingController _prevCumG2Ctrl = TextEditingController();

  final TextEditingController _dateCtrl = TextEditingController();
  final TextEditingController _resLevelCtrl = TextEditingController();
  final TextEditingController _waterDisCtrl = TextEditingController();
  final TextEditingController _mahaweliDisCtrl = TextEditingController();
  final TextEditingController _powerCtrl = TextEditingController();
  final TextEditingController _cebPfCtrl = TextEditingController();

  final TextEditingController _genStopMinCtrl = TextEditingController();
  final TextEditingController _powerDropKwCtrl = TextEditingController();
  final TextEditingController _powerDropMinCtrl = TextEditingController();

  final TextEditingController _dgWdValCtrl = TextEditingController();
  final TextEditingController _dgWdTimeCtrl = TextEditingController();
  String _dgWdDirection = 'down';

  final TextEditingController _genF1Ctrl = TextEditingController();
  final TextEditingController _genF2Ctrl = TextEditingController();

  String _savedPrevPanelG1 = '';
  String _savedPrevPanelG2 = '';
  String _savedPrevCumG1 = '122314.38';
  String _savedPrevCumG2 = '107510.91';

  String _savedResLevel = '89.24';
  String _savedWaterDis = '26';
  String _savedMahaweliDis = '00';
  String _savedPower = '2300';
  String _savedCebPf = '00';
  String _savedGenF1 = '00';
  String _savedGenF2 = '00';

  bool _isLoaded = false;
  bool _isSyncing = false;
  String _cloudStatus = 'Connecting...';
  bool _isCloudConnected = false;

  @override
  void initState() {
    super.initState();
    _syncDateToToday();
    _initializeData();

    for (final c in [
      _prevPanelG1Ctrl,
      _prevPanelG2Ctrl,
      _todayPanelG1Ctrl,
      _todayPanelG2Ctrl,
      _prevCumG1Ctrl,
      _prevCumG2Ctrl,
      _dateCtrl,
      _resLevelCtrl,
      _waterDisCtrl,
      _mahaweliDisCtrl,
      _powerCtrl,
      _cebPfCtrl,
      _genStopMinCtrl,
      _powerDropKwCtrl,
      _powerDropMinCtrl,
      _dgWdValCtrl,
      _dgWdTimeCtrl,
      _genF1Ctrl,
      _genF2Ctrl,
    ]) {
      c.addListener(_onFieldChanged);
    }
  }

  String _getTodayDateString() {
    final now = DateTime.now();
    return '${now.year}/${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}';
  }

  void _syncDateToToday() {
    _dateCtrl.text = _getTodayDateString();
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initializeData() async {
    await _loadLocalSavedReadings();
    await _syncFromCloud(showToast: false);
  }

  Future<void> _loadLocalSavedReadings() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _savedPrevPanelG1 = prefs.getString('dg_prev_panel_g1') ?? '';
      _savedPrevPanelG2 = prefs.getString('dg_prev_panel_g2') ?? '';
      _savedPrevCumG1 = prefs.getString('dg_prev_cum_g1') ?? '122314.38';
      _savedPrevCumG2 = prefs.getString('dg_prev_cum_g2') ?? '107510.91';

      _savedResLevel = prefs.getString('dg_res_level') ?? '89.24';
      _savedWaterDis = prefs.getString('dg_water_dis') ?? '26';
      _savedMahaweliDis = prefs.getString('dg_mahaweli_dis') ?? '00';
      _savedPower = prefs.getString('dg_power') ?? '2300';
      _savedCebPf = (prefs.getString('dg_ceb_pf') ?? '00')
          .replaceAll(RegExp(r'\s*minutes?\s*', caseSensitive: false), '')
          .trim();
      _savedGenF1 = prefs.getString('dg_gen_f1') ?? '00';
      _savedGenF2 = prefs.getString('dg_gen_f2') ?? '00';

      _syncDateToToday();
      _isLoaded = true;
    });
  }

  Future<void> _syncFromCloud({bool showToast = true}) async {
    if (_isSyncing) return;
    setState(() {
      _isSyncing = true;
      _cloudStatus = 'Syncing with Cloud...';
    });

    try {
      final uri = Uri.parse('$kFirebaseDbUrl/maduruoya/latest.json');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded != null && decoded is Map<String, dynamic>) {
          final prefs = await SharedPreferences.getInstance();

          final String cPanelG1 =
              (decoded['prev_panel_g1'] ?? _savedPrevPanelG1).toString();
          final String cPanelG2 =
              (decoded['prev_panel_g2'] ?? _savedPrevPanelG2).toString();
          final String cCumG1 =
              (decoded['prev_cum_g1'] ?? _savedPrevCumG1).toString();
          final String cCumG2 =
              (decoded['prev_cum_g2'] ?? _savedPrevCumG2).toString();

          final String cRes =
              (decoded['res_level'] ?? _savedResLevel).toString();
          final String cWater =
              (decoded['water_dis'] ?? _savedWaterDis).toString();
          final String cMahaweli =
              (decoded['mahaweli_dis'] ?? _savedMahaweliDis).toString();
          final String cPower = (decoded['power'] ?? _savedPower).toString();
          final String cCebPf = (decoded['ceb_pf'] ?? _savedCebPf)
              .toString()
              .replaceAll(RegExp(r'\s*minutes?\s*', caseSensitive: false), '')
              .trim();
          final String cGenF1 = (decoded['gen_f1'] ?? _savedGenF1).toString();
          final String cGenF2 = (decoded['gen_f2'] ?? _savedGenF2).toString();
          final String cDate = (decoded['updated_date'] ?? '').toString();

          await prefs.setString('dg_prev_panel_g1', cPanelG1);
          await prefs.setString('dg_prev_panel_g2', cPanelG2);
          await prefs.setString('dg_prev_cum_g1', cCumG1);
          await prefs.setString('dg_prev_cum_g2', cCumG2);
          await prefs.setString('dg_res_level', cRes);
          await prefs.setString('dg_water_dis', cWater);
          await prefs.setString('dg_mahaweli_dis', cMahaweli);
          await prefs.setString('dg_power', cPower);
          await prefs.setString('dg_ceb_pf', cCebPf);
          await prefs.setString('dg_gen_f1', cGenF1);
          await prefs.setString('dg_gen_f2', cGenF2);
          if (cDate.isNotEmpty) {
            await prefs.setString('dg_last_sync_date', cDate);
          }

          if (mounted) {
            setState(() {
              _savedPrevPanelG1 = cPanelG1;
              _savedPrevPanelG2 = cPanelG2;
              _savedPrevCumG1 = cCumG1;
              _savedPrevCumG2 = cCumG2;
              _savedResLevel = cRes;
              _savedWaterDis = cWater;
              _savedMahaweliDis = cMahaweli;
              _savedPower = cPower;
              _savedCebPf = cCebPf;
              _savedGenF1 = cGenF1;
              _savedGenF2 = cGenF2;
              _isCloudConnected = true;
              _cloudStatus = cDate.isNotEmpty
                  ? 'Cloud Synced (Last: $cDate)'
                  : 'Cloud Connected';
            });

            if (showToast) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Latest readings synced from Cloud!'),
                  backgroundColor: Color(0xFF10B981),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
        } else {
          if (mounted) {
            setState(() {
              _isCloudConnected = true;
              _cloudStatus = 'Cloud Ready (No previous cloud save yet)';
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isCloudConnected = false;
            _cloudStatus = 'Offline Mode (Cloud error ${response.statusCode})';
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isCloudConnected = false;
          _cloudStatus = 'Offline Mode (Using local phone values)';
        });
        if (showToast) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No internet connection. Using local saved values.'),
              backgroundColor: Color(0xFFF59E0B),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  Future<bool> _pushToCloud({
    required String dateStr,
    required String prevPanelG1,
    required String prevPanelG2,
    required String prevCumG1,
    required String prevCumG2,
    required String resLevel,
    required String waterDis,
    required String mahaweliDis,
    required String powerVal,
    required String cebPf,
    required String genStopMin,
    required String powerDropKw,
    required String powerDropMin,
    required String genF1,
    required String genF2,
    required double dailyG1,
    required double dailyG2,
    required double totalDailyGen,
    required String fullMessage,
  }) async {
    try {
      final Map<String, dynamic> latestPayload = {
        'updated_date': dateStr,
        'updated_timestamp': DateTime.now().toIso8601String(),
        'prev_panel_g1': prevPanelG1,
        'prev_panel_g2': prevPanelG2,
        'prev_cum_g1': prevCumG1,
        'prev_cum_g2': prevCumG2,
        'res_level': resLevel,
        'water_dis': waterDis,
        'mahaweli_dis': mahaweliDis,
        'power': powerVal,
        'ceb_pf': cebPf,
        'gen_f1': genF1,
        'gen_f2': genF2,
      };

      final latestUri = Uri.parse('$kFirebaseDbUrl/maduruoya/latest.json');
      final resLatest = await http
          .put(
            latestUri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(latestPayload),
          )
          .timeout(const Duration(seconds: 8));

      final String safeDateKey = dateStr.replaceAll('/', '-');
      final Map<String, dynamic> historyPayload = {
        ...latestPayload,
        'daily_g1': dailyG1.toStringAsFixed(2),
        'daily_g2': dailyG2.toStringAsFixed(2),
        'total_daily_gen': totalDailyGen.toStringAsFixed(2),
        'gen_stop_min': genStopMin,
        'power_drop_kw': powerDropKw,
        'power_drop_min': powerDropMin,
        'whatsapp_message': fullMessage,
      };

      final historyUri =
          Uri.parse('$kFirebaseDbUrl/maduruoya/history/$safeDateKey.json');
      await http
          .put(
            historyUri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(historyPayload),
          )
          .timeout(const Duration(seconds: 8));

      if (resLatest.statusCode == 200) {
        if (mounted) {
          setState(() {
            _isCloudConnected = true;
            _cloudStatus = 'Cloud Synced (Last: $dateStr)';
          });
        }
        return true;
      }
      return false;
    } catch (_) {
      if (mounted) {
        setState(() {
          _isCloudConnected = false;
          _cloudStatus = 'Saved Locally (Will sync when online)';
        });
      }
      return false;
    }
  }

  Future<void> _showCloudHistoryDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final uri = Uri.parse('$kFirebaseDbUrl/maduruoya/history.json');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));

      if (mounted) Navigator.pop(context);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        if (decoded == null || decoded is! Map<String, dynamic>) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No history records in Cloud yet.'),
              ),
            );
          }
          return;
        }

        final List<String> sortedKeys = decoded.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        if (!mounted) return;
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: const Color(0xFF1E293B),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: const Row(
              children: [
                Icon(Icons.history, color: Color(0xFF38BDF8)),
                SizedBox(width: 8),
                Text('Cloud Report History', style: TextStyle(fontSize: 17)),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: ListView.separated(
                itemCount: sortedKeys.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Color(0xFF334155)),
                itemBuilder: (context, index) {
                  final key = sortedKeys[index];
                  final item = decoded[key] as Map<String, dynamic>;
                  final dateLabel = (item['updated_date'] ?? key).toString();
                  final tot = (item['total_daily_gen'] ?? '0.00').toString();
                  final g1 = (item['prev_cum_g1'] ?? '--').toString();
                  final g2 = (item['prev_cum_g2'] ?? '--').toString();
                  final msg = (item['whatsapp_message'] ?? '').toString();

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      '$dateLabel  •  Total: $tot Mwh',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    subtitle: Text(
                      'G1: $g1 Mwh  |  G2: $g2 Mwh',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFCBD5E1)),
                    ),
                    trailing: msg.isNotEmpty
                        ? IconButton(
                            tooltip: 'Copy this report',
                            icon: const Icon(Icons.copy,
                                size: 18, color: Color(0xFF38BDF8)),
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: msg));
                              if (ctx.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Copied report for $dateLabel!'),
                                    backgroundColor: const Color(0xFF38BDF8),
                                  ),
                                );
                              }
                            },
                          )
                        : null,
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not load history. Check internet connection.'),
            backgroundColor: Color(0xFFF87171),
          ),
        );
      }
    }
  }

  String _valOrSaved(TextEditingController ctrl, String savedFallback) {
    final t = ctrl.text.trim();
    return t.isNotEmpty ? t : savedFallback;
  }

  String _buildWhatsAppMessage({
    required double newCumG1,
    required double newCumG2,
    required double totalDailyGen,
  }) {
    final String genStopMin = _genStopMinCtrl.text.trim();
    final String powerDropKw = _powerDropKwCtrl.text.trim();
    final String powerDropMin = _powerDropMinCtrl.text.trim();

    final String resLevel = _valOrSaved(_resLevelCtrl, _savedResLevel);
    final String waterDis = _valOrSaved(_waterDisCtrl, _savedWaterDis);
    final String mahaweliDis = _valOrSaved(_mahaweliDisCtrl, _savedMahaweliDis);
    final String powerVal = _valOrSaved(_powerCtrl, _savedPower);
    final String rawCebPf = _valOrSaved(_cebPfCtrl, _savedCebPf);
    final String cebPf = (rawCebPf.isNotEmpty &&
            rawCebPf != '0' &&
            rawCebPf != '00' &&
            !rawCebPf.toLowerCase().contains('min'))
        ? '$rawCebPf minutes'
        : rawCebPf;
    final String genF1 = _valOrSaved(_genF1Ctrl, _savedGenF1);
    final String genF2 = _valOrSaved(_genF2Ctrl, _savedGenF2);

    final List<String> lines = [
      'Sluice Power Generation Record.',
      '',
      'Date : ${_dateCtrl.text.trim()}',
      'Reservoir Water Level : $resLevel',
      'Water Discharge : ${waterDis}m3/s',
      'Mahaweli Discharge :${mahaweliDis}m3/s',
      'Power : ${powerVal}kw',
      'CEB P. F : $cebPf',
    ];

    if (genStopMin.isNotEmpty) {
      lines.add('Generator stop : $genStopMin minutes');
    }

    if (powerDropKw.isNotEmpty || powerDropMin.isNotEmpty) {
      final List<String> dropParts = ['Power drop'];
      if (powerDropKw.isNotEmpty) {
        dropParts.add('${powerDropKw}kw');
      }
      if (powerDropMin.isNotEmpty) {
        dropParts.add('${powerDropMin}minutes');
      }
      lines.add(dropParts.join(' '));
    }

    final String dgWdVal = _dgWdValCtrl.text.trim();
    final String dgWdTime = _dgWdTimeCtrl.text.trim();
    if (dgWdVal.isNotEmpty || dgWdTime.isNotEmpty) {
      final List<String> wdParts = ['Water discharge $_dgWdDirection'];
      if (dgWdVal.isNotEmpty) {
        wdParts.add('${dgWdVal}m3/s');
      }
      if (dgWdTime.isNotEmpty) {
        wdParts.add('Time $dgWdTime');
      }
      lines.add(wdParts.join(' '));
    }

    lines.addAll([
      '',
      'G1 Meter Reading: ${newCumG1.toStringAsFixed(2)}Mwh',
      'Gen f : $genF1',
      'G2 meter Reading : ${newCumG2.toStringAsFixed(2)}Mwh',
      'Gen f : $genF2',
      'Totle Reading : ${totalDailyGen.toStringAsFixed(2)}Mwh',
      '@Maduruoya#',
    ]);

    return lines.join('\n');
  }

  Future<void> _saveAndCopyReport({
    required double? todayPanelG1,
    required double? todayPanelG2,
    required double dailyG1,
    required double dailyG2,
    required double newCumG1,
    required double newCumG2,
    required double totalDailyGen,
  }) async {
    final String todayDate = _getTodayDateString();
    _dateCtrl.text = todayDate;

    final String message = _buildWhatsAppMessage(
      newCumG1: newCumG1,
      newCumG2: newCumG2,
      totalDailyGen: totalDailyGen,
    );

    await Clipboard.setData(ClipboardData(text: message));

    final prefs = await SharedPreferences.getInstance();

    final String newSavedPanelG1 = todayPanelG1 != null
        ? todayPanelG1.toStringAsFixed(2)
        : _valOrSaved(_prevPanelG1Ctrl, _savedPrevPanelG1);
    final String newSavedPanelG2 = todayPanelG2 != null
        ? todayPanelG2.toStringAsFixed(2)
        : _valOrSaved(_prevPanelG2Ctrl, _savedPrevPanelG2);

    final String newSavedCumG1 = newCumG1.toStringAsFixed(2);
    final String newSavedCumG2 = newCumG2.toStringAsFixed(2);

    final String newRes = _valOrSaved(_resLevelCtrl, _savedResLevel);
    final String newWater = _valOrSaved(_waterDisCtrl, _savedWaterDis);
    final String newMahaweli = _valOrSaved(_mahaweliDisCtrl, _savedMahaweliDis);
    final String newPower = _valOrSaved(_powerCtrl, _savedPower);
    final String rawNewCebPf = _valOrSaved(_cebPfCtrl, _savedCebPf);
    final String newCebPf = rawNewCebPf
        .replaceAll(RegExp(r'\s*minutes?\s*', caseSensitive: false), '')
        .trim();
    final String newGenF1 = _valOrSaved(_genF1Ctrl, _savedGenF1);
    final String newGenF2 = _valOrSaved(_genF2Ctrl, _savedGenF2);

    final String genStopMin = _genStopMinCtrl.text.trim();
    final String powerDropKw = _powerDropKwCtrl.text.trim();
    final String powerDropMin = _powerDropMinCtrl.text.trim();

    await prefs.setString('dg_prev_panel_g1', newSavedPanelG1);
    await prefs.setString('dg_prev_panel_g2', newSavedPanelG2);
    await prefs.setString('dg_prev_cum_g1', newSavedCumG1);
    await prefs.setString('dg_prev_cum_g2', newSavedCumG2);

    await prefs.setString('dg_res_level', newRes);
    await prefs.setString('dg_water_dis', newWater);
    await prefs.setString('dg_mahaweli_dis', newMahaweli);
    await prefs.setString('dg_power', newPower);
    await prefs.setString('dg_ceb_pf', newCebPf);
    await prefs.setString('dg_gen_f1', newGenF1);
    await prefs.setString('dg_gen_f2', newGenF2);
    await prefs.setString('dg_last_sync_date', todayDate);

    final bool cloudOk = await _pushToCloud(
      dateStr: todayDate,
      prevPanelG1: newSavedPanelG1,
      prevPanelG2: newSavedPanelG2,
      prevCumG1: newSavedCumG1,
      prevCumG2: newSavedCumG2,
      resLevel: newRes,
      waterDis: newWater,
      mahaweliDis: newMahaweli,
      powerVal: newPower,
      cebPf: newCebPf,
      genStopMin: genStopMin,
      powerDropKw: powerDropKw,
      powerDropMin: powerDropMin,
      genF1: newGenF1,
      genF2: newGenF2,
      dailyG1: dailyG1,
      dailyG2: dailyG2,
      totalDailyGen: totalDailyGen,
      fullMessage: message,
    );

    setState(() {
      _savedPrevPanelG1 = newSavedPanelG1;
      _savedPrevPanelG2 = newSavedPanelG2;
      _savedPrevCumG1 = newSavedCumG1;
      _savedPrevCumG2 = newSavedCumG2;

      _savedResLevel = newRes;
      _savedWaterDis = newWater;
      _savedMahaweliDis = newMahaweli;
      _savedPower = newPower;
      _savedCebPf = newCebPf;
      _savedGenF1 = newGenF1;
      _savedGenF2 = newGenF2;

      _prevPanelG1Ctrl.clear();
      _prevPanelG2Ctrl.clear();
      _todayPanelG1Ctrl.clear();
      _todayPanelG2Ctrl.clear();
      _prevCumG1Ctrl.clear();
      _prevCumG2Ctrl.clear();

      _resLevelCtrl.clear();
      _waterDisCtrl.clear();
      _mahaweliDisCtrl.clear();
      _powerCtrl.clear();
      _cebPfCtrl.clear();
      _genStopMinCtrl.clear();
      _powerDropKwCtrl.clear();
      _powerDropMinCtrl.clear();
      _dgWdValCtrl.clear();
      _dgWdTimeCtrl.clear();
      _genF1Ctrl.clear();
      _genF2Ctrl.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cloudOk
                ? 'Saved to Cloud & Copied ($todayDate)! Synced for all shifts.'
                : 'Saved Locally & Copied ($todayDate)! (Offline mode)',
          ),
          backgroundColor:
              cloudOk ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _copyOnly({
    required double newCumG1,
    required double newCumG2,
    required double totalDailyGen,
  }) async {
    final String todayDate = _getTodayDateString();
    _dateCtrl.text = todayDate;

    final String message = _buildWhatsAppMessage(
      newCumG1: newCumG1,
      newCumG2: newCumG2,
      totalDailyGen: totalDailyGen,
    );

    await Clipboard.setData(ClipboardData(text: message));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('WhatsApp message copied ($todayDate)!'),
          backgroundColor: const Color(0xFF38BDF8),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _prevPanelG1Ctrl.dispose();
    _prevPanelG2Ctrl.dispose();
    _todayPanelG1Ctrl.dispose();
    _todayPanelG2Ctrl.dispose();
    _prevCumG1Ctrl.dispose();
    _prevCumG2Ctrl.dispose();
    _dateCtrl.dispose();
    _resLevelCtrl.dispose();
    _waterDisCtrl.dispose();
    _mahaweliDisCtrl.dispose();
    _powerCtrl.dispose();
    _cebPfCtrl.dispose();
    _genStopMinCtrl.dispose();
    _powerDropKwCtrl.dispose();
    _powerDropMinCtrl.dispose();
    _dgWdValCtrl.dispose();
    _dgWdTimeCtrl.dispose();
    _genF1Ctrl.dispose();
    _genF2Ctrl.dispose();
    super.dispose();
  }

  Widget _buildDimSavedInput(
    String label,
    TextEditingController ctrl, {
    required String savedHint,
    TextInputType keyboardType =
        const TextInputType.numberWithOptions(decimal: true),
    String? suffix,
    Color? labelColor,
    bool isSavedValueHint = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: labelColor ?? const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: savedHint,
            hintStyle: TextStyle(
              fontSize: isSavedValueHint ? 15 : 13,
              fontWeight:
                  isSavedValueHint ? FontWeight.w600 : FontWeight.normal,
              color: const Color(0xFF64748B),
            ),
            suffixText: suffix,
            suffixStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF94A3B8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final double prevPanelG1 =
        double.tryParse(_valOrSaved(_prevPanelG1Ctrl, _savedPrevPanelG1)) ??
            0.0;
    final double prevPanelG2 =
        double.tryParse(_valOrSaved(_prevPanelG2Ctrl, _savedPrevPanelG2)) ??
            0.0;
    final double? todayPanelG1 =
        double.tryParse(_todayPanelG1Ctrl.text.trim());
    final double? todayPanelG2 =
        double.tryParse(_todayPanelG2Ctrl.text.trim());

    final double dailyG1 =
        (todayPanelG1 != null) ? (todayPanelG1 - prevPanelG1) : 0.0;
    final double dailyG2 =
        (todayPanelG2 != null) ? (todayPanelG2 - prevPanelG2) : 0.0;

    final double prevCumG1 =
        double.tryParse(_valOrSaved(_prevCumG1Ctrl, _savedPrevCumG1)) ?? 0.0;
    final double prevCumG2 =
        double.tryParse(_valOrSaved(_prevCumG2Ctrl, _savedPrevCumG2)) ?? 0.0;

    final double newCumG1 = prevCumG1 + dailyG1;
    final double newCumG2 = prevCumG2 + dailyG2;
    final double totalDailyGen = dailyG1 + dailyG2;

    final bool hasNegativeDiff =
        (todayPanelG1 != null && dailyG1 < 0) ||
            (todayPanelG2 != null && dailyG2 < 0);

    final String formattedMessage = _buildWhatsAppMessage(
      newCumG1: newCumG1,
      newCumG2: newCumG2,
      totalDailyGen: totalDailyGen,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Generation (9:00 AM)',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Cloud Sync Enabled • @Maduruoya#',
              style: TextStyle(fontSize: 11, color: Color(0xFF10B981)),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sync from Cloud Now',
            icon: _isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF38BDF8),
                    ),
                  )
                : const Icon(Icons.cloud_sync, color: Color(0xFF38BDF8)),
            onPressed: _isSyncing ? null : () => _syncFromCloud(showToast: true),
          ),
          IconButton(
            tooltip: 'Cloud History',
            icon: const Icon(Icons.history, color: Color(0xFFF59E0B)),
            onPressed: _showCloudHistoryDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _isCloudConnected
                    ? const Color(0xFF064E3B).withOpacity(0.45)
                    : const Color(0xFF78350F).withOpacity(0.35),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isCloudConnected
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isCloudConnected ? Icons.cloud_done : Icons.cloud_off,
                    size: 18,
                    color: _isCloudConnected
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _cloudStatus,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _isCloudConnected
                            ? const Color(0xFFA7F3D0)
                            : const Color(0xFFFDE68A),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _isSyncing
                        ? null
                        : () => _syncFromCloud(showToast: true),
                    child: const Text(
                      'Refresh',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 1. PANEL METER READINGS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF38BDF8), width: 1.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. PANEL METER READINGS (4 READINGS)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDimSavedInput(
                          'Yesterday Panel G1',
                          _prevPanelG1Ctrl,
                          savedHint: _savedPrevPanelG1.isNotEmpty
                              ? _savedPrevPanelG1
                              : 'e.g. 16736.67',
                          isSavedValueHint: _savedPrevPanelG1.isNotEmpty,
                          labelColor: const Color(0xFFFBBF24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDimSavedInput(
                          'Yesterday Panel G2',
                          _prevPanelG2Ctrl,
                          savedHint: _savedPrevPanelG2.isNotEmpty
                              ? _savedPrevPanelG2
                              : 'e.g. 14099.38',
                          isSavedValueHint: _savedPrevPanelG2.isNotEmpty,
                          labelColor: const Color(0xFFFBBF24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDimSavedInput(
                          'Today 9 AM Panel G1',
                          _todayPanelG1Ctrl,
                          savedHint: 'Enter 9 AM G1',
                          isSavedValueHint: false,
                          labelColor: const Color(0xFF38BDF8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDimSavedInput(
                          'Today 9 AM Panel G2',
                          _todayPanelG2Ctrl,
                          savedHint: 'Enter 9 AM G2',
                          isSavedValueHint: false,
                          labelColor: const Color(0xFF38BDF8),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF334155), height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'G1 Daily: ${dailyG1.toStringAsFixed(2)} Mwh',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: dailyG1 < 0
                              ? const Color(0xFFF87171)
                              : const Color(0xFF10B981),
                        ),
                      ),
                      Text(
                        'G2 Daily: ${dailyG2.toStringAsFixed(2)} Mwh',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: dailyG2 < 0
                              ? const Color(0xFFF87171)
                              : const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  if (hasNegativeDiff) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Warning: Today panel reading is smaller than yesterday panel reading!',
                      style:
                          TextStyle(fontSize: 12, color: Color(0xFFF87171)),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 2. PREVIOUS CUMULATIVE TOTAL
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF59E0B), width: 1.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2. PREVIOUS CUMULATIVE TOTAL (මෙතෙක් දුවපු සමස්ත අගය)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDimSavedInput(
                          'Prev Total G1 (Mwh)',
                          _prevCumG1Ctrl,
                          savedHint: _savedPrevCumG1,
                          labelColor: const Color(0xFFFDE68A),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDimSavedInput(
                          'Prev Total G2 (Mwh)',
                          _prevCumG2Ctrl,
                          savedHint: _savedPrevCumG2,
                          labelColor: const Color(0xFFFDE68A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 3. FINAL TOTALS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF10B981), width: 1.6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    '3. FINAL TOTALS (එකතුව)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFF6EE7B7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A).withOpacity(0.75),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF10B981)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'New G1 Meter Reading',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFFA7F3D0)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                newCumG1.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Mwh',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF10B981)),
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
                            color: const Color(0xFF0F172A).withOpacity(0.75),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF10B981)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'New G2 Meter Reading',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFFA7F3D0)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                newCumG2.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Mwh',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF10B981)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF047857), height: 22),
                  const Text(
                    'TOTLE READING (DAILY G1 + G2)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFF6EE7B7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        totalDailyGen.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Mwh',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 4. PLANT, DISCHARGE & OUTAGE DETAILS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '4. PLANT & DISCHARGE DETAILS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _syncDateToToday();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF10B981)),
                          ),
                          child: const Text(
                            'Today Date',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDimSavedInput(
                          'Date (Auto Phone Date)',
                          _dateCtrl,
                          savedHint: _getTodayDateString(),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDimSavedInput(
                          'Reservoir Water Level',
                          _resLevelCtrl,
                          savedHint: _savedResLevel,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDimSavedInput(
                          'Water Discharge',
                          _waterDisCtrl,
                          savedHint: _savedWaterDis,
                          suffix: 'm3/s',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDimSavedInput(
                          'Mahaweli Discharge',
                          _mahaweliDisCtrl,
                          savedHint: _savedMahaweliDis,
                          suffix: 'm3/s',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDimSavedInput(
                          'Power',
                          _powerCtrl,
                          savedHint: _savedPower,
                          suffix: 'kw',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDimSavedInput(
                          'CEB P. F',
                          _cebPfCtrl,
                          savedHint: _savedCebPf,
                          keyboardType: TextInputType.number,
                          suffix: 'minutes',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _buildDimSavedInput(
                    'Generator stop (Optional - Number only)',
                    _genStopMinCtrl,
                    savedHint: 'e.g. 290',
                    isSavedValueHint: false,
                    keyboardType: TextInputType.number,
                    suffix: 'minutes',
                    labelColor: const Color(0xFFFBBF24),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Power drop (Optional - Auto adds kw & minutes)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFBBF24),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _powerDropKwCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'e.g. 1990',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF64748B),
                            ),
                            suffixText: 'kw',
                            suffixStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _powerDropMinCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'e.g. 165',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF64748B),
                            ),
                            suffixText: 'minutes',
                            suffixStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Optional Water Discharge Up / Down Entry
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Water discharge up / down (Optional)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFBBF24),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          final now = DateTime.now();
                          final tStr =
                              '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';
                          setState(() {
                            _dgWdTimeCtrl.text = tStr;
                          });
                        },
                        child: const Text(
                          'Now Time',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF38BDF8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _dgWdDirection = 'up'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: _dgWdDirection == 'up'
                                ? const Color(0xFF10B981).withOpacity(0.25)
                                : const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _dgWdDirection == 'up'
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF334155),
                              width: 1.4,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _dgWdDirection == 'up'
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 17,
                                color: _dgWdDirection == 'up'
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'UP',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _dgWdDirection == 'up'
                                      ? Colors.white
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => setState(() => _dgWdDirection = 'down'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: _dgWdDirection == 'down'
                                ? const Color(0xFFF59E0B).withOpacity(0.25)
                                : const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _dgWdDirection == 'down'
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF334155),
                              width: 1.4,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _dgWdDirection == 'down'
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 17,
                                color: _dgWdDirection == 'down'
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF64748B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'DOWN',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _dgWdDirection == 'down'
                                      ? Colors.white
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _dgWdValCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          onChanged: (val) {
                            if (val.trim().isNotEmpty &&
                                _dgWdTimeCtrl.text.trim().isEmpty) {
                              final now = DateTime.now();
                              _dgWdTimeCtrl.text =
                                  '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';
                            }
                          },
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'e.g. 26',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF64748B),
                            ),
                            suffixText: 'm3/s',
                            suffixStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _dgWdTimeCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            hintText: 'Time (e.g. 14.00)',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF64748B),
                            ),
                            prefixText: 'Time ',
                            prefixStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDimSavedInput(
                          'G1 Gen f',
                          _genF1Ctrl,
                          savedHint: _savedGenF1,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildDimSavedInput(
                          'G2 Gen f',
                          _genF2Ctrl,
                          savedHint: _savedGenF2,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // 5. LIVE WHATSAPP MESSAGE PREVIEW
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B).withOpacity(0.35),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.chat, size: 16, color: Color(0xFF10B981)),
                      SizedBox(width: 6),
                      Text(
                        'WHATSAPP MESSAGE PREVIEW',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Color(0xFF6EE7B7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    formattedMessage,
                    style: const TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 6. SAVE TO CLOUD & COPY BUTTONS
            ElevatedButton.icon(
              onPressed: (todayPanelG1 == null || todayPanelG2 == null)
                  ? null
                  : () => _saveAndCopyReport(
                        todayPanelG1: todayPanelG1,
                        todayPanelG2: todayPanelG2,
                        dailyG1: dailyG1,
                        dailyG2: dailyG2,
                        newCumG1: newCumG1,
                        newCumG2: newCumG2,
                        totalDailyGen: totalDailyGen,
                      ),
              icon: const Icon(Icons.cloud_upload),
              label: const Text(
                'SAVE TO CLOUD & COPY MESSAGE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF334155),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => _copyOnly(
                newCumG1: newCumG1,
                newCumG2: newCumG2,
                totalDailyGen: totalDailyGen,
              ),
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('Copy Message Only (Without Saving)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF38BDF8),
                side: const BorderSide(color: Color(0xFF38BDF8)),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 2: TURBINE RUNNING CALCULATOR + CEB REDUCTION
// ============================================================================
class TurbineCalculatorScreen extends StatefulWidget {
  const TurbineCalculatorScreen({super.key});

  @override
  State<TurbineCalculatorScreen> createState() =>
      _TurbineCalculatorScreenState();
}

class _TurbineCalculatorScreenState extends State<TurbineCalculatorScreen> {
  final TextEditingController _waterLevelController = TextEditingController();
  final TextEditingController _outflowController = TextEditingController();
  final TextEditingController _currentGenController = TextEditingController();
  final TextEditingController _reductionPctController = TextEditingController();

  String _savedWaterLevel = '89.25';
  String _savedOutflow = '29.0';
  String _savedCurrentGen = '2300';
  String _savedReductionPct = '25';

  int _runningUnits = 2;
  bool _useInterpolated = false;

  static const double _tailwaterOffset = 78.64;

  @override
  void initState() {
    super.initState();
    _loadSavedCalcInputs();
    _waterLevelController.addListener(_onCalcInputChanged);
    _outflowController.addListener(_onCalcInputChanged);
    _currentGenController.addListener(_onCalcInputChanged);
    _reductionPctController.addListener(_onCalcInputChanged);
  }

  Future<void> _loadSavedCalcInputs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _savedWaterLevel = prefs.getString('calc_water_level') ?? '89.25';
      _savedOutflow = prefs.getString('calc_outflow') ?? '29.0';
      _savedCurrentGen = prefs.getString('calc_current_gen') ?? '2300';
      _savedReductionPct = prefs.getString('calc_reduction_pct') ?? '25';
      _runningUnits = prefs.getInt('calc_running_units') ?? 2;
      _useInterpolated = prefs.getBool('calc_use_interp') ?? false;
    });
  }

  Future<void> _saveCalcInputs() async {
    final prefs = await SharedPreferences.getInstance();
    final wl = _waterLevelController.text.trim();
    final ofl = _outflowController.text.trim();
    final cg = _currentGenController.text.trim();
    final rp = _reductionPctController.text.trim();

    if (wl.isNotEmpty) {
      _savedWaterLevel = wl;
      await prefs.setString('calc_water_level', wl);
    }
    if (ofl.isNotEmpty) {
      _savedOutflow = ofl;
      await prefs.setString('calc_outflow', ofl);
    }
    if (cg.isNotEmpty) {
      _savedCurrentGen = cg;
      await prefs.setString('calc_current_gen', cg);
    }
    if (rp.isNotEmpty) {
      _savedReductionPct = rp;
      await prefs.setString('calc_reduction_pct', rp);
    }
    await prefs.setInt('calc_running_units', _runningUnits);
    await prefs.setBool('calc_use_interp', _useInterpolated);
  }

  void _onCalcInputChanged() {
    _saveCalcInputs();
    setState(() {});
  }

  @override
  void dispose() {
    _waterLevelController.dispose();
    _outflowController.dispose();
    _currentGenController.dispose();
    _reductionPctController.dispose();
    super.dispose();
  }

  double _calculateInterpolatedEf(double h, double q) {
    final double clampedH = h.clamp(6.0, 20.0);
    final double clampedQ = q.clamp(6.0, 21.0);

    final int hLowIdx = (clampedH.floor() - 6).clamp(0, 14);
    final int hHighIdx = (clampedH.ceil() - 6).clamp(0, 14);
    final int qLow = clampedQ.floor().clamp(6, 21);
    final int qHigh = clampedQ.ceil().clamp(6, 21);

    final ChartPoint? p11 = TurbineChartData.grid[qLow]?[hLowIdx];
    final ChartPoint? p12 = TurbineChartData.grid[qLow]?[hHighIdx];
    final ChartPoint? p21 = TurbineChartData.grid[qHigh]?[hLowIdx];
    final ChartPoint? p22 = TurbineChartData.grid[qHigh]?[hHighIdx];

    final int nearHIdx = TurbineChartData.nearestHeadIndex(clampedH);
    final int nearQ = TurbineChartData.nearestFlow(clampedQ);
    final ChartPoint? fallback = TurbineChartData.grid[nearQ]?[nearHIdx];
    final double baseEf = fallback?.ef ?? 85.0;

    if (p11 == null || p12 == null || p21 == null || p22 == null) {
      return baseEf;
    }

    final double hFrac =
        (hHighIdx == hLowIdx) ? 0.0 : (clampedH - (hLowIdx + 6));
    final double qFrac = (qHigh == qLow) ? 0.0 : (clampedQ - qLow);

    final double efQ1 = p11.ef + (p12.ef - p11.ef) * hFrac;
    final double efQ2 = p21.ef + (p22.ef - p21.ef) * hFrac;
    return efQ1 + (efQ2 - efQ1) * qFrac;
  }

  Widget _buildParamBox(
      String code, String label, String value, Color accentColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(
              code,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String activeWaterStr = _waterLevelController.text.trim().isNotEmpty
        ? _waterLevelController.text.trim()
        : _savedWaterLevel;
    final String activeOutflowStr = _outflowController.text.trim().isNotEmpty
        ? _outflowController.text.trim()
        : _savedOutflow;

    final double? waterLevel = double.tryParse(activeWaterStr);
    final double? totalOutflow = double.tryParse(activeOutflowStr);

    final double? netHead =
        waterLevel != null ? (waterLevel - _tailwaterOffset) : null;
    final double? flowPerTurbine =
        totalOutflow != null ? (totalOutflow / _runningUnits) : null;

    ChartPoint? nearestPoint;
    double? finalEf;
    double? powerPerTurbineKw;
    double? totalPlantPowerKw;
    String? statusWarning;
    double chartH = 0.0;
    int chartQ = 0;

    if (netHead == null || flowPerTurbine == null) {
      statusWarning = 'Enter valid numeric values for Water Level and Outflow.';
    } else if (netHead <= 0) {
      statusWarning =
          'Water Level must be greater than $_tailwaterOffset m (Net Head H > 0).';
    } else if (flowPerTurbine <= 0) {
      statusWarning = 'Total Outflow must be greater than 0 Cum/s.';
    } else {
      final int headIdx = TurbineChartData.nearestHeadIndex(netHead);
      final int nearFlow = TurbineChartData.nearestFlow(flowPerTurbine);
      nearestPoint = TurbineChartData.grid[nearFlow]?[headIdx];

      if (nearestPoint == null) {
        statusWarning =
            'Operating point (H=${netHead.toStringAsFixed(2)}m, Q=${flowPerTurbine.toStringAsFixed(2)} Cum/s) is outside the valid chart region.';
      } else {
        chartH = TurbineChartData.heads[headIdx];
        chartQ = nearFlow;
        finalEf = _useInterpolated
            ? _calculateInterpolatedEf(netHead, flowPerTurbine)
            : nearestPoint.ef;
        powerPerTurbineKw =
            netHead * flowPerTurbine * (finalEf / 100.0) * 9.81;
        totalPlantPowerKw = powerPerTurbineKw * _runningUnits;

        if (netHead < 6.0 ||
            netHead > 20.0 ||
            flowPerTurbine < 6.0 ||
            flowPerTurbine > 21.0) {
          statusWarning =
              'Note: H or Flow is outside standard chart bounds (H: 6–20m, Q: 6–21 Cum/s). Using nearest chart boundary.';
        }
      }
    }

    final String activeGenStr = _currentGenController.text.trim().isNotEmpty
        ? _currentGenController.text.trim()
        : _savedCurrentGen;
    final String activeRedStr = _reductionPctController.text.trim().isNotEmpty
        ? _reductionPctController.text.trim()
        : _savedReductionPct;

    final double currentGenKw = double.tryParse(activeGenStr) ?? 0.0;
    final double reductionPct = double.tryParse(activeRedStr) ?? 0.0;
    final double reducedAmountKw = currentGenKw * (reductionPct / 100.0);
    final double targetGenKw =
        (currentGenKw - reducedAmountKw).clamp(0.0, double.infinity);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turbine Running Calculator',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Chart: ZZ1540 - LJI - 190 • Eagle Power',
              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Reset Defaults',
            icon: const Icon(Icons.refresh, color: Color(0xFF94A3B8)),
            onPressed: () async {
              _waterLevelController.clear();
              _outflowController.clear();
              _currentGenController.clear();
              _reductionPctController.clear();
              setState(() {
                _savedWaterLevel = '89.25';
                _savedOutflow = '29.0';
                _savedCurrentGen = '2300';
                _savedReductionPct = '25';
                _runningUnits = 2;
                _useInterpolated = false;
              });
              await _saveCalcInputs();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PLANT INPUTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Color(0xFF38BDF8),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Water Level (m)',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _waterLevelController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: _savedWaterLevel,
                                hintStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Net Head H (m)',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 52,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFF334155)),
                              ),
                              child: Text(
                                netHead != null
                                    ? netHead.toStringAsFixed(2)
                                    : '--',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF38BDF8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Total Outflow Qmax (Cum/s)',
                    style: TextStyle(fontSize: 13, color: Color(0xFFCBD5E1)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _outflowController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: _savedOutflow,
                      hintStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                      suffixText: 'Cum/s',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Running Units:',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFFCBD5E1)),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment<int>(
                            value: 1,
                            label: Text('1 Turbine'),
                          ),
                          ButtonSegment<int>(
                            value: 2,
                            label: Text('2 Turbines'),
                          ),
                        ],
                        selected: {_runningUnits},
                        onSelectionChanged: (Set<int> newSelection) {
                          setState(() {
                            _runningUnits = newSelection.first;
                          });
                          _saveCalcInputs();
                        },
                      ),
                    ],
                  ),
                  if (flowPerTurbine != null && flowPerTurbine > 0) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Flow per Turbine: ${flowPerTurbine.toStringAsFixed(2)} Cum/s each',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            if (statusWarning != null)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF78350F).withOpacity(0.35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFF59E0B)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFF59E0B)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        statusWarning,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFFFDE68A)),
                      ),
                    ),
                  ],
                ),
              ),
            if (powerPerTurbineKw != null && nearestPoint != null) ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border:
                      Border.all(color: const Color(0xFF10B981), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'OUTPUT POWER (PER TURBINE)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Color(0xFF6EE7B7),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065F46),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'H=${chartH.toStringAsFixed(1)}m, Q=$chartQ',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          powerPerTurbineKw.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'kW',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6EE7B7),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${(powerPerTurbineKw / 1000.0).toStringAsFixed(3)} MW',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA7F3D0),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF047857), height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL PLANT ($_runningUnits UNIT${_runningUnits > 1 ? 'S' : ''}):',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFA7F3D0),
                          ),
                        ),
                        Text(
                          '${totalPlantPowerKw!.toStringAsFixed(2)} kW (${(totalPlantPowerKw / 1000.0).toStringAsFixed(3)} MW)',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WaterDischargeScreen(
                                prefillOutflow: activeOutflowStr,
                                prefillPower:
                                    totalPlantPowerKw!.toStringAsFixed(0),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.water_drop_outlined, size: 17),
                        label: const Text(
                          'Send to Water Discharge Alert',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFBBF24),
                          side: const BorderSide(color: Color(0xFFF59E0B)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TURBINE CONTROL SETTINGS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        _buildParamBox(
                          'BA',
                          'Blade Angle',
                          '${nearestPoint.ba}°',
                          const Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 10),
                        _buildParamBox(
                          'WGA',
                          'Wicket Gate',
                          '${nearestPoint.wga}°',
                          const Color(0xFF38BDF8),
                        ),
                        const SizedBox(width: 10),
                        _buildParamBox(
                          'EF',
                          'Efficiency',
                          '${finalEf!.toStringAsFixed(1)}%',
                          const Color(0xFF10B981),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Interpolate intermediate EF values:',
                          style:
                              TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        ),
                        Switch(
                          value: _useInterpolated,
                          activeColor: const Color(0xFF38BDF8),
                          onChanged: (v) {
                            setState(() {
                              _useInterpolated = v;
                            });
                            _saveCalcInputs();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF59E0B), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CEB POWER REDUCTION (%)',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                          color: Color(0xFFF59E0B),
                        ),
                      ),
                      if (totalPlantPowerKw != null)
                        InkWell(
                          onTap: () {
                            _currentGenController.text =
                                totalPlantPowerKw!.toStringAsFixed(0);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xFF38BDF8)),
                            ),
                            child: const Text(
                              'Use Plant Power',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF38BDF8),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Generating Power (kW)',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _currentGenController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: _savedCurrentGen,
                                hintStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                                suffixText: 'kW',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reduce (%)',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _reductionPctController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF59E0B),
                              ),
                              decoration: InputDecoration(
                                hintText: _savedReductionPct,
                                hintStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                                suffixText: '%',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF78350F), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFFF59E0B),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'REDUCTION AMOUNT (${reductionPct.toStringAsFixed(0)}% TO REDUCE)',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Color(0xFFFBBF24),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              reducedAmountKw.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'kW',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${(reducedAmountKw / 1000.0).toStringAsFixed(3)} MW',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFDE68A),
                          ),
                        ),
                        const Divider(color: Color(0xFF92400E), height: 20),
                        Text(
                          'Remaining Target Power: ${targetGenKw.toStringAsFixed(1)} kW (${(targetGenKw / 1000.0).toStringAsFixed(3)} MW)',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6EE7B7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 3: WATER DISCHARGE UP / DOWN ALERT BUILDER
// ============================================================================
class WaterDischargeScreen extends StatefulWidget {
  final String? prefillOutflow;
  final String? prefillPower;

  const WaterDischargeScreen({
    super.key,
    this.prefillOutflow,
    this.prefillPower,
  });

  @override
  State<WaterDischargeScreen> createState() => _WaterDischargeScreenState();
}

class _WaterDischargeScreenState extends State<WaterDischargeScreen> {
  final TextEditingController _wdTotalCtrl = TextEditingController();
  final TextEditingController _wdMahaweliCtrl = TextEditingController();
  final TextEditingController _wdPlantCtrl = TextEditingController();
  final TextEditingController _wdPowerCtrl = TextEditingController();
  final TextEditingController _wdTimeCtrl = TextEditingController();

  String _wdDirection = 'down';
  String _savedWdTotal = '26';
  String _savedWdMahaweli = '00';
  String _savedWdPlant = '26';
  String _savedWdPower = '2300';

  String _getCurrentDotTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _wdTimeCtrl.text = _getCurrentDotTime();
    if (widget.prefillOutflow != null && widget.prefillOutflow!.isNotEmpty) {
      _wdTotalCtrl.text = widget.prefillOutflow!;
      _wdPlantCtrl.text = widget.prefillOutflow!;
    }
    if (widget.prefillPower != null && widget.prefillPower!.isNotEmpty) {
      _wdPowerCtrl.text = widget.prefillPower!;
    }
    _loadSavedWdInputs();
    for (final c in [
      _wdTotalCtrl,
      _wdMahaweliCtrl,
      _wdPlantCtrl,
      _wdPowerCtrl,
      _wdTimeCtrl,
    ]) {
      c.addListener(_onChanged);
    }
  }

  void _onChanged() {
    _saveWdInputs();
    if (mounted) setState(() {});
  }

  Future<void> _loadSavedWdInputs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _wdDirection = prefs.getString('wd_direction') ?? 'down';
      _savedWdTotal = prefs.getString('wd_total') ?? '26';
      _savedWdMahaweli = prefs.getString('wd_mahaweli') ?? '00';
      _savedWdPlant = prefs.getString('wd_plant') ?? '26';
      _savedWdPower = prefs.getString('wd_power') ?? '2300';
    });
  }

  Future<void> _saveWdInputs() async {
    final prefs = await SharedPreferences.getInstance();
    final t = _wdTotalCtrl.text.trim();
    final m = _wdMahaweliCtrl.text.trim();
    final p = _wdPlantCtrl.text.trim();
    final pw = _wdPowerCtrl.text.trim();
    if (t.isNotEmpty) {
      _savedWdTotal = t;
      await prefs.setString('wd_total', t);
    }
    if (m.isNotEmpty) {
      _savedWdMahaweli = m;
      await prefs.setString('wd_mahaweli', m);
    }
    if (p.isNotEmpty) {
      _savedWdPlant = p;
      await prefs.setString('wd_plant', p);
    }
    if (pw.isNotEmpty) {
      _savedWdPower = pw;
      await prefs.setString('wd_power', pw);
    }
    await prefs.setString('wd_direction', _wdDirection);
  }

  String _buildDischargeChangeMessage() {
    final String totalVal = _wdTotalCtrl.text.trim().isNotEmpty
        ? _wdTotalCtrl.text.trim()
        : _savedWdTotal;
    final String mahaweliVal = _wdMahaweliCtrl.text.trim().isNotEmpty
        ? _wdMahaweliCtrl.text.trim()
        : _savedWdMahaweli;
    final String plantVal = _wdPlantCtrl.text.trim().isNotEmpty
        ? _wdPlantCtrl.text.trim()
        : _savedWdPlant;
    final String powerVal = _wdPowerCtrl.text.trim().isNotEmpty
        ? _wdPowerCtrl.text.trim()
        : _savedWdPower;
    final String timeVal = _wdTimeCtrl.text.trim().isNotEmpty
        ? _wdTimeCtrl.text.trim()
        : _getCurrentDotTime();

    return 'Water discharge $_wdDirection ${totalVal}m3/s\n'
        'Mahaweli  $mahaweliVal m3/s\n'
        'P. Plant discharge ${plantVal}m3/s\n'
        'Power ${powerVal}kw\n'
        'Time $timeVal';
  }

  @override
  void dispose() {
    _wdTotalCtrl.dispose();
    _wdMahaweliCtrl.dispose();
    _wdPlantCtrl.dispose();
    _wdPowerCtrl.dispose();
    _wdTimeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String previewMsg = _buildDischargeChangeMessage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Water Discharge (Up / Down)',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'WhatsApp Discharge Change Message',
              style: TextStyle(fontSize: 11, color: Color(0xFFF59E0B)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF59E0B), width: 1.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'SELECT DIRECTION (UP / DOWN)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment<String>(
                        value: 'up',
                        icon: Icon(Icons.arrow_upward, size: 18),
                        label: Text('UP (වැඩි කළා)'),
                      ),
                      ButtonSegment<String>(
                        value: 'down',
                        icon: Icon(Icons.arrow_downward, size: 18),
                        label: Text('DOWN (අඩු කළා)'),
                      ),
                    ],
                    selected: {_wdDirection},
                    onSelectionChanged: (Set<String> sel) {
                      setState(() {
                        _wdDirection = sel.first;
                      });
                      _saveWdInputs();
                    },
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Water discharge $_wdDirection',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _wdTotalCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: _savedWdTotal,
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                                suffixText: 'm3/s',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mahaweli',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _wdMahaweliCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: _savedWdMahaweli,
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                                suffixText: 'm3/s',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'P. Plant discharge',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _wdPlantCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: _savedWdPlant,
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                                suffixText: 'm3/s',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Power',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 5),
                            TextField(
                              controller: _wdPowerCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: _savedWdPower,
                                hintStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                                suffixText: 'kw',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Time (e.g. 14.00)',
                            style: TextStyle(
                                fontSize: 12, color: Color(0xFFCBD5E1)),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _wdTimeCtrl.text = _getCurrentDotTime();
                              });
                            },
                            child: const Text(
                              'Set Now Time',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF38BDF8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _wdTimeCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: _getCurrentDotTime(),
                          hintStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B).withOpacity(0.35),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.chat, size: 16, color: Color(0xFF10B981)),
                      SizedBox(width: 6),
                      Text(
                        'WHATSAPP MESSAGE PREVIEW',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Color(0xFF6EE7B7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    previewMsg,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'monospace',
                      color: Colors.white,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () async {
                await _saveWdInputs();
                await Clipboard.setData(ClipboardData(text: previewMsg));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Water discharge WhatsApp message copied!'),
                      backgroundColor: Color(0xFF10B981),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text(
                'COPY WHATSAPP MESSAGE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 4: 9.30 READING (T1, T2, NDEP VA, CEB MWH)
// ============================================================================
class Reading930Screen extends StatefulWidget {
  const Reading930Screen({super.key});

  @override
  State<Reading930Screen> createState() => _Reading930ScreenState();
}

class _Reading930ScreenState extends State<Reading930Screen> {
  final TextEditingController _t1Ctrl = TextEditingController();
  final TextEditingController _t2Ctrl = TextEditingController();
  final TextEditingController _ndepVaCtrl = TextEditingController();
  final TextEditingController _cebMwhCtrl = TextEditingController();

  String _savedT1 = '16818.55';
  String _savedT2 = '14175.62';
  String _savedNdepVa = '0.036';
  String _savedCebMwh = '106741.03';

  @override
  void initState() {
    super.initState();
    _loadSaved930Inputs();
    for (final c in [_t1Ctrl, _t2Ctrl, _ndepVaCtrl, _cebMwhCtrl]) {
      c.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadSaved930Inputs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _savedT1 = prefs.getString('r930_t1') ?? '16818.55';
      _savedT2 = prefs.getString('r930_t2') ?? '14175.62';
      _savedNdepVa = prefs.getString('r930_ndep_va') ?? '0.036';
      _savedCebMwh = prefs.getString('r930_ceb_mwh') ?? '106741.03';
    });
  }

  Future<void> _save930Inputs() async {
    final prefs = await SharedPreferences.getInstance();
    final t1 = _t1Ctrl.text.trim();
    final t2 = _t2Ctrl.text.trim();
    final nd = _ndepVaCtrl.text.trim();
    final ceb = _cebMwhCtrl.text.trim();

    if (t1.isNotEmpty) {
      _savedT1 = t1;
      await prefs.setString('r930_t1', t1);
    }
    if (t2.isNotEmpty) {
      _savedT2 = t2;
      await prefs.setString('r930_t2', t2);
    }
    if (nd.isNotEmpty) {
      _savedNdepVa = nd;
      await prefs.setString('r930_ndep_va', nd);
    }
    if (ceb.isNotEmpty) {
      _savedCebMwh = ceb;
      await prefs.setString('r930_ceb_mwh', ceb);
    }
  }

  String _build930Message() {
    final String t1 =
        _t1Ctrl.text.trim().isNotEmpty ? _t1Ctrl.text.trim() : _savedT1;
    final String t2 =
        _t2Ctrl.text.trim().isNotEmpty ? _t2Ctrl.text.trim() : _savedT2;
    final String ndep = _ndepVaCtrl.text.trim().isNotEmpty
        ? _ndepVaCtrl.text.trim()
        : _savedNdepVa;
    final String ceb = _cebMwhCtrl.text.trim().isNotEmpty
        ? _cebMwhCtrl.text.trim()
        : _savedCebMwh;

    return 'T1 : $t1\n'
        'T2 : $t2\n'
        'NDEP VA : $ndep\n'
        'CEB : ${ceb}mwh';
  }

  @override
  void dispose() {
    _t1Ctrl.dispose();
    _t2Ctrl.dispose();
    _ndepVaCtrl.dispose();
    _cebMwhCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String previewMsg = _build930Message();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '9.30 Reading',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              '9:30 AM Panel & CEB Meter Message',
              style: TextStyle(fontSize: 11, color: Color(0xFFA855F7)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA855F7), width: 1.4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ENTER 9:30 AM READINGS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Color(0xFFD8B4FE),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'T1',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _t1Ctrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: _savedT1,
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'T2',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _t2Ctrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: _savedT2,
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NDEP VA',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _ndepVaCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: _savedNdepVa,
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CEB (mwh)',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFCBD5E1)),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _cebMwhCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: _savedCebMwh,
                                hintStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                ),
                                suffixText: 'mwh',
                                suffixStyle: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF064E3B).withOpacity(0.35),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF10B981)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.chat, size: 16, color: Color(0xFF10B981)),
                      SizedBox(width: 6),
                      Text(
                        'WHATSAPP MESSAGE PREVIEW',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          color: Color(0xFF6EE7B7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    previewMsg,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'monospace',
                      color: Colors.white,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                await _save930Inputs();
                setState(() {
                  _t1Ctrl.clear();
                  _t2Ctrl.clear();
                  _ndepVaCtrl.clear();
                  _cebMwhCtrl.clear();
                });
                await Clipboard.setData(ClipboardData(text: previewMsg));
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('9.30 Reading saved & copied to clipboard!'),
                      backgroundColor: Color(0xFF10B981),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.copy, size: 18),
              label: const Text(
                'SAVE & COPY 9.30 MESSAGE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SCREEN 5: INTERNAL SHIFT LOG & FAULT ALERTS (OPERATORS ONLY)
// ============================================================================
class ShiftLogScreen extends StatefulWidget {
  const ShiftLogScreen({super.key});

  @override
  State<ShiftLogScreen> createState() => _ShiftLogScreenState();
}

class _ShiftLogScreenState extends State<ShiftLogScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  String _operatorName = '';
  String _selectedTag = 'FAULT / FAIL';
  bool _isLoading = true;
  bool _isSending = false;
  List> _messages = [];

  static const List> _tagOptions = [
    {
      'label': 'FAULT / FAIL',
      'color': Color(0xFFEF4444),
      'icon': Icons.warning_amber_rounded,
    },
    {
      'label': 'CEB / GRID',
      'color': Color(0xFFF59E0B),
      'icon': Icons.electrical_services,
    },
    {
      'label': 'SHIFT NOTE',
      'color': Color(0xFF38BDF8),
      'icon': Icons.info_outline,
    },
    {
      'label': 'RESOLVED',
      'color': Color(0xFF10B981),
      'icon': Icons.check_circle_outline,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initShiftLog();
  }

  Future<void> _initShiftLog() async {
    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('operator_name') ?? '';
    if (mounted) {
      setState(() {
        _operatorName = savedName;
      });
    }
    await _fetchMessages(silent: true);
  }

  Future<void> _saveOperatorName(String name) async {
    final clean = name.trim();
    if (clean.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('operator_name', clean);
    if (mounted) {
      setState(() {
        _operatorName = clean;
      });
    }
  }

  void _showSetNameDialog() {
    final tempCtrl = TextEditingController(text: _operatorName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.person_pin, color: Color(0xFF38BDF8)),
            SizedBox(width: 8),
            Text('Operator Name', style: TextStyle(fontSize: 17)),
          ],
        ),
        content: TextField(
          controller: tempCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Enter your name (e.g. Aruna)',
            hintText: 'Operator Name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (tempCtrl.text.trim().isNotEmpty) {
                await _saveOperatorName(tempCtrl.text.trim());
                if (ctx.mounted) Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchMessages({bool silent = false}) async {
    if (!silent && mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final uri = Uri.parse('$kFirebaseDbUrl/maduruoya/shift_chat.json');
      final response = await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final List> loaded = [];
        if (decoded != null && decoded is Map<String, dynamic>) {
          decoded.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              loaded.add({
                'id': key,
                'sender': (value['sender'] ?? 'Operator').toString(),
                'tag': (value['tag'] ?? 'SHIFT NOTE').toString(),
                'text': (value['text'] ?? '').toString(),
                'time': (value['time'] ?? '').toString(),
                'resolved_by': (value['resolved_by'] ?? '').toString(),
                'ts': (value['ts'] ?? 0) is int
                    ? value['ts']
                    : int.tryParse(value['ts'].toString()) ?? 0,
              });
            }
          });
          loaded.sort((a, b) => (a['ts'] as int).compareTo(b['ts'] as int));
        }
        if (mounted) {
          setState(() {
            _messages = loaded;
            _isLoading = false;
          });
          _scrollToBottom();
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
        if (!silent) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not refresh messages. Check connection.'),
              backgroundColor: Color(0xFFF59E0B),
            ),
          );
        }
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatNowTime() {
    final now = DateTime.now();
    final y = now.year.toString();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final hh = now.hour.toString().padLeft(2, '0');
    final mm = now.minute.toString().padLeft(2, '0');
    return '$y/$m/$d  $hh:$mm';
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _isSending) return;

    if (_operatorName.isEmpty) {
      _showSetNameDialog();
      return;
    }

    setState(() => _isSending = true);

    try {
      final now = DateTime.now();
      final payload = {
        'sender': _operatorName,
        'tag': _selectedTag,
        'text': text,
        'time': _formatNowTime(),
        'ts': now.millisecondsSinceEpoch,
      };

      final uri = Uri.parse('$kFirebaseDbUrl/maduruoya/shift_chat.json');
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        _msgCtrl.clear();
        await _fetchMessages(silent: true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to send message. Try again.'),
              backgroundColor: Color(0xFFF87171),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection. Message not sent.'),
            backgroundColor: Color(0xFFF59E0B),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  Future<void> _markAsResolved(String id) async {
    if (_operatorName.isEmpty) {
      _showSetNameDialog();
      return;
    }
    try {
      final uri = Uri.parse('$kFirebaseDbUrl/maduruoya/shift_chat/$id.json');
      await http
          .patch(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'tag': 'RESOLVED',
              'resolved_by': '$_operatorName (${_formatNowTime()})',
            }),
          )
          .timeout(const Duration(seconds: 8));
      await _fetchMessages(silent: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fault marked as RESOLVED!'),
            backgroundColor: Color(0xFF10B981),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _deleteMessage(String id) async {
    try {
      final uri = Uri.parse('$kFirebaseDbUrl/maduruoya/shift_chat/$id.json');
      await http.delete(uri).timeout(const Duration(seconds: 8));
      await _fetchMessages(silent: true);
    } catch (_) {}
  }

  Color _colorForTag(String tag) {
    for (final opt in _tagOptions) {
      if (opt['label'] == tag) return opt['color'] as Color;
    }
    return const Color(0xFF38BDF8);
  }

  IconData _iconForTag(String tag) {
    for (final opt in _tagOptions) {
      if (opt['label'] == tag) return opt['icon'] as IconData;
    }
    return Icons.info_outline;
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shift Log & Fault Alerts',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              _operatorName.isNotEmpty
                  ? 'Operator: $_operatorName • Operators Only'
                  : 'Tap person icon to set your name',
              style: const TextStyle(fontSize: 11, color: Color(0xFF38BDF8)),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Set Operator Name',
            icon: const Icon(Icons.person_pin, color: Color(0xFFF59E0B)),
            onPressed: _showSetNameDialog,
          ),
          IconButton(
            tooltip: 'Refresh Messages',
            icon: const Icon(Icons.refresh, color: Color(0xFF10B981)),
            onPressed: () => _fetchMessages(silent: false),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_operatorName.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: const Color(0xFF78350F).withOpacity(0.45),
              child: Row(
                children: [
                  const Icon(Icons.person_add,
                      size: 18, color: Color(0xFFFBBF24)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Set your Operator Name before posting alerts:',
                      style: TextStyle(fontSize: 12, color: Color(0xFFFDE68A)),
                    ),
                  ),
                  TextButton(
                    onPressed: _showSetNameDialog,
                    child: const Text(
                      'Set Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.forum_outlined,
                                  size: 54, color: Color(0xFF475569)),
                              SizedBox(height: 12),
                              Text(
                                'No shift notes or fault alerts yet.',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Post any turbine fault, CEB instruction, or shift handover note below so the next operator sees it immediately.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.all(14),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final sender = msg['sender'] as String;
                          final tag = msg['tag'] as String;
                          final text = msg['text'] as String;
                          final time = msg['time'] as String;
                          final resolvedBy = msg['resolved_by'] as String;
                          final id = msg['id'] as String;
                          final bool isMe = _operatorName.isNotEmpty &&
                              sender.toLowerCase() ==
                                  _operatorName.toLowerCase();
                          final Color tagColor = _colorForTag(tag);

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.85,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? const Color(0xFF1E3A5F)
                                    : const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: tagColor.withOpacity(0.75),
                                  width: 1.3,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: tagColor.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: tagColor, width: 0.8),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(_iconForTag(tag),
                                                size: 12, color: tagColor),
                                            const SizedBox(width: 4),
                                            Text(
                                              tag,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: tagColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        sender,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      if (isMe) ...[
                                        const SizedBox(width: 6),
                                        InkWell(
                                          onTap: () => _deleteMessage(id),
                                          child: const Icon(
                                            Icons.delete_outline,
                                            size: 15,
                                            color: Color(0xFF94A3B8),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    text,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      height: 1.35,
                                    ),
                                  ),
                                  if (resolvedBy.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      'Resolved by: $resolvedBy',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF6EE7B7),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        time,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF94A3B8),
                                        ),
                                      ),
                                      if (tag == 'FAULT / FAIL') ...[
                                        const SizedBox(width: 12),
                                        InkWell(
                                          onTap: () => _markAsResolved(id),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF10B981)
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFF10B981)),
                                            ),
                                            child: const Text(
                                              '✓ Mark Resolved',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF6EE7B7),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              border: Border(top: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tagOptions.map((opt) {
                      final String label = opt['label'] as String;
                      final Color color = opt['color'] as Color;
                      final bool selected = _selectedTag == label;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(
                            label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: selected ? Colors.white : color,
                            ),
                          ),
                          selected: selected,
                          selectedColor: color.withOpacity(0.85),
                          backgroundColor: const Color(0xFF1E293B),
                          side: BorderSide(color: color.withOpacity(0.6)),
                          onSelected: (_) {
                            setState(() => _selectedTag = label);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgCtrl,
                        maxLines: 3,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Type fault alert or shift handover note...',
                          hintStyle:
                              TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: const Color(0xFF10B981),
                      child: IconButton(
                        icon: _isSending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.send,
                                color: Colors.white, size: 20),
                        onPressed: _isSending ? null : _sendMessage,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
