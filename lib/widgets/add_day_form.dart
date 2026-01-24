import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/ratings_labels.dart';
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

class _AddDayFormState extends ConsumerState<AddDayForm> {
  final _formKey = GlobalKey<FormState>();

  RatingsLabels _dayRating = RatingsLabels.neutre;
  bool _contractRespected = false;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    // Initialisation de la date par défaut
    // On doit le faire dans un post-frame callback ou ici en lisant directement le provider
    // Attention: initState ne peut pas lire le provider avec watch, mais read est ok dans initState si on ne s'abonne pas, 
    // ou mieux: on initialise à now() et on corrige dans didChangeDependencies si besoin, 
    // mais ici on va faire simple: initialiser à now(). La validation des bornes se fera à l'ouverture du picker.
    _selectedDate = DateTime.now();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ajustement initial pour être sûr d'être dans les bornes
    final experiences = ref.read(experienceProvider);
    if (widget.experienceIndex >= 0 && widget.experienceIndex < experiences.length) {
      final experience = experiences[widget.experienceIndex];
      if (_selectedDate.isBefore(experience.startDate)) {
        _selectedDate = experience.startDate;
      } else if (_selectedDate.isAfter(experience.endDate)) {
        _selectedDate = experience.endDate;
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final experiences = ref.read(experienceProvider);
    if (widget.experienceIndex < 0 || widget.experienceIndex >= experiences.length) return;
    
    final experience = experiences[widget.experienceIndex];
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: experience.startDate,
      lastDate: experience.endDate,
      locale: const Locale("fr", "FR"), // Optionnel: force français si config ok
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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
               // Date Selection
              Row(
                children: [
                  const SizedBox(
                    width: labelWidth,
                    child: Text('Date',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today, 
                                size: 20, color: borderColor),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

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
                      initialValue: _dayRating,
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        ref.read(experienceProvider.notifier).rateExperienceDay(
              experienceIndex: widget.experienceIndex,
              rating: _dayRating.value,
              date: _selectedDate,
              note: ' ',
              contractRespected: _contractRespected,
            );

        widget.onSubmit();
      } catch (e) {
        // Afficher l'erreur si la date existe déjà
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
