import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/experience.dart';

class DayDetailPanel extends StatelessWidget {
  final int? dayIndex;
  final Experience experience;

  const DayDetailPanel({
    super.key,
    required this.dayIndex,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM');

    return Container(
      color: const Color(0XDEDEDEFF),
      child: dayIndex == null
          ? const SizedBox.shrink()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        experience.days[dayIndex!].getDate().toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Jour ${dayIndex! + 1}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Column(
                        children: [
                          Text(
                            experience.days[dayIndex!].getNote(),
                          ),
                          Text(
                            experience.days[dayIndex!].isContractRespected()
                                ? 'Contrat respecté'
                                : 'Contrat non respecté',
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(child: Text(experience.days[dayIndex!].getNote()))
              ],
            ),
    );
  }
}
