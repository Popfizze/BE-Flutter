import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/experience_provider.dart';
import '../widgets/experience_card.dart';
import '../widgets/add_experience_form.dart';
import 'experience_detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _showForm = false;

  @override
  Widget build(BuildContext context) {
    final experiences = ref.watch(experienceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Experience',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Voici toutes vos expériences',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),

          // Liste des expériences
          Expanded(
            child: experiences.isEmpty
                ? Center(
                    child: Text(
                      'Aucune expérience\nCliquez sur "Créer une expérience"',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: experiences.length,
                    itemBuilder: (context, index) {
                      final experience = experiences[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ExperienceCard(
                          index: index,
                          experience: experience,
                          onView: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExperienceDetailPage(experienceIndex: index),
                              ),
                            );
                          },
                          onDelete: () {
                            _showDeleteConfirmation(context, index);
                          },
                          onEditTitle: () {
                            _showEditTitleDialog(context, index);
                          },
                        ),
                      );
                    },
                  ),
          ),

          // Footer avec bouton et formulaire
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showForm = !_showForm;
                      });
                    },
                    child: const Text('Créer une expérience'),
                  ),
                ),
                if (_showForm) ...[
                  const SizedBox(height: 16),
                  AddExperienceForm(
                    onSubmit: () {
                      setState(() {
                        _showForm = false;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer l\'expérience'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette expérience ?'),
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
