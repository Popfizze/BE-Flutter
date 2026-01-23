import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../models/experience.dart';
import '../../providers/experience_provider.dart';

class DayDetailPanel extends ConsumerStatefulWidget {
  final int dayIndex;
  final Experience experience;
  final int experienceIndex;

  const DayDetailPanel({
    super.key,
    required this.dayIndex,
    required this.experience,
    required this.experienceIndex,
  });

  @override
  ConsumerState<DayDetailPanel> createState() => _DayDetailPanelState();
}

class _DayDetailPanelState extends ConsumerState<DayDetailPanel> {
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(
        text: widget.experience.days[widget.dayIndex].note);
  }

  @override
  void didUpdateWidget(DayDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dayIndex != oldWidget.dayIndex) {
      _noteController.text = widget.experience.days[widget.dayIndex].note;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onNoteChanged(String value) {
    final day = widget.experience.days[widget.dayIndex];
    ref.read(experienceProvider.notifier).updateDay(
          experienceIndex: widget.experienceIndex,
          dayIndex: widget.dayIndex,
          rating: day.rating,
          note: value,
          contractRespected: day.contractRespected,
        );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMMM y', 'fr_FR');
    final day = widget.experience.days[widget.dayIndex];

    return Container(
      color: const Color.fromRGBO(213, 213, 218, 1.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(213, 213, 218, 1.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateFormat.format(day.getDate()),
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  'Jour ${widget.dayIndex + 1}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  day.isContractRespected()
                      ? 'Contrat respecté'
                      : 'Contrat non respecté',
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _noteController,
                maxLines: null,
                expands: true,
                cursorColor: Colors.black,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: _onNoteChanged,
              ),
            ),
          )
        ],
      ),
    );
  }
}
