import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/experience_provider.dart';

class ExperienceDetailPage extends ConsumerStatefulWidget {
  final int experienceIndex;

  const ExperienceDetailPage({
    super.key,
    required this.experienceIndex,
  });

  @override
  ConsumerState<ExperienceDetailPage> createState() =>
      _ExperienceDetailPageState();
}

class _ExperienceDetailPageState extends ConsumerState<ExperienceDetailPage> {
  DateTime _selectedDate = DateTime.now();
  int _selectedRating = 4;
  bool _contractRespected = false;

  final List<String> _ratingLabels = [
    'Très mauvaise (1)',
    'Mauvaise (2)',
    'Neutre (3)',
    'Bonne (4)',
    'Très bonne (5)',
  ];

  @override
  Widget build(BuildContext context) {
    final experience =
        ref.read(experienceProvider.notifier).getExperience(widget.experienceIndex);

    if (experience == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erreur'),
        ),
        body: const Center(
          child: Text('Expérience non trouvée'),
        ),
      );
    }

    final dateFormat = DateFormat('dd/MM');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              experience.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Du ${dateFormat.format(experience.startDate)} au ${dateFormat.format(experience.endDate)}',
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              'Contrat: ${experience.contract}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditTitleDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showEditDatesDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Zone graphique (placeholder)
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

            // Formulaire de notation
            const Text(
              'Notez votre journée',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Sélection de la date
            ListTile(
              title: const Text('Date'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),

            const SizedBox(height: 8),

            // Sélection de la note
            DropdownButtonFormField<int>(
              initialValue: _selectedRating,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
              items: List.generate(
                5,
                (index) => DropdownMenuItem(
                  value: index + 1,
                  child: Text(_ratingLabels[index]),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedRating = value ?? 4;
                });
              },
            ),

            const SizedBox(height: 8),

            // Checkbox contrat respecté
            CheckboxListTile(
              title: const Text('Contrat respecté'),
              value: _contractRespected,
              onChanged: (value) {
                setState(() {
                  _contractRespected = value ?? false;
                });
              },
            ),

            const SizedBox(height: 16),

            // Bouton Noter
            ElevatedButton(
              onPressed: () => _rateDay(),
              child: const Text('Noter'),
            ),

            const SizedBox(height: 24),

            // Bouton Terminer l'expérience
            OutlinedButton(
              onPressed: () => _showEndExperienceDialog(context),
              child: const Text('Terminer l\'expérience'),
            ),
          ],
        ),
      ),
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
      text: ref.read(experienceProvider.notifier).getExperienceTitle(widget.experienceIndex),
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
                  .updateExperienceTitle(widget.experienceIndex, controller.text);
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
    final experience =
        ref.read(experienceProvider.notifier).getExperience(widget.experienceIndex);
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
                ref
                    .read(experienceProvider.notifier)
                    .updateExperienceDates(widget.experienceIndex, startDate, endDate);
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
