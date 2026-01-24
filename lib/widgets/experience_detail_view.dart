import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/experience_provider.dart';
import 'experience_details/experience_header.dart';
import 'experience_details/experience_graph.dart';
import 'experience_details/day_list_panel.dart';
import 'experience_details/day_detail_panel.dart';

class ExperienceDetailView extends ConsumerStatefulWidget {
  final int experienceIndex;

  const ExperienceDetailView({
    super.key,
    required this.experienceIndex,
  });

  @override
  ConsumerState<ExperienceDetailView> createState() =>
      _ExperienceDetailViewState();
}

class _ExperienceDetailViewState extends ConsumerState<ExperienceDetailView> {
  double _leftPanelWidth = 360;
  double _bottomPanelHeight = 380;
  int? _dayIndex;

  @override
  Widget build(BuildContext context) {
    final experiences = ref.watch(experienceProvider);

    if (widget.experienceIndex < 0 || widget.experienceIndex >= experiences.length) {
      return const Center(
        child: Text('Expérience non trouvée'),
      );
    }

    final experience = experiences[widget.experienceIndex];

    // Vérification de sécurité pour l'index du jour sélectionné
    if (_dayIndex != null && _dayIndex! >= experience.days.length) {
       // On corrige l'état après la frame pour ne pas casser le build
       WidgetsBinding.instance.addPostFrameCallback((_) {
         if (mounted) {
           setState(() {
             _dayIndex = null;
           });
         }
       });
    }

    // Variable locale pour l'affichage sécurisé
    final int? safeDayIndex = (_dayIndex != null && _dayIndex! < experience.days.length) 
        ? _dayIndex 
        : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        const minBottomPanelHeight = 240.0;
        const minLeftPanelWidth = 280.0;
        const minRightPanelWidth = 200.0;

        final maxBottomPanelHeight = (constraints.maxHeight - 100).clamp(minBottomPanelHeight, constraints.maxHeight * 0.8);
        final maxLeftPanelWidth = (constraints.maxWidth - minRightPanelWidth).clamp(minLeftPanelWidth, constraints.maxWidth * 0.6);

        if (_bottomPanelHeight > maxBottomPanelHeight) {
          _bottomPanelHeight = maxBottomPanelHeight;
        }
        if (_bottomPanelHeight < minBottomPanelHeight) {
          _bottomPanelHeight = minBottomPanelHeight;
        }
        if (_leftPanelWidth > maxLeftPanelWidth) {
          _leftPanelWidth = maxLeftPanelWidth;
        }
        if (_leftPanelWidth < minLeftPanelWidth) {
          _leftPanelWidth = minLeftPanelWidth;
        }

        final effectiveLeftPanelWidth = _leftPanelWidth.clamp(minLeftPanelWidth, maxLeftPanelWidth);

        return Column(
          children: [
            // En-tête personnalisé (simulant une AppBar)
            ExperienceHeader(experience: experience),

            // Contenu scrollable
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ExperienceGraph(
                      days: experience.days,
                      startDate: experience.startDate,
                      endDate: experience.endDate,
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeRow,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          _bottomPanelHeight -= details.delta.dy;
                          if (_bottomPanelHeight < minBottomPanelHeight) {
                            _bottomPanelHeight = minBottomPanelHeight;
                          }
                          if (_bottomPanelHeight > maxBottomPanelHeight) {
                            _bottomPanelHeight = maxBottomPanelHeight;
                          }
                        });
                      },
                      child: Container(
                        height: 5,
                        color: const Color.fromRGBO(213, 213, 218, 1.0),
                        alignment: Alignment.center,
                        child: Container(
                          height: 1,
                          color: const Color.fromARGB(255, 167, 167, 167),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: _bottomPanelHeight,
                      child: Container(
                        color: const Color.fromRGBO(206, 206, 211, 1.0),
                        child: Row(
                          children: [
                            DayListPanel(
                              width: effectiveLeftPanelWidth,
                              experience: experience,
                              experienceIndex: widget.experienceIndex,
                              onDaySelected: (index) {
                                setState(() {
                                  _dayIndex = index;
                                });
                              },
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.resizeColumn,
                              child: GestureDetector(
                                onHorizontalDragUpdate: (details) {
                                  setState(() {
                                    _leftPanelWidth += details.delta.dx;
                                    if (_leftPanelWidth < minLeftPanelWidth) {
                                      _leftPanelWidth = minLeftPanelWidth;
                                    }
                                    if (_leftPanelWidth > maxLeftPanelWidth) {
                                      _leftPanelWidth = maxLeftPanelWidth;
                                    }
                                  });
                                },
                                child: Container(
                                  width: 5,
                                  color: const Color.fromRGBO(213, 213, 218, 1.0),
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 1,
                                    color: const Color.fromARGB(255, 175, 175, 175),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: safeDayIndex == null
                                  ? const SizedBox()
                                  : DayDetailPanel(
                                      dayIndex: safeDayIndex,
                                      experience: experience,
                                      experienceIndex: widget.experienceIndex,
                                    ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
