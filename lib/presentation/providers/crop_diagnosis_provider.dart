import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../core/utils/image_helper.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../data/models/diagnosis_model.dart';
import '../../domain/entities/diagnosis_entity.dart';

enum DiagnosisState {
  initial,
  selectingImage,
  analyzing,
  completed,
  error,
}

class CropDiagnosisProvider extends ChangeNotifier {
  DiagnosisState _state = DiagnosisState.initial;
  File? _selectedImage;
  String? _selectedCrop;
  DiagnosisEntity? _currentDiagnosis;
  List<DiagnosisEntity> _diagnosisHistory = [];
  String? _errorMessage;

  DiagnosisState get state => _state;
  File? get selectedImage => _selectedImage;
  String? get selectedCrop => _selectedCrop;
  DiagnosisEntity? get currentDiagnosis => _currentDiagnosis;
  List<DiagnosisEntity> get diagnosisHistory => _diagnosisHistory;
  String? get errorMessage => _errorMessage;

  bool get isAnalyzing => _state == DiagnosisState.analyzing;
  bool get hasResult => _currentDiagnosis != null;

  CropDiagnosisProvider() {
    _loadHistory();
  }

  // ---------------------------------------------------------------------------
  // HISTORY
  // ---------------------------------------------------------------------------

  Future<void> _loadHistory() async {
    final raw = HiveService.instance.getAllDiagnoses();
    _diagnosisHistory = raw
        .map(DiagnosisModel.fromJson)
        .toList()
      ..sort((a, b) => b.diagnosedAt.compareTo(a.diagnosedAt));

    notifyListeners();
  }

  Future<void> clearHistory() async {
    await HiveService.instance.clearDiagnosisHistory();
    await _loadHistory();
  }

  // ---------------------------------------------------------------------------
  // IMAGE SELECTION
  // ---------------------------------------------------------------------------

  void setSelectedCrop(String crop) {
    _selectedCrop = crop;
    notifyListeners();
  }

  Future<void> pickImageFromCamera() async {
    _state = DiagnosisState.selectingImage;
    notifyListeners();

    final image = await ImageHelper.pickFromCamera();
    if (image != null) {
      _selectedImage = image;
    }

    _state = DiagnosisState.initial;
    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    _state = DiagnosisState.selectingImage;
    notifyListeners();

    final image = await ImageHelper.pickFromGallery();
    if (image != null) {
      _selectedImage = image;
    }

    _state = DiagnosisState.initial;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // REAL DIAGNOSIS (GEMINI VISION)
  // ---------------------------------------------------------------------------

  Future<void> analyzeCrop() async {
    if (_selectedImage == null || _selectedCrop == null) {
      _errorMessage = 'Select image and crop first';
      _state = DiagnosisState.error;
      notifyListeners();
      return;
    }

    _state = DiagnosisState.analyzing;
    _errorMessage = null;
    notifyListeners();

    try {
      // Save image locally
      final savedImage = await ImageHelper.saveImageLocally(
        _selectedImage!,
        '${const Uuid().v4()}.jpg',
      );

      final bytes = await savedImage.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(
          'https://us-central1-plasma-hope-467112-t6.cloudfunctions.net/analyzeImage',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
          'mimeType': 'image/jpeg',
          'prompt':
              'Diagnose disease for $_selectedCrop crop. Provide structured JSON.',
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Diagnosis failed');
      }

      final data = jsonDecode(response.body);

      final diagnosis = DiagnosisEntity(
        id: const Uuid().v4(),
        cropType: _selectedCrop!,
        imagePath: savedImage.path,
        isHealthy: data['isHealthy'] as bool,
        diseaseName: data['diseaseName'],
        confidence: (data['confidence'] as num).toDouble(),
        severity: _parseSeverity(data['severity']),
        symptoms: List<String>.from(data['symptoms'] ?? []),
        treatment: _parseTreatment(data['treatment']),
        diagnosedAt: DateTime.now(),
        isSynced: false,
      );

      _currentDiagnosis = diagnosis;

      await HiveService.instance.saveDiagnosis(
        diagnosis.id,
        DiagnosisModel.fromEntity(diagnosis).toJson(),
      );

      await _loadHistory();

      _state = DiagnosisState.completed;
    } catch (e) {
      _state = DiagnosisState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  DiseaseSeverity? _parseSeverity(String? value) {
    if (value == null) return null;
    switch (value.toLowerCase()) {
      case 'low':
        return DiseaseSeverity.low;
      case 'medium':
        return DiseaseSeverity.medium;
      case 'high':
        return DiseaseSeverity.high;
      default:
        return null;
    }
  }

  TreatmentPlan? _parseTreatment(Map<String, dynamic>? json) {
    if (json == null) return null;
    return TreatmentPlanModel.fromJson(json);
  }

  // ---------------------------------------------------------------------------
  // UI ACTIONS
  // ---------------------------------------------------------------------------

  Future<void> deleteDiagnosis(String id) async {
    await HiveService.instance.deleteDiagnosis(id);
    await _loadHistory();
  }

  void viewDiagnosis(DiagnosisEntity diagnosis) {
    _currentDiagnosis = diagnosis;
    _state = DiagnosisState.completed;
    notifyListeners();
  }

  void reset() {
    _state = DiagnosisState.initial;
    _selectedImage = null;
    _currentDiagnosis = null;
    _errorMessage = null;
    notifyListeners();
  }
}
