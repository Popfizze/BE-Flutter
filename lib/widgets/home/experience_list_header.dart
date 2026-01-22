import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/experience_provider.dart';
import '../add_experience_form.dart';

class ExperienceListHeader extends ConsumerWidget {
  final VoidCallback onClearAll;

  const ExperienceListHeader({
    super.key,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Experiences',
          style: GoogleFonts.dosis(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black.withValues(alpha: 0.3),
          ),
        ),
        SizedBox(
          width: 50,
          child: IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Tout supprimer ?'),
                  content: const Text(
                      'Cette action est irréversible. Toutes les expériences seront perdues.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Annuler'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(experienceProvider.notifier)
                            .clearAllExperiences();
                        onClearAll();
                        Navigator.pop(context);
                      },
                      child: const Text('Tout supprimer',
                          style: TextStyle(color: Colors.red)),
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
                    title: const Text("Ajouter une expérience"),
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
      ],
    );
  }
}
