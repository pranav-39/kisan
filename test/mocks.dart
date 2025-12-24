
import 'dart:io';

import 'package:project_kisan/domain/entities/diagnosis_entity.dart';
import 'package:project_kisan/domain/repositories/diagnosis_repository.dart';

class MockDiagnosisRepository implements DiagnosisRepository {
  @override
  Future<void> clearHistory() {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDiagnosis(String id) {
    throw UnimplementedError();
  }

  @override
  Future<DiagnosisEntity> diagnoseCrop(
      {required File imageFile, required String cropType}) async {
    return DiagnosisEntity(
      id: 'test_id',
      cropType: 'test_crop',
      imagePath: 'test_path',
      isHealthy: true,
      confidence: 0.9,
      diagnosedAt: DateTime.now(),
    );
  }

  @override
  Future<DiagnosisEntity?> getDiagnosisById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<DiagnosisEntity>> getDiagnosisHistory() {
    throw UnimplementedError();
  }

  @override
  Future<List<DiagnosisEntity>> getUnsyncedDiagnoses() {
    throw UnimplementedError();
  }

  @override
  Future<void> markAsSynced(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveDiagnosis(DiagnosisEntity diagnosis) {
    throw UnimplementedError();
  }

  @override
  Future<void> syncDiagnoses() {
    throw UnimplementedError();
  }
}
