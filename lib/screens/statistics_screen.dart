import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/baby_provider.dart';
import '../models/baby.dart';
import '../models/feeding.dart';
import '../models/diaper.dart';
import '../models/sleep.dart';
import '../screens/add_baby_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _selectedPeriod = 7; // Varsayılan olarak son 7 gün

  List<FlSpot> _getFeedingSpots(List<Feeding> feedings) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: _selectedPeriod));

    // Günlük beslenme sayılarını hesapla
    final Map<int, int> dailyCounts = {};
    for (var feeding in feedings) {
      if (feeding.startTime.isAfter(startDate)) {
        final day = feeding.startTime.difference(startDate).inDays;
        dailyCounts[day] = (dailyCounts[day] ?? 0) + 1;
      }
    }

    return List.generate(_selectedPeriod, (index) {
      return FlSpot(index.toDouble(), (dailyCounts[index] ?? 0).toDouble());
    });
  }

  List<FlSpot> _getDiaperSpots(List<Diaper> diapers) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: _selectedPeriod));

    final Map<int, int> dailyCounts = {};
    for (var diaper in diapers) {
      if (diaper.time.isAfter(startDate)) {
        final day = diaper.time.difference(startDate).inDays;
        dailyCounts[day] = (dailyCounts[day] ?? 0) + 1;
      }
    }

    return List.generate(_selectedPeriod, (index) {
      return FlSpot(index.toDouble(), (dailyCounts[index] ?? 0).toDouble());
    });
  }

  List<FlSpot> _getSleepSpots(List<Sleep> sleeps) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: _selectedPeriod));

    final Map<int, double> dailyHours = {};
    for (var sleep in sleeps) {
      if (sleep.startTime.isAfter(startDate)) {
        final day = sleep.startTime.difference(startDate).inDays;
        final duration = sleep.endTime != null
            ? sleep.endTime!.difference(sleep.startTime)
            : const Duration();
        dailyHours[day] = (dailyHours[day] ?? 0) + duration.inHours;
      }
    }

    return List.generate(_selectedPeriod, (index) {
      return FlSpot(index.toDouble(), dailyHours[index] ?? 0);
    });
  }

  Widget _buildChart(
    String title,
    List<FlSpot> spots,
    Color color,
    String yAxisLabel,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 2,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                      axisNameWidget: Text(yAxisLabel),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final now = DateTime.now();
                          final date = now.subtract(Duration(
                              days: _selectedPeriod - value.toInt() - 1));
                          return Text('${date.day}/${date.month}');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: color.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final baby = Provider.of<BabyProvider>(context).selectedBaby;

    if (baby == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.child_care,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Henüz bir bebek eklenmemiş',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'İstatistikleri görüntülemek için önce bir bebek eklemelisiniz',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddBabyScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Bebek Ekle'),
            ),
          ],
        ),
      );
    }

    // Son 24 saatteki istatistikler
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));

    final feedingsLast24h =
        baby.feedings.where((f) => f.startTime.isAfter(last24Hours)).length;

    final diapersLast24h =
        baby.diapers.where((d) => d.time.isAfter(last24Hours)).length;

    final sleepHoursLast24h = baby.sleeps
        .where((s) => s.startTime.isAfter(last24Hours))
        .fold<Duration>(Duration.zero, (total, sleep) {
      if (sleep.endTime != null) {
        return total + sleep.endTime!.difference(sleep.startTime);
      }
      return total;
    }).inHours;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Son 24 Saat',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Beslenme',
                  '$feedingsLast24h kez',
                  Icons.restaurant,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Bez',
                  '$diapersLast24h kez',
                  Icons.baby_changing_station,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Uyku',
                  '$sleepHoursLast24h saat',
                  Icons.bedtime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Dönem:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment<int>(
                    value: 7,
                    label: Text('7 Gün'),
                  ),
                  ButtonSegment<int>(
                    value: 14,
                    label: Text('14 Gün'),
                  ),
                  ButtonSegment<int>(
                    value: 30,
                    label: Text('30 Gün'),
                  ),
                ],
                selected: {_selectedPeriod},
                onSelectionChanged: (Set<int> selected) {
                  setState(() {
                    _selectedPeriod = selected.first;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildChart(
            'Günlük Beslenme Sayısı',
            _getFeedingSpots(baby.feedings),
            Colors.blue,
            'Beslenme',
          ),
          const SizedBox(height: 16),
          _buildChart(
            'Günlük Bez Değişimi',
            _getDiaperSpots(baby.diapers),
            Colors.orange,
            'Bez',
          ),
          const SizedBox(height: 16),
          _buildChart(
            'Günlük Uyku Süresi (Saat)',
            _getSleepSpots(baby.sleeps),
            Colors.purple,
            'Saat',
          ),
        ],
      ),
    );
  }
}
