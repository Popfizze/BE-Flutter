import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/day.dart';
import 'package:intl/intl.dart';

class ExperienceGraph extends StatelessWidget {
  final List<Day> days;
  final DateTime startDate;
  final DateTime endDate;

  const ExperienceGraph({
    super.key,
    required this.days,
    required this.startDate,
    required this.endDate,
  });

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final start = _normalizeDate(startDate);
    final end = _normalizeDate(endDate);
    
    // Calcul de la durée totale en jours
    // Si end est avant start (erreur de saisie), on assume au moins 1 jour
    int totalDays = end.difference(start).inDays;
    if (totalDays < 0) totalDays = 0;
    
    // Si l'expérience est sur un seul jour, on met min 1 pour l'affichage
    final double maxX = totalDays > 0 ? totalDays.toDouble() : 5.0; // Par défaut 5 jours si 0

    // Filtrer et préparer les données
    // On ne garde que le DERNIER rating par jour pour le graphique (si plusieurs entrées le même jour)
    final Map<int, int> dailyRatings = {};

    for (var day in days) {
      if (!day.isValid()) continue;
      
      final dayDate = _normalizeDate(day.date);
      final difference = dayDate.difference(start).inDays;
      
      // On accepte les jours même s'ils sont hors de la plage théorique (extension dynamique ?)
      // Pour l'instant on se limite à afficher ceux >= 0
      if (difference >= 0) {
        dailyRatings[difference] = day.rating;
      }
    }

    // Créer les spots triés par jour
    List<FlSpot> spots = dailyRatings.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));
      
    // Si des points dépassent la durée prévue (endDate), on étend le graphe
    if (spots.isNotEmpty && spots.last.x > maxX) {
        // On ne change pas maxX ici car on veut voir la limite de fin théorique ? 
        // Non, on veut voir tous les points.
        // Mais la consigne dit "voir tous les jours de l'expérience". 
        // Gardons maxX basé sur endDate, sauf si dépassement significatif ?
        // Restons sur endDate pour l'instant comme cadre de référence.
    }

    // Couleurs inspirées du thème
    const lineColor = Color(0xFF7B86AA); 
    const fillColor = Color(0xFF9FA8DA); 

    return Container(
      color: const Color.fromRGBO(240, 240, 245, 1.0),
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 24.0,
        top: 24.0,
        bottom: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                clipData: const FlClipData.all(),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1, 
                      getTitlesWidget: (value, meta) {
                        final int offsetDays = value.toInt();
                        
                        // Calcul dynamique de l'intervalle d'affichage des dates
                        // Affiche max ~5 dates sur l'axe
                        int interval = 1;
                        if (maxX > 10) {
                            interval = (maxX / 5).ceil();
                        }
                        
                        if (offsetDays % interval == 0 && offsetDays <= maxX + 1) { // +1 marge
                            final dateToShow = start.add(Duration(days: offsetDays));
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                DateFormat('dd/MM').format(dateToShow),
                                style: const TextStyle(
                                  color: Color(0xff68737d),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 == 0) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                color: Color(0xff67727d),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d).withValues(alpha: 0.1)),
                ),
                minX: 0,
                maxX: maxX, 
                minY: 1, 
                maxY: 5, 
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    preventCurveOverShooting: true, 
                    color: lineColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: fillColor.withValues(alpha: 0.3),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                                final textStyle = TextStyle(
                                  color: touchedSpot.bar.gradient?.colors.first ??
                                      touchedSpot.bar.color ??
                                      Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                return LineTooltipItem(
                                    '${touchedSpot.y.toInt()}', textStyle);
                            }).toList();
                        }
                    )
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}
