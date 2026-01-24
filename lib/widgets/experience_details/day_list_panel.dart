import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/experience.dart';
import '../../providers/experience_provider.dart';
import '../add_day_form.dart';
import '../day_card.dart';

class DayListPanel extends ConsumerWidget {
  final double width;
  final Experience experience;
  final int experienceIndex;
  final ValueChanged<int> onDaySelected;

  const DayListPanel({
    super.key,
    required this.width,
    required this.experience,
    required this.experienceIndex,
    required this.onDaySelected,
  });

  void _showDeleteDayConfirmation(
      BuildContext context, WidgetRef ref, int dayIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer la journée'),
        content:
            const Text('Êtes-vous sûr de vouloir supprimer cette journée ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(experienceProvider.notifier)
                  .deleteDay(experienceIndex, dayIndex);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(6),
        color: const Color.fromRGBO(213, 213, 218, 1.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Journées',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(173, 172, 176, 1.0),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: const Color.fromRGBO(173, 172, 176, 1.0),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Ajouter un jour"),
                            content: SizedBox(
                              width: 550,
                              child: AddDayForm(
                                onSubmit: () {
                                  Navigator.of(context).pop();
                                },
                                experienceIndex: experienceIndex,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                child: experience.days.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucun jours',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 156, 63, 63),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: experience.days.length,
                        itemBuilder: (context, index) {
                          final day = experience.days[index];
                          return Padding(
                            key: ValueKey('day_$index'),
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DayCard(
                              index: index,
                              day: day,
                              onTap: () {
                                onDaySelected(index);
                              },
                              onDelete: () => _showDeleteDayConfirmation(
                                  context, ref, index),
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
