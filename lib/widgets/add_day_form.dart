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
  tresMauvaise('Trash', 1),
  mauvaise('bad', 2),
  neutre('okay', 3),
  bonne('good', 4),
  tresBonne('really good', 5);

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
    return Form(
        key: _formKey,
        child: Row(children: [
          SizedBox(
            width: 450,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Important pour le Dialog
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Note'),
                    SegmentedButton<RatingsLabels>(
                      segments: RatingsLabels.values.map((label) {
                        return ButtonSegment<RatingsLabels>(
                            value: label, label: Text(label.label));
                      }).toList(),
                      selected: {_dayRating},
                      onSelectionChanged: (selected) {
                        setState(() {
                          _dayRating = selected.first;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CheckboxListTile(
                    title: const Text('Contrat respecté'),
                    value: _contractRespected,
                    onChanged: (value) {
                      setState(() {
                        _contractRespected = value ?? true;
                      });
                    }),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
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
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Ajouter'),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const Expanded(child: Text("")),
        ]));
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
