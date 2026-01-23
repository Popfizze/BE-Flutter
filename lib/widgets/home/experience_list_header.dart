import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/experience_provider.dart';
import '../add_experience_form.dart';

class ExperienceListHeader extends ConsumerWidget {
  const ExperienceListHeader({super.key});

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
            color: Colors.black.withValues(alpha: 0.4),
          ),
        ),
        SizedBox(
          width: 50,
          height: 40,
          child: IconButton(
            color: Colors.black.withValues(alpha: 0.4),
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
