import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/experience.dart';

class ExperienceCard extends StatelessWidget {
  final int index;
  final Experience experience;
  final VoidCallback onView;
  final VoidCallback onDelete;
  final VoidCallback onEditTitle;

  const ExperienceCard({
    super.key,
    required this.index,
    required this.experience,
    required this.onView,
    required this.onDelete,
    required this.onEditTitle,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM');

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(230, 230, 230, 0.8),
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre avec bouton d'édition
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(
                  // experience.title.substring(0, 1),
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(width: 12),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${dateFormat.format(experience.startDate)} - ${dateFormat.format(experience.endDate)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
