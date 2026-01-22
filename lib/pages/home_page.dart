import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/experience_provider.dart';
import '../widgets/experience_card.dart';
import '../widgets/add_experience_form.dart';
import '../widgets/experience_detail_view.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final bool _showForm = false;
  double _leftPanelWidth = 450.0;
  int? _selectedExperienceIndex;

  @override
  Widget build(BuildContext context) {
    final experiences = ref.watch(experienceProvider);

    return Scaffold(
      backgroundColor: const Color(0x9092AAFF),
      body: SafeArea(
        child: Container(
            padding: const EdgeInsets.only(top: 10, left: 25),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                      width: _leftPanelWidth,
                      key: const Key("leftPanel"),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        color: const Color.fromRGBO(222, 222, 222, 0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                key: const Key('header'),
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Experiences',
                                    style: GoogleFonts.dosis(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: IconButton(
                                      icon: const Icon(Icons.delete_forever,
                                          color: Colors.redAccent),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Tout supprimer ?'),
                                            content: const Text(
                                                'Cette action est irréversible. Toutes les expériences seront perdues.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context),
                                                child: const Text('Annuler'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  ref
                                                      .read(experienceProvider
                                                          .notifier)
                                                      .clearAllExperiences();
                                                  setState(() {
                                                    _selectedExperienceIndex =
                                                        null;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                    'Tout supprimer',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50,
                                    child: IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Ajouter une expérience"),
                                              content: SizedBox(
                                                width: 400,
                                                child: AddExperienceForm(
                                                  onSubmit: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ]),
                            const SizedBox(height: 15),
                            Expanded(
                              key: const Key('experienceList'),
                              child: experiences.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Aucune expérience',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 156, 63, 63),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      itemCount: experiences.length,
                                      itemBuilder: (context, index) {
                                        final experience = experiences[index];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: ExperienceCard(
                                            index: index,
                                            experience: experience,
                                            onView: () {
                                              setState(() {
                                                _selectedExperienceIndex =
                                                    index;
                                              });
                                            },
                                            onDelete: () {
                                              _showDeleteConfirmation(
                                                  context, index);
                                            },
                                            onEditTitle: () {
                                              _showEditTitleDialog(
                                                  context, index);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      )),
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
                      key: const Key('rightPanel'),
                      color: const Color(0XDEDEDEFF),
                      child: _selectedExperienceIndex != null
                          ? ExperienceDetailView(
                              experienceIndex: _selectedExperienceIndex!,
                              // Force rebuild when selection changes
                              key: ValueKey(_selectedExperienceIndex),
                            )
                          : const Center(
                              child: Text(
                                'Sélectionnez une expérience pour voir les détails',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'expérience'),
        content:
            const Text('Êtes-vous sûr de vouloir supprimer cette expérience ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              ref.read(experienceProvider.notifier).deleteExperience(index);
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditTitleDialog(BuildContext context, int index) {
    final controller = TextEditingController(
      text: ref.read(experienceProvider.notifier).getExperienceTitle(index),
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
              ref
                  .read(experienceProvider.notifier)
                  .updateExperienceTitle(index, controller.text);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
