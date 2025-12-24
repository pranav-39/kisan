// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:project_kisan/domain/entities/diagnosis_entity.dart';
import 'package:project_kisan/domain/repositories/diagnosis_repository.dart';
import 'package:project_kisan/main.dart';

class MockDiagnosisRepository implements DiagnosisRepository {
  @override
  Future<void> clearHistory() async {}

  @override
  Future<void> deleteDiagnosis(String id) async {}

  @override
  Future<DiagnosisEntity> diagnoseCrop(
      {required File imageFile, required String cropType}) async {
    return DiagnosisEntity(
        id: 'test',
        cropType: 'test',
        imagePath: 'test',
        isHealthy: true,
        confidence: 1.0,
        diagnosedAt: DateTime.now());
  }

  @override
  Future<DiagnosisEntity?> getDiagnosisById(String id) async {
    return null;
  }

  @override
  Future<List<DiagnosisEntity>> getDiagnosisHistory() async {
    return [];
  }

  @override
  Future<List<DiagnosisEntity>> getUnsyncedDiagnoses() async {
    return [];
  }

  @override
  Future<void> markAsSynced(String id) async {}

  @override
  Future<void> saveDiagnosis(DiagnosisEntity diagnosis) async {}

  @override
  Future<void> syncDiagnoses() async {}
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProjectKisanApp());

    // Verify that the app builds without crashing.
    expect(find.byType(ProjectKisanApp), findsOneWidget);
  });
}
