import 'package:be_flutter/widgets/day_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/experience_provider.dart';

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
  DateTime _selectedDate = DateTime.now();
  int _selectedRating = 4;
  bool _contractRespected = false;
  double _leftPanelWidth = 100.0;

  final List<String> _ratingLabels = [
    'Très mauvaise (1)',
    'Mauvaise (2)',
    'Neutre (3)',
    'Bonne (4)',
    'Très bonne (5)',
  ];

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

    final dateFormat = DateFormat('dd/MM');

    return Column(
      children: [
        // En-tête personnalisé (simulant une AppBar)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                experience.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${dateFormat.format(experience.startDate)} - ${dateFormat.format(experience.endDate)}',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                'Contrat: ${experience.contract}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        // Contenu scrollable
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Graphique de progression\n(À implémenter)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                        width: _leftPanelWidth,
                        child: Container(
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Journées',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black
                                              .withValues(alpha: 0.3),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ]),
                                Container(
                                  child: experience.days.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Aucun jours',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 156, 63, 63),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          itemCount: experience.days.length,
                                          itemBuilder: (context, index) {
                                            final day = experience.days[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16),
                                              child: DayCard(
                                                  day: day, onTap: () {}),
                                            );
                                          },
                                        ),
                                )
                              ],
                            ))),
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
                        child: Container(
                            color: const Color(0XDEDEDEFF),
                            child: const Column(
                              children: [Text("test")],
                            ))),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _rateDay() {
    ref.read(experienceProvider.notifier).rateExperienceDay(
          experienceIndex: widget.experienceIndex,
          rating: _selectedRating,
          date: _selectedDate,
          note: ' ',
          contractRespected: _contractRespected,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Journée notée avec succès'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showEditTitleDialog(BuildContext context) {
    final controller = TextEditingController(
      text: ref
          .read(experienceProvider.notifier)
          .getExperienceTitle(widget.experienceIndex),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le titre'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Nouveau titre',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(experienceProvider.notifier).updateExperienceTitle(
                  widget.experienceIndex, controller.text);
              Navigator.pop(context);
              setState(() {}); // Refresh UI
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEditDatesDialog(BuildContext context) {
    final experience = ref
        .read(experienceProvider.notifier)
        .getExperience(widget.experienceIndex);
    if (experience == null) return;

    DateTime startDate = experience.startDate;
    DateTime endDate = experience.endDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Modifier les dates'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Date de début'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(startDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      startDate = picked;
                    });
                  }
                },
              ),
              ListTile(
                title: const Text('Date de fin'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(endDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: endDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setDialogState(() {
                      endDate = picked;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                ref.read(experienceProvider.notifier).updateExperienceDates(
                    widget.experienceIndex, startDate, endDate);
                Navigator.pop(context);
                setState(() {}); // Refresh UI
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEndExperienceDialog(BuildContext context) {
    final mean = ref
        .read(experienceProvider.notifier)
        .getExperienceMean(widget.experienceIndex);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Expérience terminée'),
        content: Text(
          'L\'expérience est finie.\nEn moyenne, vous avez un score de journée de ${mean?.toStringAsFixed(2) ?? '0.00'}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
