import 'package:flutter/material.dart';
import '../../models/experience.dart';
import '../add_day_form.dart';
import '../day_card.dart';

class DayListPanel extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Journées',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withValues(alpha: 0.3),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Ajouter une expérience"),
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
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DayCard(
                              day: day,
                              onTap: () {
                                onDaySelected(index);
                              },
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
