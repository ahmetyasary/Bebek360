import 'package:flutter/material.dart';
import '../models/feeding.dart';

class FeedingScreen extends StatelessWidget {
  const FeedingScreen({super.key});

  Widget _buildFeedingCard(
    BuildContext context, {
    required String time,
    required FeedingType type,
    String? amount,
    String? duration,
    String? note,
  }) {
    IconData typeIcon;
    String typeText;
    Color typeColor;

    switch (type) {
      case FeedingType.breast:
        typeIcon = Icons.pregnant_woman;
        typeText = 'Anne Sütü';
        typeColor = Colors.pink;
        break;
      case FeedingType.bottle:
        typeIcon = Icons.baby_changing_station;
        typeText = 'Mama';
        typeColor = Colors.blue;
        break;
      case FeedingType.food:
        typeIcon = Icons.restaurant;
        typeText = 'Ek Gıda';
        typeColor = Colors.green;
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
            if (amount != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.water_drop, size: 16),
                  const SizedBox(width: 4),
                  Text('Miktar: $amount'),
                ],
              ),
            ],
            if (duration != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.timer, size: 16),
                  const SizedBox(width: 4),
                  Text('Süre: $duration'),
                ],
              ),
            ],
            if (note != null) ...[
              const SizedBox(height: 4),
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
      BuildContext context, String title, String value, IconData icon) {
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

  @override
  Widget build(BuildContext context) {
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
                    // TODO: Anne sütü beslenmesi ekle
                  },
                  icon: const Icon(Icons.pregnant_woman),
                  label: const Text('Anne Sütü'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Mama beslenmesi ekle
                  },
                  icon: const Icon(Icons.baby_changing_station),
                  label: const Text('Mama'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    // TODO: Ek gıda beslenmesi ekle
                  },
                  icon: const Icon(Icons.restaurant),
                  label: const Text('Ek Gıda'),
                ),
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
                'Toplam\nBeslenme',
                '6',
                Icons.restaurant,
              ),
              _buildStatisticCard(
                context,
                'Toplam\nMiktar',
                '600ml',
                Icons.water_drop,
              ),
              _buildStatisticCard(
                context,
                'Ortalama\nAralık',
                '3 saat',
                Icons.timer,
              ),
            ],
          ),

          // Son Beslenmeler
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Son Beslenmeler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Tüm beslenmeleri görüntüle
                },
                icon: const Icon(Icons.history),
                label: const Text('Tümü'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildFeedingCard(
            context,
            time: '14:30',
            type: FeedingType.breast,
            duration: '20 dakika',
            note: 'Sol göğüs',
          ),
          _buildFeedingCard(
            context,
            time: '11:15',
            type: FeedingType.bottle,
            amount: '120ml',
            note: 'Tam içti',
          ),
          _buildFeedingCard(
            context,
            time: '08:00',
            type: FeedingType.food,
            amount: '1 porsiyon',
            note: 'Meyve püresi',
          ),
        ],
      ),
    );
  }
}
