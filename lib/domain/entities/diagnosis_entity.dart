import 'package:equatable/equatable.dart';

enum DiseaseSeverity { low, medium, high }

class DiagnosisEntity extends Equatable {
  final String id;
  final String cropType;
  final String imagePath;
  final String? imageBase64;
  final bool isHealthy;
  final String? diseaseName;
  final double confidence;
  final DiseaseSeverity? severity;
  final List<String> symptoms;
  final String? rootCause;
  final TreatmentPlan? treatment;
  final List<String> preventionTips;
  final DateTime diagnosedAt;
  final bool isSynced;

  const DiagnosisEntity({
    required this.id,
    required this.cropType,
    required this.imagePath,
    this.imageBase64,
    required this.isHealthy,
    this.diseaseName,
    required this.confidence,
    this.severity,
    this.symptoms = const [],
    this.rootCause,
    this.treatment,
    this.preventionTips = const [],
    required this.diagnosedAt,
    this.isSynced = false,
  });

  @override
  List<Object?> get props => [
        id,
        cropType,
        imagePath,
        isHealthy,
        diseaseName,
        confidence,
        severity,
        symptoms,
        rootCause,
        treatment,
        preventionTips,
        diagnosedAt,
        isSynced,
      ];

  DiagnosisEntity copyWith({
    String? id,
    String? cropType,
    String? imagePath,
    String? imageBase64,
    bool? isHealthy,
    String? diseaseName,
    double? confidence,
    DiseaseSeverity? severity,
    List<String>? symptoms,
    String? rootCause,
    TreatmentPlan? treatment,
    List<String>? preventionTips,
    DateTime? diagnosedAt,
    bool? isSynced,
  }) {
    return DiagnosisEntity(
      id: id ?? this.id,
      cropType: cropType ?? this.cropType,
      imagePath: imagePath ?? this.imagePath,
      imageBase64: imageBase64 ?? this.imageBase64,
      isHealthy: isHealthy ?? this.isHealthy,
      diseaseName: diseaseName ?? this.diseaseName,
      confidence: confidence ?? this.confidence,
      severity: severity ?? this.severity,
      symptoms: symptoms ?? this.symptoms,
      rootCause: rootCause ?? this.rootCause,
      treatment: treatment ?? this.treatment,
      preventionTips: preventionTips ?? this.preventionTips,
      diagnosedAt: diagnosedAt ?? this.diagnosedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

class TreatmentPlan extends Equatable {
  final ChemicalTreatment? chemical;
  final OrganicTreatment? organic;
  final List<String> culturalPractices;

  const TreatmentPlan({
    this.chemical,
    this.organic,
    this.culturalPractices = const [],
  });

  @override
  List<Object?> get props => [chemical, organic, culturalPractices];
}

class ChemicalTreatment extends Equatable {
  final String productName;
  final String dosage;
  final String method;
  final String timing;
  final List<String> precautions;

  const ChemicalTreatment({
    required this.productName,
    required this.dosage,
    required this.method,
    required this.timing,
    this.precautions = const [],
  });

  @override
  List<Object?> get props => [productName, dosage, method, timing, precautions];
}

class OrganicTreatment extends Equatable {
  final String name;
  final String preparation;
  final String application;
  final String frequency;

  const OrganicTreatment({
    required this.name,
    required this.preparation,
    required this.application,
    required this.frequency,
  });

  @override
  List<Object?> get props => [name, preparation, application, frequency];
}
