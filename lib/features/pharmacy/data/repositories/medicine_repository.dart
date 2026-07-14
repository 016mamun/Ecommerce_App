import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medicine_model.dart';

abstract class MedicineRepository {
  Future<List<MedicineModel>> getAllMedicines();
  Future<MedicineModel?> getMedicineById(String id);
  Future<List<MedicineModel>> getMedicinesByCategory(MedicineCategory category);
  Future<List<MedicineModel>> getFeaturedMedicines();
  Future<List<MedicineModel>> searchMedicines(String query);
}

class MockMedicineRepository implements MedicineRepository {
  static final _allMedicines = <MedicineModel>[
    // ── OTC (Over-the-Counter) ──────────────────────────────────────────────
    MedicineModel(
      id: 'm001',
      brandName: 'Napa',
      genericName: 'Paracetamol',
      strength: '500mg',
      category: MedicineCategory.otc,
      imageUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80',
      price: 15.0,
      originalPrice: 18.0,
      discountPercent: 17,
      rating: 4.8,
      reviewCount: 12540,
      manufacturer: 'Beximco Pharmaceuticals',
      isRxRequired: false,
      isFeatured: true,
      indications: [
        'Relief of mild to moderate pain (headache, toothache, backache)',
        'Reduction of fever',
        'Relief of cold and flu symptoms',
        'Post-vaccination fever in children',
      ],
      sideEffects: [
        'Generally well-tolerated at recommended doses',
        'Rare: skin rash, allergic reactions',
        'Overdose can cause severe liver damage',
        'Nausea or stomach pain (uncommon)',
      ],
      warnings: [
        'Do not exceed 4g (8 tablets) in 24 hours',
        'Avoid alcohol — increases liver damage risk',
        'Check all other medications for hidden paracetamol content',
        'Use with caution in patients with liver or kidney disease',
      ],
      dosageGuidelines: [
        'Adults & children ≥12 years: 1–2 tablets every 4–6 hours',
        'Maximum: 8 tablets (4g) per 24 hours',
        'Children 6–12 years: half to one tablet every 4–6 hours',
        'Take with or without food',
      ],
      stock: 200,
    ),

    MedicineModel(
      id: 'm002',
      brandName: 'Histacin',
      genericName: 'Cetirizine HCl',
      strength: '10mg',
      category: MedicineCategory.otc,
      imageUrl:
          'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80',
      price: 25.0,
      originalPrice: 30.0,
      discountPercent: 17,
      rating: 4.6,
      reviewCount: 4320,
      manufacturer: 'Square Pharmaceuticals',
      isRxRequired: false,
      isFeatured: true,
      indications: [
        'Seasonal and perennial allergic rhinitis',
        'Chronic urticaria (hives)',
        'Allergic conjunctivitis',
        'Atopic dermatitis (eczema) — symptomatic relief',
      ],
      sideEffects: [
        'Drowsiness (less than older antihistamines)',
        'Dry mouth',
        'Headache',
        'Fatigue',
      ],
      warnings: [
        'Avoid driving or operating machinery if drowsy',
        'Use caution in elderly patients',
        'Reduce dose in renal impairment',
        'Not recommended under 2 years without medical advice',
      ],
      dosageGuidelines: [
        'Adults & children ≥6 years: 10mg once daily',
        'Children 2–6 years: 5mg once daily (consult a doctor)',
        'May be taken with or without food',
        'Take at the same time each day for best results',
      ],
      stock: 150,
    ),

    MedicineModel(
      id: 'm003',
      brandName: 'Antacid Plus',
      genericName: 'Aluminium Hydroxide + Magnesium Hydroxide',
      strength: '200mg/200mg per 5mL',
      category: MedicineCategory.otc,
      imageUrl:
          'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=600&q=80',
      price: 55.0,
      originalPrice: 65.0,
      discountPercent: 15,
      rating: 4.5,
      reviewCount: 3100,
      manufacturer: 'Renata Limited',
      isRxRequired: false,
      isFeatured: false,
      indications: [
        'Relief of heartburn, acid indigestion, and sour stomach',
        'Symptomatic relief of gastric ulcer pain',
        'Gastroesophageal reflux disease (GERD) — mild cases',
        'Stomach discomfort after meals',
      ],
      sideEffects: [
        'Constipation (aluminium component)',
        'Diarrhea (magnesium component)',
        'Nausea (uncommon)',
        'Changes in bowel habits',
      ],
      warnings: [
        'Do not use if on kidney dialysis without advice',
        'Separate from other medications by at least 2 hours',
        'Chronic use can lead to electrolyte imbalances',
        'Consult a doctor if symptoms persist over 2 weeks',
      ],
      dosageGuidelines: [
        'Adults: 10–20mL (2–4 teaspoons) 4 times daily',
        'Take 20–60 minutes after meals and at bedtime',
        'Shake well before use',
        'Do not exceed 80mL in 24 hours',
      ],
      stock: 80,
    ),

    MedicineModel(
      id: 'm004',
      brandName: 'C-Vit',
      genericName: 'Ascorbic Acid (Vitamin C)',
      strength: '500mg',
      category: MedicineCategory.otc,
      imageUrl:
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=600&q=80',
      price: 120.0,
      originalPrice: 150.0,
      discountPercent: 20,
      rating: 4.7,
      reviewCount: 8900,
      manufacturer: 'ACI Limited',
      isRxRequired: false,
      isFeatured: true,
      indications: [
        'Prevention and treatment of Vitamin C deficiency (Scurvy)',
        'Immune system support',
        'Antioxidant supplementation',
        'Aids iron absorption from plant-based foods',
      ],
      sideEffects: [
        'Nausea or stomach cramps at high doses',
        'Diarrhea',
        'Kidney stones with prolonged high-dose use (>1g/day)',
        'Generally safe at recommended doses',
      ],
      warnings: [
        'High doses (>2g/day) not recommended without medical supervision',
        'Patients with G6PD deficiency should use with caution',
        'May increase iron absorption — caution in hemochromatosis',
        'Chewable tablets may erode tooth enamel over time',
      ],
      dosageGuidelines: [
        'Adults: 500mg–1000mg daily as a supplement',
        'Treatment of scurvy: up to 1000mg daily',
        'Take with food to minimize stomach upset',
        'Separate from iron supplements by at least 2 hours for best absorption',
      ],
      stock: 300,
    ),

    // ── Prescription (Rx) ───────────────────────────────────────────────────
    MedicineModel(
      id: 'm005',
      brandName: 'Atorva',
      genericName: 'Atorvastatin Calcium',
      strength: '20mg',
      category: MedicineCategory.prescription,
      imageUrl:
          'https://images.unsplash.com/photo-1607619056574-7b8d3ee536b2?w=600&q=80',
      price: 85.0,
      originalPrice: 100.0,
      discountPercent: 15,
      rating: 4.7,
      reviewCount: 6500,
      manufacturer: 'Incepta Pharmaceuticals',
      isRxRequired: true,
      isFeatured: true,
      indications: [
        'Reduction of elevated total cholesterol and LDL',
        'Prevention of cardiovascular events in high-risk patients',
        'Treatment of mixed dyslipidaemia',
        'Familial hypercholesterolemia',
      ],
      sideEffects: [
        'Muscle pain or weakness (myalgia)',
        'Rhabdomyolysis (rare but serious)',
        'Elevated liver enzymes',
        'Headache, nausea, diarrhea',
      ],
      warnings: [
        'Contraindicated in pregnancy and breastfeeding',
        'Regular liver function tests recommended',
        'Report unexplained muscle pain immediately',
        'Avoid grapefruit juice — increases drug levels',
      ],
      dosageGuidelines: [
        'Starting dose: 10–20mg once daily',
        'Maintenance: 10–80mg once daily based on response',
        'May be taken at any time of day, with or without food',
        'Doses above 40mg require careful monitoring',
      ],
      stock: 60,
    ),

    MedicineModel(
      id: 'm006',
      brandName: 'Glucomet',
      genericName: 'Metformin HCl',
      strength: '500mg',
      category: MedicineCategory.prescription,
      imageUrl:
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=600&q=80',
      price: 50.0,
      originalPrice: 60.0,
      discountPercent: 17,
      rating: 4.6,
      reviewCount: 9800,
      manufacturer: 'Square Pharmaceuticals',
      isRxRequired: true,
      isFeatured: true,
      indications: [
        'First-line treatment for type 2 diabetes mellitus',
        'Polycystic ovary syndrome (PCOS)',
        'Prevention of type 2 diabetes in high-risk individuals',
        'Weight management in insulin-resistant conditions',
      ],
      sideEffects: [
        'GI upset: nausea, vomiting, diarrhea (most common, usually transient)',
        'Metallic taste',
        'Lactic acidosis (rare but serious)',
        'Vitamin B12 deficiency with long-term use',
      ],
      warnings: [
        'Contraindicated with eGFR <30 mL/min (renal failure)',
        'Stop 48 hours before contrast procedures',
        'Monitor renal function regularly',
        'Avoid excessive alcohol use',
      ],
      dosageGuidelines: [
        'Starting dose: 500mg twice daily with meals',
        'Titrate slowly to minimize GI side effects',
        'Usual maintenance: 1500–2000mg per day in divided doses',
        'Maximum dose: 3000mg/day',
      ],
      stock: 100,
    ),

    MedicineModel(
      id: 'm007',
      brandName: 'Amoxil',
      genericName: 'Amoxicillin',
      strength: '500mg',
      category: MedicineCategory.prescription,
      imageUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&q=80',
      price: 65.0,
      originalPrice: 75.0,
      discountPercent: 13,
      rating: 4.5,
      reviewCount: 7200,
      manufacturer: 'Beximco Pharmaceuticals',
      isRxRequired: true,
      isFeatured: false,
      indications: [
        'Respiratory tract infections (pneumonia, bronchitis)',
        'Ear, nose, and throat infections (otitis media, tonsillitis)',
        'Urinary tract infections',
        'Skin and soft tissue infections',
        'H. pylori eradication (in combination)',
      ],
      sideEffects: [
        'Diarrhea (most common)',
        'Nausea, vomiting',
        'Skin rash',
        'Anaphylaxis (rare, but potentially life-threatening)',
      ],
      warnings: [
        'Contraindicated in penicillin allergy',
        'Complete the full course even if feeling better',
        'Can affect oral contraceptive efficacy',
        'Discontinue at first sign of allergic reaction',
      ],
      dosageGuidelines: [
        'Adults: 250–500mg three times daily (every 8 hours)',
        'Severe infections: 500mg–1g three times daily',
        'Duration: typically 5–10 days',
        'Take at evenly spaced intervals; may be taken with food',
      ],
      stock: 75,
    ),

    MedicineModel(
      id: 'm008',
      brandName: 'Losartan-H',
      genericName: 'Losartan Potassium + Hydrochlorothiazide',
      strength: '50mg/12.5mg',
      category: MedicineCategory.prescription,
      imageUrl:
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=600&q=80',
      price: 95.0,
      originalPrice: 110.0,
      discountPercent: 14,
      rating: 4.6,
      reviewCount: 4100,
      manufacturer: 'ACI Limited',
      isRxRequired: true,
      isFeatured: false,
      indications: [
        'Treatment of hypertension (high blood pressure)',
        'Reduction of risk of stroke in hypertensive patients with LVH',
        'Diabetic nephropathy (kidney protection in type 2 diabetes)',
      ],
      sideEffects: [
        'Dizziness, especially on standing up',
        'Elevated potassium levels (hyperkalemia)',
        'Fatigue',
        'Cough (less common than ACE inhibitors)',
      ],
      warnings: [
        'Contraindicated in pregnancy (all trimesters)',
        'Monitor potassium and kidney function regularly',
        'Avoid NSAIDs — can reduce effectiveness and worsen kidneys',
        'Use caution in renal artery stenosis',
      ],
      dosageGuidelines: [
        'Adults: One tablet (50/12.5mg) once daily',
        'May be increased to 100/25mg once daily if needed',
        'Take at the same time each day, with or without food',
        'Blood pressure should be monitored regularly',
      ],
      stock: 45,
    ),

    MedicineModel(
      id: 'm009',
      brandName: 'Esomac',
      genericName: 'Esomeprazole Magnesium',
      strength: '20mg',
      category: MedicineCategory.prescription,
      imageUrl:
          'https://images.unsplash.com/photo-1550572017-edd951b55104?w=600&q=80',
      price: 110.0,
      originalPrice: 130.0,
      discountPercent: 15,
      rating: 4.7,
      reviewCount: 5600,
      manufacturer: 'Renata Limited',
      isRxRequired: true,
      isFeatured: true,
      indications: [
        'Gastroesophageal reflux disease (GERD)',
        'Peptic ulcer disease (gastric and duodenal)',
        'H. pylori eradication (in combination therapy)',
        'Zollinger-Ellison syndrome',
      ],
      sideEffects: [
        'Headache',
        'Diarrhea, constipation, nausea',
        'Magnesium deficiency with long-term use',
        'Increased risk of C. difficile infection',
      ],
      warnings: [
        'Not for immediate heartburn relief (not antacid)',
        'Long-term use may reduce calcium/magnesium absorption',
        'Monitor magnesium levels in long-term use',
        'May mask symptoms of gastric cancer',
      ],
      dosageGuidelines: [
        'GERD: 20–40mg once daily for 4–8 weeks',
        'Take 30–60 minutes before a meal',
        'Swallow whole; do not crush or chew',
        'Maintenance: 20mg daily as needed',
      ],
      stock: 90,
    ),

    // ── Herbal ──────────────────────────────────────────────────────────────
    MedicineModel(
      id: 'm010',
      brandName: 'NimBark',
      genericName: 'Azadirachta indica (Neem) Extract',
      strength: '250mg',
      category: MedicineCategory.herbal,
      imageUrl:
          'https://images.unsplash.com/photo-1515023115689-589c33041d3c?w=600&q=80',
      price: 180.0,
      originalPrice: 220.0,
      discountPercent: 18,
      rating: 4.3,
      reviewCount: 2100,
      manufacturer: 'Hamdard Laboratories',
      isRxRequired: false,
      isFeatured: false,
      indications: [
        'Support for blood sugar management (adjunct)',
        'Antibacterial and antifungal properties',
        'Skin health support (acne, eczema)',
        'Immune system stimulation',
      ],
      sideEffects: [
        'Nausea at high doses',
        'Potential for liver toxicity with very high doses',
        'Avoid during pregnancy — may cause miscarriage',
        'May lower blood sugar excessively if combined with diabetes drugs',
      ],
      warnings: [
        'Not recommended during pregnancy or breastfeeding',
        'Consult a doctor before use if diabetic',
        'Avoid giving to infants or young children',
        'Not a substitute for prescribed medicines',
      ],
      dosageGuidelines: [
        'Adults: 250–500mg twice daily with meals',
        'Best taken with warm water',
        'Course: 4–8 weeks, then reassess',
        'Consult a naturopath or physician for personalized dosing',
      ],
      stock: 60,
    ),

    MedicineModel(
      id: 'm011',
      brandName: 'Curcumin Max',
      genericName: 'Curcuma longa (Turmeric) Extract',
      strength: '500mg (95% Curcuminoids)',
      category: MedicineCategory.herbal,
      imageUrl:
          'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=600&q=80',
      price: 250.0,
      originalPrice: 300.0,
      discountPercent: 17,
      rating: 4.5,
      reviewCount: 3400,
      manufacturer: 'Aristopharma',
      isRxRequired: false,
      isFeatured: true,
      indications: [
        'Anti-inflammatory support (joint pain, arthritis)',
        'Antioxidant supplementation',
        'Digestive health support',
        'Support for brain health and cognitive function',
      ],
      sideEffects: [
        'GI discomfort at high doses',
        'Nausea, diarrhea',
        'May cause gallbladder contractions — caution with gallstones',
        'Can slow blood clotting',
      ],
      warnings: [
        'Avoid high doses before surgery (increases bleeding risk)',
        'Avoid if you have gallbladder problems',
        'May interact with blood thinners (warfarin, aspirin)',
        'Consult doctor if pregnant or breastfeeding',
      ],
      dosageGuidelines: [
        'Adults: 500mg 1–2 times daily with meals',
        'Best absorbed with black pepper (piperine) or fat',
        'For arthritis: 500mg three times daily may be used',
        'Consistent daily use recommended for best results',
      ],
      stock: 110,
    ),

    // ── Personal Care ────────────────────────────────────────────────────────
    MedicineModel(
      id: 'm012',
      brandName: 'Savlon Cream',
      genericName: 'Chlorhexidine Gluconate + Cetrimide',
      strength: '0.15% + 0.5%',
      category: MedicineCategory.personalCare,
      imageUrl:
          'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=600&q=80',
      price: 75.0,
      originalPrice: 85.0,
      discountPercent: 12,
      rating: 4.6,
      reviewCount: 5200,
      manufacturer: 'Reckitt Benckiser',
      isRxRequired: false,
      isFeatured: false,
      indications: [
        'Antiseptic for minor cuts, wounds, and abrasions',
        'Skin disinfection before injections',
        'Treatment of minor burns',
        'Prevention of wound infection',
      ],
      sideEffects: [
        'Skin irritation or redness (uncommon)',
        'Allergic contact dermatitis (rare)',
        'Bleaching of fabric on contact',
      ],
      warnings: [
        'For external use only',
        'Do not use in ears, eyes, or mouth',
        'Avoid large wound areas without medical advice',
        'Keep out of reach of children',
      ],
      dosageGuidelines: [
        'Apply a thin layer to cleaned wound 2–3 times daily',
        'Cover with a sterile dressing if needed',
        'Wash hands before and after application',
        'Discontinue if rash or increased irritation develops',
      ],
      stock: 180,
    ),

    MedicineModel(
      id: 'm013',
      brandName: 'UV Shield SPF 50+',
      genericName: 'Zinc Oxide + Titanium Dioxide',
      strength: 'SPF 50+ PA+++',
      category: MedicineCategory.personalCare,
      imageUrl:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&q=80',
      price: 320.0,
      originalPrice: 380.0,
      discountPercent: 16,
      rating: 4.7,
      reviewCount: 4800,
      manufacturer: 'Kosei Pharmaceuticals',
      isRxRequired: false,
      isFeatured: true,
      indications: [
        'Protection against UVA and UVB radiation',
        'Prevention of sunburn',
        'Reduction of risk of skin cancer with long-term use',
        'Anti-aging — prevents photoaging',
      ],
      sideEffects: [
        'White cast on dark skin tones (physical sunscreens)',
        'May cause breakouts in acne-prone skin',
        'Rare allergic reactions',
      ],
      warnings: [
        'Reapply every 2 hours when outdoors',
        'Apply 20–30 minutes before sun exposure',
        'Not a substitute for protective clothing',
        'Keep away from eyes; rinse with water if contact occurs',
      ],
      dosageGuidelines: [
        'Apply generously to all exposed skin areas',
        'Use approximately one teaspoon for the face',
        'Reapply after sweating, swimming, or towel drying',
        'Daily use even on cloudy days is recommended',
      ],
      stock: 90,
    ),

    MedicineModel(
      id: 'm014',
      brandName: 'Omepral',
      genericName: 'Omeprazole',
      strength: '20mg',
      category: MedicineCategory.prescription,
      imageUrl:
          'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=600&q=80',
      price: 72.0,
      originalPrice: 85.0,
      discountPercent: 15,
      rating: 4.5,
      reviewCount: 7800,
      manufacturer: 'Drug International Ltd',
      isRxRequired: true,
      isFeatured: false,
      indications: [
        'Peptic ulcer disease (gastric and duodenal ulcers)',
        'GERD (gastroesophageal reflux disease)',
        'Zollinger-Ellison syndrome',
        'H. pylori eradication as part of triple therapy',
      ],
      sideEffects: [
        'Headache',
        'Diarrhea, constipation',
        'Vitamin B12 deficiency (long-term use)',
        'Hypomagnesemia with prolonged use',
      ],
      warnings: [
        'May mask symptoms of gastric cancer',
        'Not for immediate relief of heartburn',
        'Long-term use: monitor magnesium, B12 levels',
        'Take before meals for best effect',
      ],
      dosageGuidelines: [
        'Adults: 20mg once daily before breakfast',
        'Duodenal ulcer: 20mg daily for 4 weeks',
        'GERD maintenance: 10–20mg daily',
        'H. pylori eradication: 20mg twice daily (with antibiotics)',
      ],
      stock: 120,
    ),

    MedicineModel(
      id: 'm015',
      brandName: 'Ginkgo Plus',
      genericName: 'Ginkgo biloba Leaf Extract',
      strength: '120mg (24% Flavonol Glycosides)',
      category: MedicineCategory.herbal,
      imageUrl:
          'https://images.unsplash.com/photo-1515023115689-589c33041d3c?w=600&q=80',
      price: 290.0,
      originalPrice: 350.0,
      discountPercent: 17,
      rating: 4.4,
      reviewCount: 1870,
      manufacturer: 'Hamdard Laboratories',
      isRxRequired: false,
      isFeatured: false,
      indications: [
        'Age-associated cognitive decline',
        'Dementia and Alzheimer\'s disease (adjunct)',
        'Peripheral vascular disease (intermittent claudication)',
        'Tinnitus (ringing in the ears)',
      ],
      sideEffects: [
        'Headache, dizziness',
        'GI disturbance',
        'Increased bleeding risk',
        'Allergic skin reactions (rare)',
      ],
      warnings: [
        'Stop use 2 weeks before surgery (antiplatelet effect)',
        'Do not combine with blood thinners without medical supervision',
        'Not recommended during pregnancy',
        'Avoid raw ginkgo seeds — they are toxic',
      ],
      dosageGuidelines: [
        'Adults: 120mg daily in 2–3 divided doses',
        'Take with meals to reduce GI side effects',
        'Allow 4–6 weeks for noticeable effect',
        'Standardized extract (24% flavonol glycosides) is preferred',
      ],
      stock: 55,
    ),

    MedicineModel(
      id: 'm016',
      brandName: 'Salbutam',
      genericName: 'Salbutamol (Albuterol)',
      strength: '100mcg/dose',
      category: MedicineCategory.prescription,
      imageUrl:
          'https://images.unsplash.com/photo-1576091160550-2173dba999ef?w=600&q=80',
      price: 180.0,
      originalPrice: 210.0,
      discountPercent: 14,
      rating: 4.8,
      reviewCount: 6200,
      manufacturer: 'GlaxoSmithKline Bangladesh',
      isRxRequired: true,
      isFeatured: true,
      indications: [
        'Relief of bronchospasm in asthma',
        'Chronic obstructive pulmonary disease (COPD)',
        'Exercise-induced bronchospasm (prevention)',
        'Acute asthma attacks (rescue inhaler)',
      ],
      sideEffects: [
        'Tremor (especially hands)',
        'Palpitations, rapid heartbeat',
        'Headache',
        'Hypokalemia at high doses',
      ],
      warnings: [
        'Not for regular daily use (indicates poor asthma control)',
        'Using >2 canisters/month suggests uncontrolled asthma',
        'Monitor cardiac status in patients with heart disease',
        'Paradoxical bronchospasm may occur — stop use and seek help',
      ],
      dosageGuidelines: [
        'Adults & children ≥4 years: 1–2 puffs as needed',
        'Prevention: 2 puffs 15 minutes before exercise',
        'Maximum: 8 puffs per 24 hours',
        'Shake well before use; prime before first use',
      ],
      stock: 30,
    ),
  ];

  @override
  Future<List<MedicineModel>> getAllMedicines() async {
    await Future.delayed(const Duration(milliseconds: 700));
    return _allMedicines;
  }

  @override
  Future<MedicineModel?> getMedicineById(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      return _allMedicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<MedicineModel>> getMedicinesByCategory(
      MedicineCategory category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allMedicines.where((m) => m.category == category).toList();
  }

  @override
  Future<List<MedicineModel>> getFeaturedMedicines() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _allMedicines.where((m) => m.isFeatured).toList();
  }

  @override
  Future<List<MedicineModel>> searchMedicines(String query) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final q = query.toLowerCase();
    return _allMedicines
        .where((m) =>
            m.brandName.toLowerCase().contains(q) ||
            m.genericName.toLowerCase().contains(q) ||
            m.manufacturer.toLowerCase().contains(q) ||
            m.category.label.toLowerCase().contains(q))
        .toList();
  }
}

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  return MockMedicineRepository();
});
