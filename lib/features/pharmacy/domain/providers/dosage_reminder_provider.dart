import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReminderFrequency { once, daily, twiceDaily, threeTimesDaily, custom }

extension ReminderFrequencyExt on ReminderFrequency {
  String get label {
    switch (this) {
      case ReminderFrequency.once:
        return 'Once';
      case ReminderFrequency.daily:
        return 'Once Daily';
      case ReminderFrequency.twiceDaily:
        return 'Twice Daily';
      case ReminderFrequency.threeTimesDaily:
        return 'Three Times Daily';
      case ReminderFrequency.custom:
        return 'Custom';
    }
  }
}

class DosageReminder extends Equatable {
  final String id;
  final String medicineName;
  final String time; // e.g. "08:00 AM"
  final ReminderFrequency frequency;
  final bool isEnabled;
  final String? notes;

  const DosageReminder({
    required this.id,
    required this.medicineName,
    required this.time,
    required this.frequency,
    this.isEnabled = true,
    this.notes,
  });

  DosageReminder copyWith({
    String? medicineName,
    String? time,
    ReminderFrequency? frequency,
    bool? isEnabled,
    String? notes,
  }) {
    return DosageReminder(
      id: id,
      medicineName: medicineName ?? this.medicineName,
      time: time ?? this.time,
      frequency: frequency ?? this.frequency,
      isEnabled: isEnabled ?? this.isEnabled,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id];
}

class DosageReminderNotifier extends StateNotifier<List<DosageReminder>> {
  DosageReminderNotifier()
      : super([
          // Pre-seeded sample reminder so the screen isn't empty on first load
          const DosageReminder(
            id: 'seed_1',
            medicineName: 'Glucomet (Metformin)',
            time: '08:00 AM',
            frequency: ReminderFrequency.twiceDaily,
            isEnabled: true,
            notes: 'Take with breakfast',
          ),
          const DosageReminder(
            id: 'seed_2',
            medicineName: 'Atorva (Atorvastatin)',
            time: '09:00 PM',
            frequency: ReminderFrequency.daily,
            isEnabled: true,
            notes: 'Take after dinner',
          ),
        ]);

  void addReminder(DosageReminder reminder) {
    state = [...state, reminder];
  }

  void removeReminder(String id) {
    state = state.where((r) => r.id != id).toList();
  }

  void toggleReminder(String id) {
    state = state.map((r) {
      if (r.id == id) return r.copyWith(isEnabled: !r.isEnabled);
      return r;
    }).toList();
  }
}

final dosageReminderProvider =
    StateNotifierProvider<DosageReminderNotifier, List<DosageReminder>>((ref) {
  return DosageReminderNotifier();
});
