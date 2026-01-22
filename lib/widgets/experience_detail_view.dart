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
  double _leftPanelWidth = 125.0;
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
              const ExperienceGraph(),
              const SizedBox(height: 24),
              Expanded(
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
                            if (_leftPanelWidth < 200) _leftPanelWidth = 200;
                          });
                        },
                        child: Container(
                          width: 10,
                          color: const Color.fromRGBO(230, 230, 230, 0.8),
                          alignment: Alignment.center,
                          child: Container(
                            width: 0,
                            color: const Color.fromRGBO(230, 230, 230, 0.8),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DayDetailPanel(
                        dayIndex: _dayIndex,
                        experience: experience,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}