import 'package:flutter/material.dart';
import '../add_experience_form.dart';

class ExperienceListHeader extends StatelessWidget {
  const ExperienceListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Experiences',
          style: TextStyle(
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
