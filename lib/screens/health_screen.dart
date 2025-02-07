import 'package:flutter/material.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sağlık Takibi'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Aşılar'),
              Tab(text: 'Doktor'),
              Tab(text: 'İlaçlar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVaccinationsTab(),
            _buildDoctorVisitsTab(),
            _buildMedicationsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Yeni kayıt ekleme
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildVaccinationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildVaccinationCard(
          name: 'BCG',
          date: '15.03.2024',
          status: 'Tamamlandı',
          notes: 'Sol omuz',
        ),
        const SizedBox(height: 8),
        _buildVaccinationCard(
          name: 'Hepatit B',
          date: '20.03.2024',
          status: 'Planlandı',
          notes: 'İkinci doz',
        ),
      ],
    );
  }

  Widget _buildVaccinationCard({
    required String name,
    required String date,
    required String status,
    String? notes,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: status == 'Tamamlandı'
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            status == 'Tamamlandı' ? Icons.check : Icons.schedule,
            color: status == 'Tamamlandı' ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date),
            if (notes != null)
              Text(
                notes,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: Text(
          status,
          style: TextStyle(
            color: status == 'Tamamlandı' ? Colors.green : Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorVisitsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDoctorVisitCard(
          doctorName: 'Dr. Ayşe Yılmaz',
          specialty: 'Çocuk Doktoru',
          date: '10.03.2024',
          notes: 'Rutin kontrol',
        ),
        const SizedBox(height: 8),
        _buildDoctorVisitCard(
          doctorName: 'Dr. Mehmet Demir',
          specialty: 'Çocuk Alerji',
          date: '25.03.2024',
          notes: 'Alerji testi',
        ),
      ],
    );
  }

  Widget _buildDoctorVisitCard({
    required String doctorName,
    required String specialty,
    required String date,
    String? notes,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(specialty),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(date),
              ],
            ),
            if (notes != null) ...[
              const SizedBox(height: 8),
              Text(
                notes,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildMedicationCard(
          name: 'D Vitamini',
          dosage: '3 damla',
          frequency: 'Günde 1 kez',
          duration: '6 ay',
        ),
        const SizedBox(height: 8),
        _buildMedicationCard(
          name: 'Demir',
          dosage: '1 ölçek',
          frequency: 'Günde 1 kez',
          duration: '3 ay',
        ),
      ],
    );
  }

  Widget _buildMedicationCard({
    required String name,
    required String dosage,
    required String frequency,
    required String duration,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medication,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(dosage),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 8),
                    Text(frequency),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(duration),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
