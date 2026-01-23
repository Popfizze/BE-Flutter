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
    final dateFormat = DateFormat('d MMM', 'fr_FR');

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(221, 218, 224, 1.0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onSecondaryTapDown: (details) async {
          final result = await showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              details.globalPosition.dx,
              details.globalPosition.dy,
              details.globalPosition.dx,
              details.globalPosition.dy,
            ),
            items: [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Supprimer', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          );
          if (result == 'delete') {
            onDelete();
          }
        },
        child: InkWell(
          onTap: onView,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              CircleAvatar(
                backgroundColor: const Color.fromRGBO(193, 188, 255, 1.0),
                child: Text(
                  // experience.title.substring(0, 1),
                  '${index + 1}',
                  style:
                      const TextStyle(color: Color.fromRGBO(101, 97, 157, 1.0)),
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
      ),
    );
  }
}
