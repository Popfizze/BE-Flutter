import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/experience.dart';

class ExperienceHeader extends StatelessWidget {
  final Experience experience;

  const ExperienceHeader({super.key, required this.experience});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            experience.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            '${dateFormat.format(experience.startDate)} - ${dateFormat.format(experience.endDate)}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'Contrat: ${experience.contract}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
