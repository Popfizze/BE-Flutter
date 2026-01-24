import 'package:flutter/material.dart';
import '../models/day.dart';
import '../models/ratings_labels.dart';

class DayCard extends StatelessWidget {
  final Day day;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final int index;

  const DayCard({
    super.key,
    required this.day,
    this.onTap,
    this.onDelete,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final ratingLabel = RatingsLabels.values
        .firstWhere((e) => e.value == day.rating,
            orElse: () => RatingsLabels.neutre)
        .label;

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(221, 218, 224, 1.0),
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onSecondaryTapDown: (details) async {
          if (onDelete == null) return;
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
            onDelete!();
          }
        },
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Rating Avatar
              CircleAvatar(
                backgroundColor: const Color.fromRGBO(193, 188, 255, 1.0),
                child: Text(
                  day.rating.toString(),
                  style:
                      const TextStyle(color: Color.fromRGBO(87, 83, 141, 1.0)),
                ),
              ),

              const SizedBox(width: 12),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jour ${index + 1} ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Note:  $ratingLabel',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      day.contractRespected
                          ? 'Contrat: Respecté'
                          : 'Contrat: Non respecté',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Indicator for invalid days
              if (!day.valid)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.block, color: Colors.red),
                ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
