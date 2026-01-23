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
    final experience = ref
        .watch(experienceProvider.notifier)
        .getExperience(widget.experienceIndex);

    if (experience == null) {
      return const Center(
        child: Text('Expérience non trouvée'),
      );
    }

    return Column(
      children: [
        // En-tête personnalisé (simulant une AppBar)
        ExperienceHeader(experience: experience),

        // Contenu scrollable
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                child: ExperienceGraph(),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.resizeRow,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _bottomPanelHeight -= details.delta.dy;
                      if (_bottomPanelHeight < 240) _bottomPanelHeight = 240;
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
                          width: _leftPanelWidth,
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
                                if (_leftPanelWidth < 360) {
                                  _leftPanelWidth = 360;
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
                          child: _dayIndex == null
                              ? const SizedBox()
                              : DayDetailPanel(
                                  dayIndex: _dayIndex!,
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
  }
}
