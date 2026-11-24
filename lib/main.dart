import 'package:flutter/material.dart';
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
        scaffoldBackgroundColor: const Color(0xFF0F172A),
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
        ),
      ),
      home: const TurbineCalculatorScreen(),
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
  static const double tailraceConstant = 78.64;

  final TextEditingController _levelController =
      TextEditingController(text: '89.25');
  final TextEditingController _headController =
      TextEditingController(text: '10.61');
  final TextEditingController _flowController =
      TextEditingController(text: '29.0');

  int _turbineCount = 2; // Default 2 Turbines
  bool _useInterpolated = false; // Default: Nearest Chart Cell (Standard)
  bool _isUpdatingText = false;

  @override
  void dispose() {
    _levelController.dispose();
    _headController.dispose();
    _flowController.dispose();
    super.dispose();
  }

  void _onWaterLevelChanged(String val) {
    if (_isUpdatingText) return;
    _isUpdatingText = true;
    final level = double.tryParse(val);
    if (level != null) {
      final h = level - tailraceConstant;
      _headController.text = h.toStringAsFixed(2);
    } else {
      _headController.text = '';
    }
    _isUpdatingText = false;
    setState(() {});
  }

  void _onHeadChanged(String val) {
    if (_isUpdatingText) return;
    _isUpdatingText = true;
    final h = double.tryParse(val);
    if (h != null) {
      final level = h + tailraceConstant;
      _levelController.text = level.toStringAsFixed(2);
    } else {
      _levelController.text = '';
    }
    _isUpdatingText = false;
    setState(() {});
  }

  void _resetAll() {
    _isUpdatingText = true;
    _levelController.clear();
    _headController.clear();
    _flowController.clear();
    _isUpdatingText = false;
    setState(() {});
  }

  /// Bilinear interpolation for Efficiency (EF)
  double? _interpolateEf(double h, double q) {
    final heads = TurbineChartData.heads;
    final flows = TurbineChartData.flows;

    if (h < heads.first || h > heads.last || q < flows.first || q > flows.last) {
      return null;
    }

    int hIdx0 = 0;
    for (int i = 0; i < heads.length - 1; i++) {
      if (h >= heads[i] && h <= heads[i + 1]) {
        hIdx0 = i;
        break;
      }
    }
    final int hIdx1 = (hIdx0 + 1).clamp(0, heads.length - 1);

    int fIdx0 = 0;
    for (int i = 0; i < flows.length - 1; i++) {
      if (q >= flows[i] && q <= flows[i + 1]) {
        fIdx0 = i;
        break;
      }
    }
    final int fIdx1 = (fIdx0 + 1).clamp(0, flows.length - 1);

    final f00 = flows[fIdx0];
    final f11 = flows[fIdx1];

    final p00 = TurbineChartData.grid[f00]?[hIdx0];
    final p10 = TurbineChartData.grid[f00]?[hIdx1];
    final p01 = TurbineChartData.grid[f11]?[hIdx0];
    final p11 = TurbineChartData.grid[f11]?[hIdx1];

    if (p00 == null || p10 == null || p01 == null || p11 == null) {
      return null;
    }

    final h0 = heads[hIdx0];
    final h1 = heads[hIdx1];
    final tx = (h1 == h0) ? 0.0 : (h - h0) / (h1 - h0);
    final ty = (f11 == f00) ? 0.0 : (q - f00) / (f11 - f00);

    final ef0 = p00.ef * (1 - tx) + p10.ef * tx;
    final ef1 = p01.ef * (1 - tx) + p11.ef * tx;
    return ef0 * (1 - ty) + ef1 * ty;
  }

  @override
  Widget build(BuildContext context) {
    final double? h = double.tryParse(_headController.text);
    final double? totalQ = double.tryParse(_flowController.text);
    final double? unitQ = (totalQ != null) ? totalQ / _turbineCount : null;

    String? warningMsg;
    ChartPoint? nearestPoint;
    double? usedHeadCol;
    int? usedFlowRow;
    double? finalEf;
    double? unitPowerKw;
    double? totalPowerKw;

    if (h != null && unitQ != null) {
      if (h < 6.0 || h > 16.5) {
        warningMsg = 'Net Head ($h m) is outside Chart range (6.0m – 16.5m)';
      } else if (unitQ < 6.0 || unitQ > 22.0) {
        warningMsg =
            'Per-Turbine Flow (${unitQ.toStringAsFixed(2)} Cum/s) is outside Chart range (6 – 22 Cum/s)';
      } else {
        final hIdx = TurbineChartData.nearestHeadIndex(h);
        final fRow = TurbineChartData.nearestFlow(unitQ);
        usedHeadCol = TurbineChartData.heads[hIdx];
        usedFlowRow = fRow;
        nearestPoint = TurbineChartData.grid[fRow]?[hIdx];

        if (nearestPoint == null) {
          warningMsg =
              'Operating point (H=${usedHeadCol}m, Q=$usedFlowRow Cum/s) is in the blank/restricted zone of the chart!';
        } else {
          if (_useInterpolated) {
            finalEf = _interpolateEf(h, unitQ) ?? nearestPoint.ef;
          } else {
            finalEf = nearestPoint.ef;
          }
          // Power (kW) = H x Cum x (EF / 100) x 9.81
          unitPowerKw = h * unitQ * (finalEf / 100.0) * 9.81;
          totalPowerKw = unitPowerKw * _turbineCount;
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turbine Running Calculator',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Chart: ZZ1540 - LJI - 190',
              style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _resetAll,
            icon: const Icon(Icons.refresh, color: Color(0xFF38BDF8)),
            tooltip: 'Clear Inputs',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // INPUT CARD
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
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _levelController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            labelText: 'Water Level (m)',
                            hintText: 'e.g. 89.25',
                          ),
                          onChanged: _onWaterLevelChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _headController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF38BDF8)),
                          decoration: const InputDecoration(
                            labelText: 'Net Head H (m)',
                            helperText: 'Level - 78.64',
                          ),
                          onChanged: _onHeadChanged,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _flowController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      labelText: _turbineCount == 2
                          ? 'Total Outflow Qmax (Cum/s)'
                          : 'Single Turbine Flow Q (Cum/s)',
                      suffixText: 'Cum/s',
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  // Turbine Count Selector
                  Row(
                    children: [
                      const Text(
                        'Running Units:',
                        style: TextStyle(
                            fontSize: 14, color: Color(0xFFCBD5E1)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SegmentedButton<int>(
                          segments: const [
                            ButtonSegment(value: 1, label: Text('1 Turbine')),
                            ButtonSegment(value: 2, label: Text('2 Turbines')),
                          ],
                          selected: {_turbineCount},
                          onSelectionChanged: (val) {
                            setState(() {
                              _turbineCount = val.first;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_turbineCount == 2 && unitQ != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Flow per Turbine: ${unitQ.toStringAsFixed(2)} Cum/s each',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // WARNING BANNER IF OUT OF RANGE
            if (warningMsg != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF450A0A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFEF4444)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFEF4444), size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        warningMsg,
                        style: const TextStyle(
                            color: Color(0xFFFCA5A5),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

            // RESULTS SECTION
            if (warningMsg == null &&
                nearestPoint != null &&
                unitPowerKw != null &&
                totalPowerKw != null) ...[
              // POWER OUTPUT CARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF064E3B), Color(0xFF0F172A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF10B981), width: 1.5),
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
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: Color(0xFF6EE7B7),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065F46),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Chart Cell: H=${usedHeadCol}m, Q=$usedFlowRow',
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFFA7F3D0)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          unitPowerKw.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 36,
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
                          '${(unitPowerKw / 1000).toStringAsFixed(3)} MW',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF34D399),
                          ),
                        ),
                      ],
                    ),
                    if (_turbineCount == 2) ...[
                      const Divider(color: Color(0xFF047857), height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'TOTAL PLANT POWER (2 UNITS):',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFA7F3D0),
                            ),
                          ),
                          Text(
                            '${totalPowerKw.toStringAsFixed(2)} kW (${(totalPowerKw / 1000).toStringAsFixed(3)} MW)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // TURBINE PARAMETERS CARD (BA, WGA, EF)
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
                    const SizedBox(height: 12),
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
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF94A3B8)),
                        ),
                     
