import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/day.dart';

class DayCard extends StatelessWidget {
  final Day day;
  final VoidCallback? onTap;

  const DayCard({
    super.key,
    required this.day,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(230, 230, 230, 0.8),
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
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
                backgroundColor: day.contractRespected ? Colors.green : Colors.deepOrange,
                child: Text(
                  day.rating.toString(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(width: 12),

              // Informations
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormat.format(day.date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.note.isNotEmpty ? day.note : 'Aucune note',
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
    );
  }
}
