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
      color: const Color.fromRGBO(213, 213, 218, 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Row(
            children: [
              Text(
                experience.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              Text(
                '${dateFormat.format(experience.startDate)} - ${dateFormat.format(experience.endDate)}',
                style: const TextStyle(
                  fontSize: 17,
                  color: Color.fromRGBO(173, 172, 176, 1.0),
                ),
              ),
            ],
          )),
          Text(
            'Contrat: ${experience.contract}',
            style: const TextStyle(
              fontSize: 17,
              color: Color.fromRGBO(173, 172, 176, 1.0),
            ),
          ),
        ],
      ),
    );
  }
}
