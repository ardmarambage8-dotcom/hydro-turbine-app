import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'turbine_data.dart';

void main() {
  runApp(const HydroTurbineApp());
}

class HydroTurbineApp extends StatelessWidget {
  const HydroTurbineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZZ1540 Turbine Calculator',
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
          builder: (_) => const TurbineCalculatorScreen(),
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
                  'Turbine Running Calculator • ZZ1540',
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
                            'UNLOCK CALCULATOR',
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

class TurbineCalculatorScreen extends StatefulWidget {
  const TurbineCalculatorScreen({super.key});

  @override
  State<TurbineCalculatorScreen> createState() =>
      _TurbineCalculatorScreenState();
}

class _TurbineCalculatorScreenState extends State<TurbineCalculatorScreen> {
  final TextEditingController _waterLevelController =
      TextEditingController(text: '89.25');
  final TextEditingController _outflowController =
      TextEditingController(text: '29.0');
  final TextEditingController _currentGenController =
      TextEditingController(text: '2300');
  final TextEditingController _reductionPctController =
      TextEditingController(text: '20');

  int _runningUnits = 2;
  bool _useInterpolated = false;

  static const double _tailwaterOffset = 78.64;

  @override
  void initState() {
    super.initState();
    _waterLevelController.addListener(_recalculate);
    _outflowController.addListener(_recalculate);
    _currentGenController.addListener(_recalculate);
    _reductionPctController.addListener(_recalculate);
  }

  void _recalculate() {
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

  void _showChangePinDialog() {
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
                      style: const TextStyle(
                          color: Color(0xFFF87171), fontSize: 12),
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
                      ScaffoldMessenger.of(this.context).showSnackBar(
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

  void _showAboutDialog() {
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
                'Turbine Running Calculator',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF38BDF8)),
                ),
                child: const Text(
                  'Version 1.1.0',
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
                'EAGLE POWER • Hydro Operational Suite',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                '• Turbine Model: ZZ1540 - LJI - 190\n'
                '• Net Head (H): Water Level - 78.64 m\n'
                '• Output Power: H × Cum × EF × 9.81 kW\n'
                '• Includes CEB Load Reduction Calculator',
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

  @override
  Widget build(BuildContext context) {
    final double? waterLevel =
        double.tryParse(_waterLevelController.text.trim());
    final double? totalOutflow =
        double.tryParse(_outflowController.text.trim());

    final double? netHead =
        waterLevel != null ? (waterLevel - _tailwaterOffset) : null;
    final double? flowPerTurbine =
        totalOutflow != null ? (totalOutflow / _runningUnits) : null;

    ChartPoint? nearestPoint;
    double? interpolatedEf;
    double? finalEf;
    double? powerPerTurbineKw;
    double? totalPlantPowerKw;
    String? statusWarning;

    if (netHead == null || flowPerTurbine == null) {
      statusWarning = 'Enter valid numeric values for Water Level and Outflow.';
    } else if (netHead <= 0) {
      statusWarning =
          'Water Level must be greater than $_tailwaterOffset m (Net Head H > 0).';
    } else if (flowPerTurbine <= 0) {
      statusWarning = 'Total Outflow must be greater than 0 Cum/s.';
    } else {
      nearestPoint = TurbineChartData.getNearestPoint(netHead, flowPerTurbine);
      interpolatedEf =
          TurbineChartData.getInterpolatedEf(netHead, flowPerTurbine);

      if (nearestPoint == null) {
        statusWarning =
            'Operating point (H=${netHead.toStringAsFixed(2)}m, Q=${flowPerTurbine.toStringAsFixed(2)} Cum/s) is outside the valid chart region.';
      } else {
        finalEf = _useInterpolated
            ? (interpolatedEf ?? nearestPoint.ef)
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

    // CEB Percentage Reduction Calculation
    final double currentGenKw =
        double.tryParse(_currentGenController.text.trim()) ?? 0.0;
    final double reductionPct =
        double.tryParse(_reductionPctController.text.trim()) ?? 0.0;
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
            tooltip: 'Change PIN',
            icon: const Icon(Icons.lock_outline, color: Color(0xFFF59E0B)),
            onPressed: _showChangePinDialog,
          ),
          IconButton(
            tooltip: 'About App',
            icon: const Icon(Icons.info_outline, color: Color(0xFF38BDF8)),
            onPressed: _showAboutDialog,
          ),
          IconButton(
            tooltip: 'Reset Defaults',
            icon: const Icon(Icons.refresh, co
