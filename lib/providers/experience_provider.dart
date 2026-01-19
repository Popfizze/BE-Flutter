import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/experience.dart';
import '../models/day.dart';
import '../repositories/experience_repository.dart';

/// Provider for the ExperienceRepository
final experienceRepositoryProvider = Provider<ExperienceRepository>((ref) {
  return ExperienceRepository();
});

/// StateNotifier to manage experiences state
class ExperienceNotifier extends StateNotifier<List<Experience>> {
  final ExperienceRepository _repository;

  ExperienceNotifier(this._repository) : super([]) {
    loadExperiences();
  }

  /// Load experiences from storage
  Future<void> loadExperiences() async {
    try {
      final experiences = await _repository.loadExperiences();
      state = experiences;
    } catch (e) {
      // Handle error - could use error state or logging
      print('Error loading experiences: $e');
    }
  }

  /// Save current state to storage
  Future<void> _saveExperiences() async {
    try {
      await _repository.saveExperiences(state);
    } catch (e) {
      print('Error saving experiences: $e');
    }
  }

  /// Get experience count
  int get experienceCount => state.length;

  /// Add a new experience
  Future<void> addExperience({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    required String contract,
  }) async {
    final newExperience = Experience(
      title: title,
      startDate: startDate,
      endDate: endDate,
      contract: contract,
    );

    state = [...state, newExperience];
    await _saveExperiences();
  }

  /// Delete an experience at index
  Future<void> deleteExperience(int index) async {
    if (index < 0 || index >= state.length) return;

    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i]
    ];
    await _saveExperiences();
  }

  /// Update experience title
  Future<void> updateExperienceTitle(int index, String newTitle) async {
    if (index < 0 || index >= state.length) return;

    state[index].setTitle(newTitle);
    state = [...state]; // Trigger state update
    await _saveExperiences();
  }

  /// Update experience dates
  Future<void> updateExperienceDates(int index, DateTime startDate, DateTime endDate) async {
    if (index < 0 || index >= state.length) return;

    state[index].setStartDate(startDate);
    state[index].setEndDate(endDate);
    state = [...state];
    await _saveExperiences();
  }

  /// Update experience contract
  Future<void> updateExperienceContract(int index, String contract) async {
    if (index < 0 || index >= state.length) return;

    state[index].setContract(contract);
    state = [...state];
    await _saveExperiences();
  }

  /// Rate a day in an experience
  Future<void> rateExperienceDay({
    required int experienceIndex,
    required int rating,
    required DateTime date,
    required String note,
    required bool contractRespected,
  }) async {
    if (experienceIndex < 0 || experienceIndex >= state.length) return;

    state[experienceIndex].rateDay(rating, date, note, contractRespected);
    state = [...state];
    await _saveExperiences();
  }

  /// Update an existing day
  Future<void> updateDay({
    required int experienceIndex,
    required int dayIndex,
    required int rating,
    required String note,
    required bool contractRespected,
  }) async {
    if (experienceIndex < 0 || experienceIndex >= state.length) return;

    final experience = state[experienceIndex];
    if (dayIndex < 0 || dayIndex >= experience.days.length) return;

    experience.days[dayIndex] = experience.days[dayIndex].copyWith(
      rating: rating,
      note: note,
      contractRespected: contractRespected,
    );

    state = [...state];
    await _saveExperiences();
  }

  /// Delete a day from an experience
  Future<void> deleteDay(int experienceIndex, int dayIndex) async {
    if (experienceIndex < 0 || experienceIndex >= state.length) return;

    final experience = state[experienceIndex];
    if (dayIndex < 0 || dayIndex >= experience.days.length) return;

    experience.days.removeAt(dayIndex);
    state = [...state];
    await _saveExperiences();
  }

  /// Get experience at index
  Experience? getExperience(int index) {
    if (index < 0 || index >= state.length) return null;
    return state[index];
  }

  /// Get experience title
  String? getExperienceTitle(int index) {
    return getExperience(index)?.getTitle();
  }

  /// Get experience start date
  DateTime? getExperienceStartDate(int index) {
    return getExperience(index)?.getStartDate();
  }

  /// Get experience end date
  DateTime? getExperienceEndDate(int index) {
    return getExperience(index)?.getEndDate();
  }

  /// Get experience contract
  String? getExperienceContract(int index) {
    return getExperience(index)?.getContract();
  }

  /// Get experience duration in days
  int? getExperienceDuration(int index) {
    return getExperience(index)?.getDuration();
  }

  /// Get experience mean rating
  double? getExperienceMean(int index) {
    return getExperience(index)?.getMean();
  }

  /// Get day count for an experience
  int getDayCount(int experienceIndex) {
    return getExperience(experienceIndex)?.days.length ?? 0;
  }

  /// Get day at specific indices
  Day? getDay(int experienceIndex, int dayIndex) {
    final experience = getExperience(experienceIndex);
    if (experience == null) return null;
    if (dayIndex < 0 || dayIndex >= experience.days.length) return null;
    return experience.days[dayIndex];
  }

  /// Get day rating
  int? getDayRating(int experienceIndex, int dayIndex) {
    return getDay(experienceIndex, dayIndex)?.getRating();
  }

  /// Get day date
  DateTime? getDayDate(int experienceIndex, int dayIndex) {
    return getDay(experienceIndex, dayIndex)?.getDate();
  }

  /// Get day note
  String? getDayNote(int experienceIndex, int dayIndex) {
    return getDay(experienceIndex, dayIndex)?.getNote();
  }

  /// Check if day contract was respected
  bool? getDayContractRespected(int experienceIndex, int dayIndex) {
    return getDay(experienceIndex, dayIndex)?.isContractRespected();
  }

  /// Check if day is valid
  bool? isDayValid(int experienceIndex, int dayIndex) {
    return getDay(experienceIndex, dayIndex)?.isValid();
  }
}

/// Main provider for experience state
final experienceProvider = StateNotifierProvider<ExperienceNotifier, List<Experience>>((ref) {
  final repository = ref.watch(experienceRepositoryProvider);
  return ExperienceNotifier(repository);
});
