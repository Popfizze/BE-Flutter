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
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec bouton d'édition
          Row(
            children: [
              Expanded(
                child: Text(
                  '${index + 1}. ${experience.title}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              IconButton(
                icon: const Text('✍️', style: TextStyle(fontSize: 18)),
                constraints: const BoxConstraints(
                  minWidth: 30,
                  minHeight: 25,
                ),
                padding: EdgeInsets.zero,
                onPressed: onEditTitle,
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Informations et boutons
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Début: ${dateFormat.format(experience.startDate)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    Text(
                      'Fin: ${dateFormat.format(experience.endDate)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                    Text(
                      'Durée: ${experience.getDuration()} jours',
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),

              // Boutons
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Supprimer'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: onView,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Voir'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
