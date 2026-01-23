import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/experience_provider.dart';
import '../experience_card.dart';

class ExperienceListView extends ConsumerWidget {
  final Function(int) onSelect;

  const ExperienceListView({
    super.key,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experiences = ref.watch(experienceProvider);

    if (experiences.isEmpty) {
      return const Center(
        child: Text(''),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final experience = experiences[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ExperienceCard(
            index: index,
            experience: experience,
            onView: () => onSelect(index),
            onDelete: () => _showDeleteConfirmation(context, ref, index),
            onEditTitle: () => _showEditTitleDialog(context, ref, index),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, int index) {
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

  void _showEditTitleDialog(BuildContext context, WidgetRef ref, int index) {
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
