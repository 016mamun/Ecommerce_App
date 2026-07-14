import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/medicine_model.dart';
import '../../data/repositories/medicine_repository.dart';

// ── Selected Category Filter ──────────────────────────────────────────────────
final selectedMedicineCategoryProvider =
    StateProvider<MedicineCategory?>((ref) => null);

// ── Search ────────────────────────────────────────────────────────────────────
final medicineSearchQueryProvider = StateProvider<String>((ref) => '');

// ── All Medicines ─────────────────────────────────────────────────────────────
final allMedicinesProvider =
    FutureProvider<List<MedicineModel>>((ref) async {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.getAllMedicines();
});

// ── Featured Medicines ────────────────────────────────────────────────────────
final featuredMedicinesProvider =
    FutureProvider<List<MedicineModel>>((ref) async {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.getFeaturedMedicines();
});

// ── Medicine Detail ───────────────────────────────────────────────────────────
final medicineDetailProvider =
    FutureProvider.family<MedicineModel?, String>((ref, id) async {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.getMedicineById(id);
});

// ── Medicines by Category ─────────────────────────────────────────────────────
final medicinesByCategoryProvider =
    FutureProvider.family<List<MedicineModel>, MedicineCategory>(
        (ref, category) async {
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.getMedicinesByCategory(category);
});

// ── Search Results ────────────────────────────────────────────────────────────
final medicineSearchResultsProvider =
    FutureProvider<List<MedicineModel>>((ref) async {
  final query = ref.watch(medicineSearchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.watch(medicineRepositoryProvider);
  return repo.searchMedicines(query);
});

// ── Filtered / Displayed Medicines ───────────────────────────────────────────
/// Combines category filter and search query into a single provider.
final filteredMedicinesProvider =
    FutureProvider<List<MedicineModel>>((ref) async {
  final category = ref.watch(selectedMedicineCategoryProvider);
  final query = ref.watch(medicineSearchQueryProvider);
  final repo = ref.watch(medicineRepositoryProvider);

  List<MedicineModel> medicines;
  if (category != null) {
    medicines = await repo.getMedicinesByCategory(category);
  } else {
    medicines = await repo.getAllMedicines();
  }

  if (query.isNotEmpty) {
    final q = query.toLowerCase();
    medicines = medicines
        .where((m) =>
            m.brandName.toLowerCase().contains(q) ||
            m.genericName.toLowerCase().contains(q))
        .toList();
  }

  return medicines;
});
