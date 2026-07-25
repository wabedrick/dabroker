import 'package:broker_app/features/consultations/repositories/consultation_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ScheduleConsultationScreen extends ConsumerStatefulWidget {
  final int professionalId;
  final String professionalName;

  const ScheduleConsultationScreen({
    super.key,
    required this.professionalId,
    required this.professionalName,
  });

  @override
  ConsumerState<ScheduleConsultationScreen> createState() =>
      _ScheduleConsultationScreenState();
}

class _ScheduleConsultationScreenState
    extends ConsumerState<ScheduleConsultationScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final scheduledAt = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      await ref
          .read(consultationRepositoryProvider)
          .requestConsultation(
            professionalId: widget.professionalId,
            scheduledAt: scheduledAt,
            notes: _notesController.text,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consultation requested successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Consultation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.primaryContainer,
                    child: Text(
                      widget.professionalName.isNotEmpty
                          ? widget.professionalName[0].toUpperCase()
                          : '?',
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Book a session with',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.professionalName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Select Date & Time',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border.all(
                          color: _selectedDate == null
                              ? colorScheme.outlineVariant
                              : colorScheme.primary,
                          width: _selectedDate == null ? 1 : 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: _selectedDate == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Date',
                            style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedDate == null
                                ? 'Choose Date'
                                : DateFormat('MMM d, yyyy').format(
                                    _selectedDate!),
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: _selectedDate == null
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: _selectedDate == null
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        border: Border.all(
                          color: _selectedTime == null
                              ? colorScheme.outlineVariant
                              : colorScheme.primary,
                          width: _selectedTime == null ? 1 : 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: _selectedTime == null
                                ? colorScheme.onSurfaceVariant
                                : colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Time',
                            style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedTime == null
                                ? 'Choose Time'
                                : _selectedTime!.format(context),
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: _selectedTime == null
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                              color: _selectedTime == null
                                  ? colorScheme.onSurfaceVariant
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Session Notes',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Briefly describe what you would like to discuss...',
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.3,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _isLoading ? null : _submitBooking,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
