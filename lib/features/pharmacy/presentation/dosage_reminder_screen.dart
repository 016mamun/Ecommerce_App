import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';
import '../domain/providers/dosage_reminder_provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme_colors.dart';

class DosageReminderScreen extends ConsumerWidget {
  const DosageReminderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reminders = ref.watch(dosageReminderProvider);

    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.surfaceColor,
        elevation: 0,
        title: Text(
          AppStrings.dosageReminder,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: context.textPrimaryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left, color: context.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Header banner ────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.pharmacyGradientStart,
                  AppColors.pharmacyGradientEnd,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('⏰', style: TextStyle(fontSize: 40)),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Never Miss a Dose',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Set personalised reminders for all your medicines.',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── List ────────────────────────────────────────────────────────
          Expanded(
            child: reminders.isEmpty
                ? _EmptyReminders()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final r = reminders[index];
                      return _ReminderCard(reminder: r);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddReminderSheet(context, ref),
        backgroundColor: AppColors.pharmacyPrimary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(AppStrings.addReminder,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  void _showAddReminderSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddReminderSheet(ref: ref),
    );
  }
}

// ── Reminder Card ─────────────────────────────────────────────────────────────
class _ReminderCard extends ConsumerWidget {
  final DosageReminder reminder;

  const _ReminderCard({required this.reminder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(reminder.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Iconsax.trash, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(dosageReminderProvider.notifier).removeReminder(reminder.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.reminderDeleted),
            backgroundColor: AppColors.pharmacyPrimary,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: reminder.isEnabled
                ? AppColors.pharmacyPrimary.withOpacity(0.3)
                : context.borderColor,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: reminder.isEnabled
                    ? AppColors.pharmacyPrimary.withOpacity(0.12)
                    : context.borderColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Iconsax.alarm,
                color: reminder.isEnabled
                    ? AppColors.pharmacyPrimary
                    : Colors.grey,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.medicineName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Iconsax.clock,
                          size: 13, color: context.textMutedColor),
                      const SizedBox(width: 4),
                      Text(
                        reminder.time,
                        style: TextStyle(
                            fontSize: 12, color: context.textMutedColor),
                      ),
                      const SizedBox(width: 10),
                      Icon(Iconsax.repeat,
                          size: 13, color: context.textMutedColor),
                      const SizedBox(width: 4),
                      Text(
                        reminder.frequency.label,
                        style: TextStyle(
                            fontSize: 12, color: context.textMutedColor),
                      ),
                    ],
                  ),
                  if (reminder.notes != null &&
                      reminder.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      reminder.notes!,
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.pharmacyPrimary,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
            // Toggle
            Switch.adaptive(
              value: reminder.isEnabled,
              activeColor: AppColors.pharmacyPrimary,
              onChanged: (_) => ref
                  .read(dosageReminderProvider.notifier)
                  .toggleReminder(reminder.id),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyReminders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.pharmacyLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.alarm,
                size: 44, color: AppColors.pharmacyPrimary),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.noReminders,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.pharmacyPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.noRemindersSub,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ── Add Reminder Bottom Sheet ─────────────────────────────────────────────────
class _AddReminderSheet extends StatefulWidget {
  final WidgetRef ref;

  const _AddReminderSheet({required this.ref});

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  ReminderFrequency _selectedFrequency = ReminderFrequency.daily;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 8,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: context.borderColor,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            AppStrings.addReminder,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: context.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),

          // Medicine name field
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: AppStrings.medicineName,
              prefixIcon: const Icon(Iconsax.health,
                  color: AppColors.pharmacyPrimary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColors.pharmacyPrimary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Time picker
          GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                          primary: AppColors.pharmacyPrimary),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                setState(() => _selectedTime = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.pharmacyPrimary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.pharmacyPrimary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Iconsax.clock,
                      color: AppColors.pharmacyPrimary, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.reminderTime,
                    style: TextStyle(
                        color: context.textMutedColor, fontSize: 14),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(_selectedTime),
                    style: const TextStyle(
                      color: AppColors.pharmacyPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Frequency selector
          Text(
            AppStrings.frequency,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: context.textSecondaryColor),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ReminderFrequency.values.map((freq) {
                final isSelected = _selectedFrequency == freq;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFrequency = freq),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.pharmacyPrimary
                          : context.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.pharmacyPrimary
                            : context.borderColor,
                      ),
                    ),
                    child: Text(
                      freq.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : context.textSecondaryColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Notes field
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Notes (optional)',
              hintText: 'e.g. Take with food',
              prefixIcon: const Icon(Iconsax.note,
                  color: AppColors.pharmacyPrimary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColors.pharmacyPrimary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Save button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.trim().isEmpty) return;
                widget.ref.read(dosageReminderProvider.notifier).addReminder(
                      DosageReminder(
                        id: const Uuid().v4(),
                        medicineName: _nameController.text.trim(),
                        time: _formatTime(_selectedTime),
                        frequency: _selectedFrequency,
                        notes: _notesController.text.trim().isNotEmpty
                            ? _notesController.text.trim()
                            : null,
                      ),
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.reminderAdded),
                    backgroundColor: AppColors.pharmacyPrimary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pharmacyPrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text(
                'Save Reminder',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
