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
    final double? waterLevel =
        double.tryParse(_waterLevelController.text.trim());
    final double? totalOutflow =
        double.tryParse(_outflowController.text.trim());

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
            icon: const Icon(Icons.refresh, color: Color(0xFF94A3B8)),
            onPressed: () {
              _waterLevelController.text = '89.25';
              _outflowController.text = '29.0';
              _currentGenController.text = '2300';
              _reductionPctController.text = '20';
              setState(() {
                _runningUnits = 2;
                _useInterpolated = false;
              });
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: 'e.g. 89.25',
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
                        fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 29.0',
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
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                hintText: 'e.g. 2300',
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
                              decoration: const InputDecoration(
                                hintText: '20',
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
