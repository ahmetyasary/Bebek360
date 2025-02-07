import 'package:flutter/material.dart';
import '../models/allergy.dart';

class BabyDashboardScreen extends StatelessWidget {
  const BabyDashboardScreen({super.key});

  Widget _buildQuickStatsCard(
      BuildContext context, String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: Theme.of(context).primaryColor,
            ),
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
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, String title, String time,
      String description, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(time),
            Text(description),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildStatisticCard(
      BuildContext context, String title, Map<String, String> stats) {
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
            const SizedBox(height: 8),
            ...stats.entries
                .map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key),
                          Text(
                            entry.value,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyWarningCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ciddi Alerjiler',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildAllergyChip(
                  context,
                  'Fıstık',
                  AllergyType.food,
                  AllergySeverity.severe,
                ),
                const SizedBox(width: 8),
                _buildAllergyChip(
                  context,
                  'Polen',
                  AllergyType.environmental,
                  AllergySeverity.moderate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergyChip(
    BuildContext context,
    String name,
    AllergyType type,
    AllergySeverity severity,
  ) {
    Color severityColor;
    switch (severity) {
      case AllergySeverity.mild:
        severityColor = Colors.yellow;
        break;
      case AllergySeverity.moderate:
        severityColor = Colors.orange;
        break;
      case AllergySeverity.severe:
        severityColor = Colors.red;
        break;
    }

    IconData typeIcon;
    switch (type) {
      case AllergyType.food:
        typeIcon = Icons.restaurant;
        break;
      case AllergyType.medicine:
        typeIcon = Icons.medication;
        break;
      case AllergyType.environmental:
        typeIcon = Icons.nature;
        break;
      case AllergyType.other:
        typeIcon = Icons.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: severityColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            typeIcon,
            size: 16,
            color: severityColor,
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: TextStyle(
              color: severityColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bebek Bilgileri
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.child_care,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bebek Adı',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('12 aylık'),
                        Text('Doğum: 01.01.2023'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Hızlı İstatistikler
          const Text(
            'Hızlı İstatistikler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildQuickStatsCard(
                context,
                'Son Beslenme',
                '2 saat önce',
                Icons.restaurant,
              ),
              _buildQuickStatsCard(
                context,
                'Son Bez',
                '1 saat önce',
                Icons.baby_changing_station,
              ),
              _buildQuickStatsCard(
                context,
                'Son Uyku',
                '4 saat önce',
                Icons.bedtime,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Günlük İstatistikler
          const Text(
            'Günlük İstatistikler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatisticCard(
                  context,
                  'Beslenme',
                  {
                    'Toplam': '6 kez',
                    'Anne Sütü': '4 kez',
                    'Mama': '2 kez',
                    'Miktar': '600ml',
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatisticCard(
                  context,
                  'Bez',
                  {
                    'Toplam': '8 kez',
                    'Islak': '6 kez',
                    'Kirli': '2 kez',
                    'Son': '1 saat önce',
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatisticCard(
                  context,
                  'Uyku',
                  {
                    'Toplam Süre': '14 saat',
                    'Öğle Uykusu': '2 saat',
                    'Gece Uykusu': '12 saat',
                    'Uyanma': '2 kez',
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatisticCard(
                  context,
                  'Gelişim',
                  {
                    'Boy': '75 cm',
                    'Kilo': '9.5 kg',
                    'Baş Çevresi': '45 cm',
                    'Yaş': '12 ay',
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Alerji Uyarıları
          const SizedBox(height: 16),
          const Text(
            'Alerji Uyarıları',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildAllergyWarningCard(context),

          // Son Aktiviteler
          const SizedBox(height: 16),
          const Text(
            'Son Aktiviteler',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildActivityCard(
            context,
            'Beslenme',
            '14:30',
            '200ml Anne Sütü',
            Icons.restaurant,
          ),
          _buildActivityCard(
            context,
            'Bez Değişimi',
            '15:30',
            'Islak Bez',
            Icons.baby_changing_station,
          ),
          _buildActivityCard(
            context,
            'Uyku',
            '12:00 - 14:00',
            '2 saat uyku',
            Icons.bedtime,
          ),

          // Yaklaşan Hatırlatmalar
          const SizedBox(height: 16),
          const Text(
            'Yaklaşan Hatırlatmalar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.vaccines, color: Colors.red),
              title: const Text('2 Aylık Aşıları'),
              subtitle: const Text('3 gün sonra'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Detaylar'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
