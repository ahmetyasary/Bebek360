import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/baby.dart';
import '../models/activity.dart';
import '../models/feeding.dart';
import '../models/diaper.dart';

class Activity {
  final DateTime time;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const Activity({
    required this.time,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
  });
}

class ActivityTimeline extends StatelessWidget {
  final Baby baby;

  const ActivityTimeline({
    super.key,
    required this.baby,
  });

  @override
  Widget build(BuildContext context) {
    final activities = _getActivities();
    if (activities.isEmpty) {
      return const Center(
        child: Text('Henüz aktivite yok'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final isLast = index == activities.length - 1;

        return IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 72,
                child: Text(
                  DateFormat('HH:mm').format(activity.time),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: activity.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: activity.color,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      activity.icon,
                      size: 12,
                      color: activity.color,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (activity.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        activity.subtitle!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                    if (!isLast) const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Activity> _getActivities() {
    final List<Activity> activities = [];

    // Son beslenme
    if (baby.lastFeeding != null) {
      activities.add(Activity(
        time: baby.lastFeeding!.startTime,
        title: baby.lastFeeding!.type == FeedingType.breast
            ? 'Anne Sütü'
            : baby.lastFeeding!.type == FeedingType.bottle
                ? 'Biberon'
                : 'Mama',
        subtitle: baby.lastFeeding!.note,
        icon: Icons.restaurant,
        color: Colors.green,
      ));
    }

    // Son bez değişimi
    if (baby.lastDiaper != null) {
      activities.add(Activity(
        time: baby.lastDiaper!.time,
        title: baby.lastDiaper!.type == DiaperType.wet
            ? 'Islak Bez'
            : baby.lastDiaper!.type == DiaperType.dirty
                ? 'Kirli Bez'
                : 'Islak ve Kirli Bez',
        subtitle: baby.lastDiaper!.note,
        icon: Icons.baby_changing_station,
        color: Colors.orange,
      ));
    }

    // Son uyku
    if (baby.lastSleep != null) {
      final isOngoing = baby.lastSleep!.endTime == null;
      final duration = isOngoing
          ? DateTime.now().difference(baby.lastSleep!.startTime)
          : baby.lastSleep!.endTime!.difference(baby.lastSleep!.startTime);
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;

      activities.add(Activity(
        time: baby.lastSleep!.startTime,
        title: isOngoing ? 'Uyuyor' : 'Uyku',
        subtitle: isOngoing
            ? 'Şu ana kadar: $hours saat $minutes dakika'
            : 'Süre: $hours saat $minutes dakika',
        icon: Icons.bedtime,
        color: Colors.purple,
      ));
    }

    // Aktiviteleri zamana göre sırala
    activities.sort((a, b) => b.time.compareTo(a.time));

    return activities;
  }
}
