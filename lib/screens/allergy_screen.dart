import 'package:flutter/material.dart';
import '../models/allergy.dart';

class AllergyScreen extends StatelessWidget {
  const AllergyScreen({super.key});

  Widget _buildAllergyCard(
    BuildContext context, {
    required String name,
    required AllergyType type,
    required AllergySeverity severity,
    required DateTime diagnosisDate,
    String? symptoms,
    String? treatment,
    String? notes,
    bool isActive = true,
  }) {
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(typeIcon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: severityColor),
                  ),
                  child: Text(
                    severity.name,
                    style: TextStyle(
                      color: severityColor.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (!isActive) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Text(
                      'Pasif',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Tanı Tarihi: ${diagnosisDate.day}/${diagnosisDate.month}/${diagnosisDate.year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            if (symptoms != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Belirtiler:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(symptoms),
            ],
            if (treatment != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Tedavi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(treatment),
            ],
            if (notes != null) ...[
              const SizedBox(height: 8),
              const Text(
                'Notlar:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(notes),
            ],
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
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Aktif Alerjiler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  // TODO: Yeni alerji ekleme
                },
                icon: const Icon(Icons.add),
                label: const Text('Yeni Alerji'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAllergyCard(
            context,
            name: 'Fıstık',
            type: AllergyType.food,
            severity: AllergySeverity.severe,
            diagnosisDate: DateTime(2023, 6, 15),
            symptoms: 'Nefes darlığı, döküntü',
            treatment: 'Adrenalin oto-enjektör',
            notes: 'Tüm fıstık türlerinden uzak durulmalı',
          ),
          _buildAllergyCard(
            context,
            name: 'Polen',
            type: AllergyType.environmental,
            severity: AllergySeverity.moderate,
            diagnosisDate: DateTime(2023, 8, 1),
            symptoms: 'Hapşırma, burun akıntısı',
            treatment: 'Antihistaminik',
          ),
          _buildAllergyCard(
            context,
            name: 'Penisilin',
            type: AllergyType.medicine,
            severity: AllergySeverity.mild,
            diagnosisDate: DateTime(2023, 3, 10),
            symptoms: 'Hafif döküntü',
            treatment: 'Alternatif antibiyotik kullanımı',
            isActive: false,
          ),
          const SizedBox(height: 24),
          const Text(
            'Alerji İstatistikleri',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '3',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Text('Toplam Alerji'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '2',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Text('Aktif Alerji'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '1',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const Text('Ciddi Alerji'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
