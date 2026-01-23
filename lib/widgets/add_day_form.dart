import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/experience_provider.dart';

class AddDayForm extends ConsumerStatefulWidget {
  final VoidCallback onSubmit;
  final int experienceIndex;

  const AddDayForm({
    super.key,
    required this.onSubmit,
    required this.experienceIndex,
  });

  @override
  ConsumerState<AddDayForm> createState() => _AddDayFormState();
}

enum RatingsLabels {
  tresMauvaise('Très mauvaise', 1),
  mauvaise('Mauvaise', 2),
  neutre('Neutre', 3),
  bonne('Bonne', 4),
  tresBonne('Très bonne', 5);

  final String label;
  final int value;

  const RatingsLabels(this.label, this.value);
}

class _AddDayFormState extends ConsumerState<AddDayForm> {
  final _formKey = GlobalKey<FormState>();

  RatingsLabels _dayRating = RatingsLabels.neutre;
  bool _contractRespected = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const labelWidth = 60.0;
    const borderColor = Color.fromRGBO(105, 82, 164, 1.0);
    const buttonColor = Color.fromRGBO(224, 221, 246, 1.0);

    return Form(
        key: _formKey,
        child: SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Note
              Row(
                children: [
                  const SizedBox(
                    width: labelWidth,
                    child: Text('Note',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<RatingsLabels>(
                      value: _dayRating,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: borderColor, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: borderColor),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        isDense: true,
                      ),
                      items: RatingsLabels.values.map((label) {
                        return DropdownMenuItem<RatingsLabels>(
                          value: label,
                          child: Text(label.label),
                        );
                      }).toList(),
                      onChanged: (RatingsLabels? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _dayRating = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Contrat
              Row(
                children: [
                  const SizedBox(
                    width: labelWidth,
                    child: Text('Contrat',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  Checkbox(
                    value: _contractRespected,
                    activeColor: borderColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _contractRespected = value ?? true;
                      });
                    },
                  ),
                  const Text('Respecté'),
                ],
              ),
              const SizedBox(height: 24),

              // Boutons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: borderColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Ajouter'),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  void title() {}

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ref.read(experienceProvider.notifier).rateExperienceDay(
            experienceIndex: widget.experienceIndex,
            rating: _dayRating.value,
            date: DateTime.now(),
            note: ' ',
            contractRespected: _contractRespected,
          );

      widget.onSubmit();
    }
  }
}
