import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/baby_provider.dart';
import '../models/vaccine.dart';
import '../models/baby.dart';

class VaccineScreen extends StatefulWidget {
  const VaccineScreen({super.key});

  @override
  State<VaccineScreen> createState() => _VaccineScreenState();
}

class _VaccineScreenState extends State<VaccineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  final _doctorController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isAddingVaccine = false;

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _doctorController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _toggleAddVaccine() {
    setState(() {
      _isAddingVaccine = !_isAddingVaccine;
      if (!_isAddingVaccine) {
        _resetForm();
      }
    });
  }

  Future<void> _saveVaccine() async {
    if (_formKey.currentState!.validate()) {
      final babyProvider = Provider.of<BabyProvider>(context, listen: false);
      final baby = babyProvider.selectedBaby;

      if (baby != null) {
        try {
          await babyProvider.addVaccine(
            'USER_ID', // TODO: Get actual user ID
            baby.id,
            _nameController.text.trim(),
            _selectedDate,
            note: _noteController.text.trim(),
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aşı kaydedildi')),
            );
            _toggleAddVaccine();
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${e.toString()}')),
            );
          }
        }
      }
    }
  }

  void _resetForm() {
    setState(() {
      _selectedDate = DateTime.now();
      _nameController.clear();
      _noteController.clear();
      _doctorController.clear();
      _locationController.clear();
    });
  }

  Future<void> _markAsDone(Vaccine vaccine) async {
    final babyProvider = Provider.of<BabyProvider>(context, listen: false);
    final baby = babyProvider.selectedBaby;

    if (baby != null) {
      try {
        final updatedVaccine = vaccine.copyWith(
          isDone: true,
          doneDate: DateTime.now(),
        );

        await babyProvider.updateVaccine(
          'USER_ID', // TODO: Get actual user ID
          baby.id,
          updatedVaccine,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aşı yapıldı olarak işaretlendi')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _deleteVaccine(String vaccineId) async {
    final babyProvider = Provider.of<BabyProvider>(context, listen: false);
    final baby = babyProvider.selectedBaby;

    if (baby != null) {
      try {
        await babyProvider.deleteVaccine(
          'USER_ID', // TODO: Get actual user ID
          baby.id,
          vaccineId,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aşı silindi')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: ${e.toString()}')),
          );
        }
      }
    }
  }

  Widget _buildVaccineCard(
    BuildContext context, {
    required String babyId,
    required String name,
    required String date,
    required bool isDone,
    String? doctor,
    String? location,
    String? note,
    String? nextDose,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDone
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDone ? Icons.check_circle : Icons.schedule,
                    color: isDone ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isDone)
                  FilledButton.icon(
                    onPressed: () => _markAsDone(Vaccine(
                      id: '',
                      babyId: babyId,
                      name: name,
                      date: DateTime.parse(date),
                      isDone: false,
                      doneDate: null,
                      note: note,
                    )),
                    icon: const Icon(Icons.check),
                    label: const Text('Yapıldı'),
                  ),
              ],
            ),
            if (doctor != null || location != null) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              if (doctor != null)
                Row(
                  children: [
                    const Icon(Icons.medical_services,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text('Dr. $doctor'),
                  ],
                ),
              if (location != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(location),
                  ],
                ),
              ],
            ],
            if (note != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.note, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(note)),
                ],
              ),
            ],
            if (nextDose != null && isDone) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.event_repeat, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    'Sonraki Doz: $nextDose',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
            if (!isDone) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Düzenleme işlevi
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Düzenle'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Hatırlatıcı ayarla
                    },
                    icon: const Icon(Icons.notifications),
                    label: const Text('Hatırlatıcı'),
                  ),
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
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
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
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddVaccineForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.vaccines, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Yeni Aşı Ekle',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _toggleAddVaccine,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Aşı Adı',
                  hintText: 'Örn: BCG',
                  prefixIcon: Icon(Icons.vaccines),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen aşı adını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _doctorController,
                decoration: const InputDecoration(
                  labelText: 'Doktor Adı',
                  hintText: 'Örn: Dr. Ahmet Yılmaz',
                  prefixIcon: Icon(Icons.medical_services),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Hastane/Klinik',
                  hintText: 'Örn: Merkez Hastanesi',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Tarih',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Not',
                  hintText: 'İsteğe bağlı not ekleyin',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saveVaccine,
                      icon: const Icon(Icons.save),
                      label: const Text('Kaydet'),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
              'Aşı takibi yapabilmek için önce bir bebek eklemelisiniz',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                // TODO: Bebek ekleme ekranına yönlendir
              },
              icon: const Icon(Icons.add),
              label: const Text('Bebek Ekle'),
            ),
          ],
        ),
      );
    }

    final vaccines = baby.vaccines;
    final completedVaccines = vaccines.where((v) => v.isDone).length;
    final pendingVaccines = vaccines.where((v) => !v.isDone).length;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Üst Butonlar
          if (!_isAddingVaccine)
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _toggleAddVaccine,
                    icon: const Icon(Icons.add),
                    label: const Text('Yeni Aşı'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () {
                    // TODO: Aşı takvimini göster
                  },
                  icon: const Icon(Icons.calendar_month),
                  tooltip: 'Aşı Takvimi',
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: () {
                    // TODO: Hatırlatıcıları göster
                  },
                  icon: const Icon(Icons.notifications),
                  tooltip: 'Hatırlatıcılar',
                ),
              ],
            )
          else
            _buildAddVaccineForm(),

          if (!_isAddingVaccine) ...[
            // İstatistikler
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Aşı İstatistikleri',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    // TODO: İstatistik detaylarını göster
                  },
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('Detaylar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildStatisticCard(
                    context,
                    'Toplam\nAşı',
                    vaccines.length.toString(),
                    Icons.vaccines,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatisticCard(
                    context,
                    'Tamamlanan\nAşılar',
                    completedVaccines.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatisticCard(
                    context,
                    'Bekleyen\nAşılar',
                    pendingVaccines.toString(),
                    Icons.schedule,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            // Yaklaşan Aşılar
            if (pendingVaccines > 0) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Yaklaşan Aşılar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Takvimde göster
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Takvimde Göster'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...vaccines
                  .where((v) => !v.isDone)
                  .map((vaccine) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildVaccineCard(
                          context,
                          babyId: baby.id,
                          name: vaccine.name,
                          date:
                              '${vaccine.date.day}/${vaccine.date.month}/${vaccine.date.year}',
                          isDone: false,
                          note: vaccine.note,
                        ),
                      ))
                  .toList(),
            ],

            // Tamamlanan Aşılar
            if (completedVaccines > 0) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Tamamlanan Aşılar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Tüm aşıları görüntüle
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('Tümü'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...vaccines
                  .where((v) => v.isDone)
                  .take(3)
                  .map((vaccine) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _buildVaccineCard(
                          context,
                          babyId: baby.id,
                          name: vaccine.name,
                          date:
                              '${vaccine.date.day}/${vaccine.date.month}/${vaccine.date.year}',
                          isDone: true,
                          note: vaccine.note,
                        ),
                      ))
                  .toList(),
            ],
          ],
        ],
      ),
      floatingActionButton: !_isAddingVaccine
          ? FloatingActionButton(
              onPressed: _toggleAddVaccine,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
