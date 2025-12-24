import 'package:equatable/equatable.dart';

enum DiseaseSeverity {
  low,
  medium,
  high;

  static DiseaseSeverity fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'low':
        return DiseaseSeverity.low;
      case 'medium':
        return DiseaseSeverity.medium;
      case 'high':
        return DiseaseSeverity.high;
      default:
        // Return a default value or throw an exception
        return DiseaseSeverity.low;
    }
  }

  String toJson() => name;
}

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

  factory DiagnosisEntity.fromJson(Map<String, dynamic> json) {
    return DiagnosisEntity(
      id: json['id'],
      cropType: json['cropType'],
      imagePath: json['imagePath'],
      isHealthy: json['isHealthy'],
      diseaseName: json['diseaseName'],
      confidence: (json['confidence'] as num).toDouble(),
      severity: json['severity'] != null
          ? DiseaseSeverity.fromString(json['severity'])
          : null,
      symptoms: List<String>.from(json['symptoms'] ?? []),
      rootCause: json['rootCause'],
      treatment: json['treatment'] != null
          ? TreatmentPlan.fromJson(json['treatment'])
          : null,
      preventionTips: List<String>.from(json['preventionTips'] ?? []),
      diagnosedAt: DateTime.parse(json['diagnosedAt']),
      isSynced: json['isSynced'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropType': cropType,
      'imagePath': imagePath,
      'isHealthy': isHealthy,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'severity': severity?.toJson(),
      'symptoms': symptoms,
      'rootCause': rootCause,
      'treatment': treatment?.toJson(),
      'preventionTips': preventionTips,
      'diagnosedAt': diagnosedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

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

  factory TreatmentPlan.fromJson(Map<String, dynamic> json) {
    return TreatmentPlan(
      chemical: json['chemical'] != null
          ? ChemicalTreatment.fromJson(json['chemical'])
          : null,
      organic: json['organic'] != null
          ? OrganicTreatment.fromJson(json['organic'])
          : null,
      culturalPractices:
          List<String>.from(json['culturalPractices'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chemical': chemical?.toJson(),
      'organic': organic?.toJson(),
      'culturalPractices': culturalPractices,
    };
  }
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

  factory ChemicalTreatment.fromJson(Map<String, dynamic> json) {
    return ChemicalTreatment(
      productName: json['productName'],
      dosage: json['dosage'],
      method: json['method'],
      timing: json['timing'],
      precautions: List<String>.from(json['precautions'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'dosage': dosage,
      'method': method,
      'timing': timing,
      'precautions': precautions,
    };
  }
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

  factory OrganicTreatment.fromJson(Map<String, dynamic> json) {
    return OrganicTreatment(
      name: json['name'],
      preparation: json['preparation'],
      application: json['application'],
      frequency: json['frequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'preparation': preparation,
      'application': application,
      'frequency': frequency,
    };
  }
}