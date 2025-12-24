import '../../domain/entities/diagnosis_entity.dart';

class DiagnosisModel extends DiagnosisEntity {
  const DiagnosisModel({
    required super.id,
    required super.cropType,
    required super.imagePath,
    super.imageBase64,
    required super.isHealthy,
    super.diseaseName,
    required super.confidence,
    super.severity,
    super.symptoms = const [],
    super.rootCause,
    super.treatment,
    super.preventionTips = const [],
    required super.diagnosedAt,
    super.isSynced = false,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      id: json['id'] as String,
      cropType: json['cropType'] as String,
      imagePath: json['imagePath'] as String,
      imageBase64: json['imageBase64'] as String?,
      isHealthy: json['isHealthy'] as bool,
      diseaseName: json['diseaseName'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      severity: json['severity'] != null
          ? _parseSeverity(json['severity'] as String)
          : null,
      symptoms: json['symptoms'] != null
          ? List<String>.from(json['symptoms'])
          : const [],
      rootCause: json['rootCause'] as String?,
      treatment: json['treatment'] != null
          ? TreatmentPlanModel.fromJson(json['treatment'])
          : null,
      preventionTips: json['preventionTips'] != null
          ? List<String>.from(json['preventionTips'])
          : const [],
      diagnosedAt: DateTime.parse(json['diagnosedAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cropType': cropType,
      'imagePath': imagePath,
      'imageBase64': imageBase64,
      'isHealthy': isHealthy,
      'diseaseName': diseaseName,
      'confidence': confidence,
      'severity': severity?.name,
      'symptoms': symptoms,
      'rootCause': rootCause,
      'treatment': treatment != null
          ? TreatmentPlanModel.fromEntity(treatment!).toJson()
          : null,
      'preventionTips': preventionTips,
      'diagnosedAt': diagnosedAt.toIso8601String(),
      'isSynced': isSynced,
    };
  }

  factory DiagnosisModel.fromEntity(DiagnosisEntity entity) {
    return DiagnosisModel(
      id: entity.id,
      cropType: entity.cropType,
      imagePath: entity.imagePath,
      imageBase64: entity.imageBase64,
      isHealthy: entity.isHealthy,
      diseaseName: entity.diseaseName,
      confidence: entity.confidence,
      severity: entity.severity,
      symptoms: entity.symptoms,
      rootCause: entity.rootCause,
      treatment: entity.treatment,
      preventionTips: entity.preventionTips,
      diagnosedAt: entity.diagnosedAt,
      isSynced: entity.isSynced,
    );
  }

  static DiseaseSeverity _parseSeverity(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return DiseaseSeverity.low;
      case 'medium':
        return DiseaseSeverity.medium;
      case 'high':
        return DiseaseSeverity.high;
      default:
        return DiseaseSeverity.low;
    }
  }
}

class TreatmentPlanModel extends TreatmentPlan {
  const TreatmentPlanModel({
    super.chemical,
    super.organic,
    super.culturalPractices = const [],
  });

  factory TreatmentPlanModel.fromJson(Map<String, dynamic> json) {
    return TreatmentPlanModel(
      chemical: json['chemical'] != null
          ? ChemicalTreatmentModel.fromJson(json['chemical'])
          : null,
      organic: json['organic'] != null
          ? OrganicTreatmentModel.fromJson(json['organic'])
          : null,
      culturalPractices: json['culturalPractices'] != null
          ? List<String>.from(json['culturalPractices'])
          : const [],
    );
  }

  factory TreatmentPlanModel.fromEntity(TreatmentPlan entity) {
    return TreatmentPlanModel(
      chemical: entity.chemical,
      organic: entity.organic,
      culturalPractices: entity.culturalPractices,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'chemical': chemical != null
          ? ChemicalTreatmentModel.fromEntity(chemical!).toJson()
          : null,
      'organic': organic != null
          ? OrganicTreatmentModel.fromEntity(organic!).toJson()
          : null,
      'culturalPractices': culturalPractices,
    };
  }
}

class ChemicalTreatmentModel extends ChemicalTreatment {
  const ChemicalTreatmentModel({
    required super.productName,
    required super.dosage,
    required super.method,
    required super.timing,
    super.precautions = const [],
  });

  factory ChemicalTreatmentModel.fromJson(Map<String, dynamic> json) {
    return ChemicalTreatmentModel(
      productName: json['productName'] as String,
      dosage: json['dosage'] as String,
      method: json['method'] as String,
      timing: json['timing'] as String,
      precautions: json['precautions'] != null
          ? List<String>.from(json['precautions'])
          : const [],
    );
  }

  factory ChemicalTreatmentModel.fromEntity(ChemicalTreatment entity) {
    return ChemicalTreatmentModel(
      productName: entity.productName,
      dosage: entity.dosage,
      method: entity.method,
      timing: entity.timing,
      precautions: entity.precautions,
    );
  }

  @override
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

class OrganicTreatmentModel extends OrganicTreatment {
  const OrganicTreatmentModel({
    required super.name,
    required super.preparation,
    required super.application,
    required super.frequency,
  });

  factory OrganicTreatmentModel.fromJson(Map<String, dynamic> json) {
    return OrganicTreatmentModel(
      name: json['name'] as String,
      preparation: json['preparation'] as String,
      application: json['application'] as String,
      frequency: json['frequency'] as String,
    );
  }

  factory OrganicTreatmentModel.fromEntity(OrganicTreatment entity) {
    return OrganicTreatmentModel(
      name: entity.name,
      preparation: entity.preparation,
      application: entity.application,
      frequency: entity.frequency,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'preparation': preparation,
      'application': application,
      'frequency': frequency,
    };
  }
}
