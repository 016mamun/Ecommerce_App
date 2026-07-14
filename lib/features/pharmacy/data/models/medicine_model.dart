import 'package:equatable/equatable.dart';

/// Medicine categories available in Pharmacy Mode.
enum MedicineCategory { otc, prescription, herbal, personalCare }

extension MedicineCategoryExt on MedicineCategory {
  String get label {
    switch (this) {
      case MedicineCategory.otc:
        return 'OTC';
      case MedicineCategory.prescription:
        return 'Prescription';
      case MedicineCategory.herbal:
        return 'Herbal';
      case MedicineCategory.personalCare:
        return 'Personal Care';
    }
  }

  String get emoji {
    switch (this) {
      case MedicineCategory.otc:
        return '💊';
      case MedicineCategory.prescription:
        return '🏥';
      case MedicineCategory.herbal:
        return '🌿';
      case MedicineCategory.personalCare:
        return '🧴';
    }
  }
}

/// Represents a single medicine/healthcare product in Pharmacy Mode.
class MedicineModel extends Equatable {
  final String id;

  /// Brand/trade name displayed prominently.
  final String brandName;

  /// International non-proprietary (generic) name.
  final String genericName;

  /// Dosage strength, e.g. "500mg", "10mg/5mL".
  final String strength;

  final MedicineCategory category;

  final String imageUrl;
  final double price;
  final double originalPrice;
  final int discountPercent;

  final double rating;
  final int reviewCount;
  final String manufacturer;

  /// If true, the user must upload a prescription before purchase.
  final bool isRxRequired;

  /// Clinical uses / therapeutic indications.
  final List<String> indications;

  /// Known adverse effects.
  final List<String> sideEffects;

  /// Cautions, contraindications, special warnings.
  final List<String> warnings;

  /// Standard dosage information.
  final List<String> dosageGuidelines;

  final int stock;
  final bool isAvailable;
  final bool isFeatured;

  const MedicineModel({
    required this.id,
    required this.brandName,
    required this.genericName,
    required this.strength,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.manufacturer,
    this.isRxRequired = false,
    this.indications = const [],
    this.sideEffects = const [],
    this.warnings = const [],
    this.dosageGuidelines = const [],
    this.stock = 50,
    this.isAvailable = true,
    this.isFeatured = false,
  });

  bool get isOutOfStock => stock == 0;
  bool get isLowStock => stock > 0 && stock <= 5;
  bool get hasDiscount => discountPercent > 0;

  @override
  List<Object?> get props => [id];
}
