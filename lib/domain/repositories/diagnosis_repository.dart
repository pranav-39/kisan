import 'dart:io';
import '../entities/diagnosis_entity.dart';

abstract class DiagnosisRepository {
  Future<DiagnosisEntity> diagnoseCrop({
    required File imageFile,
    required String cropType,
  });
  
  Future<List<DiagnosisEntity>> getDiagnosisHistory();
  
  Future<DiagnosisEntity?> getDiagnosisById(String id);
  
  Future<void> saveDiagnosis(DiagnosisEntity diagnosis);
  
  Future<void> deleteDiagnosis(String id);
  
  Future<void> clearHistory();
  
  Future<List<DiagnosisEntity>> getUnsyncedDiagnoses();
  
  Future<void> markAsSynced(String id);
  
  Future<void> syncDiagnoses();
}
