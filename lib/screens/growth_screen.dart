import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GrowthScreen extends StatelessWidget {
  const GrowthScreen({super.key});

  Widget _buildGrowthCard(
    BuildContext context, {
    required String date,
    required double weight,
    required double height,
    required double headCircumference,
    String? note,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMeasurementItem(
                  context,
                  Icons.monitor_weight,
                  'Kilo',
                  '$weight kg',
                  Colors.blue,
                ),
                _buildMeasurementItem(
                  context,
                  Icons.height,
                  'Boy',
                  '$height cm',
                  Colors.green,
                ),
                _buildMeasurementItem(
                  context,
                  Icons.face,
                  'Baş Çevresi',
                  '$headCircumference cm',
                  Colors.orange,
                ),
              ],
            ),
            if (note != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.note, size: 16),
                  const SizedBox(width: 4),
                  Text('Not: $note'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMeasurementItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildGrowthChart(
      BuildContext context, String title, List<FlSpot> spots, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
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

  @override
  Widget build(BuildContext context) {
    // Örnek grafik verileri
    final weightData = [
      FlSpot(0, 3.5),
      FlSpot(1, 4.2),
      FlSpot(2, 5.1),
      FlSpot(3, 5.8),
      FlSpot(4, 6.3),
      FlSpot(5, 7.0),
    ];

    final heightData = [
      FlSpot(0, 50),
      FlSpot(1, 54),
      FlSpot(2, 58),
      FlSpot(3, 61),
      FlSpot(4, 64),
      FlSpot(5, 67),
    ];

    final headData = [
      FlSpot(0, 35),
      FlSpot(1, 37),
      FlSpot(2, 39),
      FlSpot(3, 40),
      FlSpot(4, 41),
      FlSpot(5, 42),
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Üst Butonlar
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Yeni ölçüm ekle
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Yeni Ölçüm'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                onPressed: () {
                  // TODO: Persentil tablosunu göster
                },
                icon: const Icon(Icons.table_chart),
                tooltip: 'Persentil Tablosu',
              ),
            ],
          ),

          // Son Ölçüm
          const SizedBox(height: 24),
          const Text(
            'Son Ölçüm',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildGrowthCard(
            context,
            date: '15.01.2024',
            weight: 7.0,
            height: 67,
            headCircumference: 42,
            note: 'Normal gelişim devam ediyor',
          ),

          // Gelişim Grafikleri
          const SizedBox(height: 24),
          const Text(
            'Gelişim Grafikleri',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildGrowthChart(
              context, 'Kilo Gelişimi (kg)', weightData, Colors.blue),
          const SizedBox(height: 8),
          _buildGrowthChart(
              context, 'Boy Gelişimi (cm)', heightData, Colors.green),
          const SizedBox(height: 8),
          _buildGrowthChart(
              context, 'Baş Çevresi Gelişimi (cm)', headData, Colors.orange),

          // Önceki Ölçümler
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Önceki Ölçümler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Tüm ölçümleri görüntüle
                },
                icon: const Icon(Icons.history),
                label: const Text('Tümü'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildGrowthCard(
            context,
            date: '15.12.2023',
            weight: 6.3,
            height: 64,
            headCircumference: 41,
          ),
          _buildGrowthCard(
            context,
            date: '15.11.2023',
            weight: 5.8,
            height: 61,
            headCircumference: 40,
          ),
        ],
      ),
    );
  }
}
