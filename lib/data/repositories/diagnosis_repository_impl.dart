import 'dart:io';

import 'package:project_kisan/data/datasources/local/hive_service.dart';
import 'package:project_kisan/data/models/diagnosis_model.dart';
import 'package:project_kisan/domain/entities/diagnosis_entity.dart';
import 'package:project_kisan/domain/repositories/diagnosis_repository.dart';

class DiagnosisRepositoryImpl implements DiagnosisRepository {
  final HiveService hiveService;

  DiagnosisRepositoryImpl({required this.hiveService});

  // ---------------------------------------------------------------------------
  // READ
  // ---------------------------------------------------------------------------

  @override
  Future<List<DiagnosisEntity>> getDiagnosisHistory() async {
    final rawList = hiveService.getAllDiagnoses();

    final list = rawList
        .map(DiagnosisModel.fromJson)
        .toList();

    list.sort((a, b) => b.diagnosedAt.compareTo(a.diagnosedAt));
    return list;
  }

  @override
  Future<DiagnosisEntity?> getDiagnosisById(String id) async {
    final data = hiveService.getDiagnosis(id);
    if (data == null) return null;
    return DiagnosisModel.fromJson(data);
  }

  // ---------------------------------------------------------------------------
  // WRITE
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveDiagnosis(DiagnosisEntity diagnosis) async {
    final model = DiagnosisModel.fromEntity(diagnosis);
    await hiveService.saveDiagnosis(model.id, model.toJson());
  }

  @override
  Future<void> deleteDiagnosis(String id) async {
    await hiveService.deleteDiagnosis(id);
  }

  @override
  Future<void> clearHistory() async {
    await hiveService.clearDiagnosisHistory();
  }

  // ---------------------------------------------------------------------------
  // SYNC (offline → online placeholder, real backend handled elsewhere)
  // ---------------------------------------------------------------------------

  @override
  Future<List<DiagnosisEntity>> getUnsyncedDiagnoses() async {
    final rawList = hiveService.getAllDiagnoses();

    return rawList
        .map(DiagnosisModel.fromJson)
        .where((d) => !d.isSynced)
        .toList();
  }

  @override
  Future<void> markAsSynced(String id) async {
    final data = hiveService.getDiagnosis(id);
    if (data == null) return;

    data['isSynced'] = true;
    await hiveService.saveDiagnosis(id, data);
  }

  @override
  Future<void> syncDiagnoses() async {
    // Real syncing is done via Firebase Cloud Functions.
    // This repository only updates local sync flags.
    final unsynced = await getUnsyncedDiagnoses();

    for (final d in unsynced) {
      await markAsSynced(d.id);
    }
  }

  // ---------------------------------------------------------------------------
  // DIAGNOSIS (real inference handled by Cloud Functions)
  // ---------------------------------------------------------------------------

  @override
  Future<DiagnosisEntity> diagnoseCrop({
    required File imageFile,
    required String cropType,
  }) {
    throw UnimplementedError(
      'Diagnosis is performed via Firebase Cloud Functions (Gemini Vision).',
    );
  }
}
