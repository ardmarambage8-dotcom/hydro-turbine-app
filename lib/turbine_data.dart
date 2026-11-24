class ChartPoint {
  final int ba;
  final int wga;
  final double ef;

  const ChartPoint(this.ba, this.wga, this.ef);
}

class TurbineChartData {
  // Water Head Columns (m)
  static const List<double> heads = [
    6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 16.5
  ];

  // Water Quantity / Discharge Rows (Cum/s): 6 to 22
  static const List<int> flows = [
    6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
  ];

  // Turbine Running Chart ZZ1540 - LJI - 190
  // Map<Flow (Cum/s), List<ChartPoint?>> aligned with [heads]
  static const Map<int, List<ChartPoint?>> grid = {
    6: [
      null, null, null, null, null, null, null, null, null, null, null, null
    ],
    7: [
      null,
      ChartPoint(8, 31, 80.0),
      ChartPoint(9, 29, 80.0),
      ChartPoint(9, 28, 82.0),
      ChartPoint(9, 27, 83.0),
      ChartPoint(10, 25, 83.0),
      ChartPoint(10, 24, 85.0),
      ChartPoint(10, 23, 86.0),
      ChartPoint(10, 22, 86.0),
      ChartPoint(9, 22, 88.0),
      ChartPoint(10, 20, 87.0),
      ChartPoint(9, 20, 89.0),
    ],
    8: [
      null,
      ChartPoint(7, 33, 82.0),
      ChartPoint(8, 31, 80.0),
      ChartPoint(8, 30, 83.0),
      ChartPoint(8, 29, 84.0),
      ChartPoint(8, 28, 86.0),
      ChartPoint(8, 26, 87.0),
      ChartPoint(9, 25, 86.0),
      ChartPoint(8, 24, 88.0),
      ChartPoint(8, 23, 89.0),
      ChartPoint(8, 22, 89.0),
      ChartPoint(8, 21, 89.0),
    ],
    9: [
      null,
      ChartPoint(6, 35, 83.0),
      ChartPoint(6, 34, 84.0),
      ChartPoint(7, 32, 84.0),
      ChartPoint(7, 31, 85.0),
      ChartPoint(7, 30, 86.0),
      ChartPoint(7, 28, 88.0),
      ChartPoint(7, 27, 89.0),
      ChartPoint(7, 26, 89.0),
      ChartPoint(7, 25, 90.0),
      ChartPoint(6, 24, 91.0),
      ChartPoint(6, 23, 91.0),
    ],
    10: [
      null,
      ChartPoint(4, 38, 85.0),
      ChartPoint(5, 36, 85.0),
      ChartPoint(5, 34, 86.0),
      ChartPoint(5, 33, 87.0),
      ChartPoint(5, 32, 88.0),
      ChartPoint(5, 31, 89.0),
      ChartPoint(5, 29, 90.0),
      ChartPoint(5, 28, 90.0),
      ChartPoint(5, 27, 91.0),
      ChartPoint(5, 25, 91.0),
      ChartPoint(5, 25, 91.0),
    ],
    11: [
      null,
      ChartPoint(3, 40, 85.0),
      ChartPoint(3, 39, 86.0),
      ChartPoint(3, 37, 88.0),
      ChartPoint(4, 35, 88.0),
      ChartPoint(4, 33, 89.0),
      ChartPoint(4, 32, 90.0),
      ChartPoint(4, 31, 90.0),
      ChartPoint(4, 29, 91.0),
      ChartPoint(4, 28, 91.0),
      ChartPoint(3, 27, 92.0),
      ChartPoint(3, 26, 92.0),
    ],
    12: [
      null,
      ChartPoint(2, 43, 86.0),
      ChartPoint(2, 41, 88.0),
      ChartPoint(2, 39, 88.0),
      ChartPoint(3, 37, 89.0),
      ChartPoint(3, 35, 90.0),
      ChartPoint(3, 34, 90.0),
      ChartPoint(3, 32, 91.0),
      ChartPoint(7, 31, 92.0),
      ChartPoint(2, 30, 92.0),
      ChartPoint(2, 29, 92.5),
      ChartPoint(1, 28, 92.5),
    ],
    13: [
      null,
      ChartPoint(0, 45, 86.0),
      ChartPoint(1, 43, 88.0),
      ChartPoint(1, 41, 89.0),
      ChartPoint(1, 39, 90.0),
      ChartPoint(1, 37, 91.0),
      ChartPoint(1, 36, 91.0),
      ChartPoint(1, 34, 92.0),
      ChartPoint(1, 33, 92.5),
      ChartPoint(1, 31, 92.5),
      ChartPoint(0, 30, 93.0),
      ChartPoint(0, 29, 93.0),
    ],
    14: [
      null,
      ChartPoint(1, 47, 88.0),
      ChartPoint(2, 48, 87.0),
      ChartPoint(0, 43, 88.0),
      ChartPoint(0, 41, 89.0),
      ChartPoint(0, 39, 90.0),
      ChartPoint(0, 37, 91.0),
      ChartPoint(2, 38, 92.0),
      ChartPoint(0, 34, 92.0),
      ChartPoint(1, 33, 93.0),
      ChartPoint(1, 32, 93.0),
      ChartPoint(1, 31, 93.0),
    ],
    15: [
      null,
      ChartPoint(3, 48, 87.0),
      ChartPoint(2, 48, 87.0),
      ChartPoint(1, 45, 88.0),
      ChartPoint(1, 43, 89.0),
      ChartPoint(1, 41, 90.0),
      ChartPoint(1, 39, 91.0),
      ChartPoint(2, 38, 92.0),
      ChartPoint(2, 36, 92.5),
      ChartPoint(2, 35, 92.5),
      ChartPoint(3, 33, 93.0),
      ChartPoint(2, 32, 93.0),
    ],
    16: [
      null,
      ChartPoint(4, 52, 85.0),
      ChartPoint(3, 50, 87.0),
      ChartPoint(2, 47, 88.0),
      ChartPoint(2, 45, 89.0),
      ChartPoint(2, 43, 90.0),
      ChartPoint(3, 41, 91.0),
      ChartPoint(3, 39, 92.0),
      ChartPoint(3, 38, 92.5),
      ChartPoint(3, 36, 92.5),
      ChartPoint(4, 35, 93.0),
      ChartPoint(4, 34, 93.0),
    ],
    17: [
      null,
      ChartPoint(5, 54, 86.0),
      ChartPoint(4, 52, 87.0),
      ChartPoint(3, 49, 88.0),
      ChartPoint(3, 47, 89.0),
      ChartPoint(3, 45, 90.0),
      ChartPoint(4, 43, 91.0),
      ChartPoint(4, 41, 92.0),
      ChartPoint(4, 39, 92.5),
      ChartPoint(4, 37, 93.0),
      ChartPoint(5, 36, 93.0),
      ChartPoint(5, 35, 93.0),
    ],
    18: [
      null,
      ChartPoint(5, 57, 85.0),
      ChartPoint(5, 54, 86.0),
      ChartPoint(5, 52, 88.0),
      ChartPoint(4, 49, 89.0),
      ChartPoint(4, 47, 90.0),
      ChartPoint(5, 45, 91.0),
      ChartPoint(5, 43, 92.0),
      ChartPoint(5, 41, 92.0),
      ChartPoint(6, 39, 92.5),
      ChartPoint(6, 36, 93.0),
      ChartPoint(6, 36, 93.0),
    ],
    19: [
      null,
      null,
      null,
      ChartPoint(6, 54, 87.0),
      ChartPoint(6, 51, 89.0),
      ChartPoint(6, 49, 90.0),
      ChartPoint(6, 46, 91.0),
      ChartPoint(6, 44, 91.0),
      ChartPoint(7, 42, 92.0),
      ChartPoint(7, 40, 92.5),
      ChartPoint(7, 39, 92.5),
      ChartPoint(8, 38, 92.5),
    ],
    20: [
      null,
      null,
      null,
      ChartPoint(7, 56, 87.0),
      ChartPoint(7, 53, 89.0),
      ChartPoint(6, 50, 90.0),
      ChartPoint(7, 48, 91.0),
      ChartPoint(7, 46, 91.0),
      ChartPoint(8, 44, 92.0),
      ChartPoint(8, 42, 92.5),
      ChartPoint(9, 40, 92.5),
      ChartPoint(9, 39, 92.5),
    ],
    21: [
      null,
      null,
      null,
      ChartPoint(8, 58, 87.0),
      ChartPoint(7, 55, 88.0),
      ChartPoint(7, 53, 89.0),
      ChartPoint(8, 50, 90.0),
      ChartPoint(8, 47, 91.0),
      ChartPoint(9, 45, 92.0),
      ChartPoint(9, 43, 92.0),
      ChartPoint(9, 41, 92.5),
      ChartPoint(10, 40, 92.5),
    ],
    22: [
      null,
      null,
      null,
      ChartPoint(9, 60, 86.0),
      ChartPoint(8, 57, 87.0),
      ChartPoint(8, 54, 89.0),
      ChartPoint(9, 52, 90.0),
      ChartPoint(9, 49, 90.0),
      ChartPoint(9, 47, 91.0),
      ChartPoint(10, 44, 92.0),
      ChartPoint(10, 42, 92.5),
      ChartPoint(9, 43, 92.0),
    ],
  };

  /// Find nearest head index in [heads]
  static int nearestHeadIndex(double h) {
    int bestIdx = 0;
    double minDiff = (heads[0] - h).abs();
    for (int i = 1; i < heads.length; i++) {
      final diff = (heads[i] - h).abs();
      if (diff < minDiff) {
        minDiff = diff;
        bestIdx = i;
      }
    }
    return bestIdx;
  }

  /// Find nearest flow (Cum/s) in [flows]
  static int nearestFlow(double q) {
    int bestFlow = flows[0];
    double minDiff = (flows[0] - q).abs();
    for (final f in flows) {
      final diff = (f - q).abs();
      if (diff < minDiff) {
        minDiff = diff;
        bestFlow = f;
      }
    }
    return bestFlow;
  }
}

