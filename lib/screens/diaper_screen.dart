import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/baby_provider.dart';
import '../models/diaper.dart';
import '../models/baby.dart';
import '../services/notification_service.dart';

class DiaperScreen extends StatelessWidget {
  const DiaperScreen({super.key});

  Widget _buildDiaperCard(
    BuildContext context, {
    required String time,
    required DiaperType type,
    String? note,
  }) {
    IconData typeIcon;
    String typeText;
    Color typeColor;

    switch (type) {
      case DiaperType.wet:
        typeIcon = Icons.water_drop;
        typeText = 'Islak';
        typeColor = Colors.blue;
        break;
      case DiaperType.dirty:
        typeIcon = Icons.recycling;
        typeText = 'Kirli';
        typeColor = Colors.brown;
        break;
      case DiaperType.both:
        typeIcon = Icons.warning_amber;
        typeText = 'Islak ve Kirli';
        typeColor = Colors.purple;
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(typeIcon, color: typeColor),
                const SizedBox(width: 8),
                Text(
                  typeText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

  Widget _buildStatisticCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiaperTypeButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Üst Butonlar
          Row(
            children: [
              _buildDiaperTypeButton(
                context,
                'Islak',
                Icons.water_drop,
                Colors.blue,
                () {
                  // TODO: Islak bez değişimi ekle
                },
              ),
              const SizedBox(width: 8),
              _buildDiaperTypeButton(
                context,
                'Kirli',
                Icons.recycling,
                Colors.brown,
                () {
                  // TODO: Kirli bez değişimi ekle
                },
              ),
              const SizedBox(width: 8),
              _buildDiaperTypeButton(
                context,
                'Her İkisi',
                Icons.warning_amber,
                Colors.purple,
                () {
                  // TODO: Her ikisi için bez değişimi ekle
                },
              ),
            ],
          ),

          // Günlük İstatistikler
          const SizedBox(height: 24),
          const Text(
            'Günlük İstatistikler',
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
            childAspectRatio: 0.8,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildStatisticCard(
                context,
                'Toplam\nDeğişim',
                '8',
                Icons.baby_changing_station,
              ),
              _buildStatisticCard(
                context,
                'Islak\nBez',
                '6',
                Icons.water_drop,
              ),
              _buildStatisticCard(
                context,
                'Kirli\nBez',
                '2',
                Icons.recycling,
              ),
            ],
          ),

          // Son Değişimler
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Son Değişimler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Tüm değişimleri görüntüle
                },
                icon: const Icon(Icons.history),
                label: const Text('Tümü'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildDiaperCard(
            context,
            time: '15:30',
            type: DiaperType.wet,
            note: 'Normal miktar',
          ),
          _buildDiaperCard(
            context,
            time: '13:15',
            type: DiaperType.both,
            note: 'Pişik kremi uygulandı',
          ),
          _buildDiaperCard(
            context,
            time: '10:45',
            type: DiaperType.dirty,
            note: 'Kahverengi, normal kıvam',
          ),

          // Hatırlatıcı Kartı
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Bez Değişimi Hatırlatıcısı',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Son değişimden bu yana 2 saat geçti',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        // TODO: Hatırlatıcı ayarlarını düzenle
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Hatırlatıcıyı Düzenle'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
