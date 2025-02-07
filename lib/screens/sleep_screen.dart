import 'package:flutter/material.dart';
import '../models/sleep.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  Widget _buildSleepCard(
    BuildContext context, {
    required String startTime,
    String? endTime,
    String? duration,
    String? note,
    bool isActive = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isActive ? Icons.bedtime : Icons.bedtime_outlined,
                  color: isActive ? Colors.indigo : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isActive ? 'Şu an uyuyor' : 'Uyku Kaydı',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        endTime != null
                            ? '$startTime - $endTime'
                            : 'Başlangıç: $startTime',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (duration != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.indigo.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      duration,
                      style: TextStyle(
                        color: isActive ? Colors.indigo : Colors.grey,
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
                    // TODO: Uyku başlat
                  },
                  icon: const Icon(Icons.bedtime),
                  label: const Text('Uyku Başlat'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Uyku bitir
                  },
                  icon: const Icon(Icons.alarm_off),
                  label: const Text('Uyku Bitir'),
                ),
              ),
            ],
          ),

          // Aktif Uyku Kartı (varsa)
          const SizedBox(height: 24),
          _buildSleepCard(
            context,
            startTime: '20:30',
            duration: '2 saat 15 dk',
            note: 'Ninni ile uyudu',
            isActive: true,
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
                'Toplam\nUyku',
                '14 saat',
                Icons.bedtime,
              ),
              _buildStatisticCard(
                context,
                'Gece\nUykusu',
                '10 saat',
                Icons.dark_mode,
              ),
              _buildStatisticCard(
                context,
                'Gündüz\nUykusu',
                '4 saat',
                Icons.light_mode,
              ),
            ],
          ),

          // Uyku Kalitesi
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        'Uyku Kalitesi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '3',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const Text('Uyanma'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '85%',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const Text('Verimlilik'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '2 saat',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const Text('En Uzun'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Son Uykular
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Son Uykular',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Tüm uyku kayıtlarını görüntüle
                },
                icon: const Icon(Icons.history),
                label: const Text('Tümü'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSleepCard(
            context,
            startTime: '13:00',
            endTime: '15:15',
            duration: '2 saat 15 dk',
            note: 'Öğle uykusu',
          ),
          _buildSleepCard(
            context,
            startTime: '20:00',
            endTime: '06:00',
            duration: '10 saat',
            note: 'Gece uykusu',
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
                        'Uyku Hatırlatıcısı',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bir sonraki uyku zamanına 2 saat kaldı',
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
