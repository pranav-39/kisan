import 'dart:io';

import 'package:flutter/material.dart';
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
  bool get hasError => _state == DiagnosisState.error;

  CropDiagnosisProvider() {
    _loadDiagnosisHistory();
  }

  Future<void> _loadDiagnosisHistory() async {
    try {
      final historyData = HiveService.instance.getAllDiagnoses();
      _diagnosisHistory = historyData
          .map(DiagnosisModel.fromJson)
          .toList()
        ..sort((a, b) => b.diagnosedAt.compareTo(a.diagnosedAt));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading diagnosis history: $e');
    }
  }

  void setSelectedCrop(String crop) {
    _selectedCrop = crop;
    notifyListeners();
  }

  Future<void> pickImageFromCamera() async {
    _state = DiagnosisState.selectingImage;
    _errorMessage = null;
    notifyListeners();

    try {
      final image = await ImageHelper.pickFromCamera();
      if (image != null) {
        _selectedImage = image;
        _state = DiagnosisState.initial;
      } else {
        _state = DiagnosisState.initial;
      }
    } catch (e) {
      _state = DiagnosisState.error;
      _errorMessage = 'Failed to capture image: $e';
    }

    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    _state = DiagnosisState.selectingImage;
    _errorMessage = null;
    notifyListeners();

    try {
      final image = await ImageHelper.pickFromGallery();
      if (image != null) {
        _selectedImage = image;
        _state = DiagnosisState.initial;
      } else {
        _state = DiagnosisState.initial;
      }
    } catch (e) {
      _state = DiagnosisState.error;
      _errorMessage = 'Failed to pick image: $e';
    }

    notifyListeners();
  }

  Future<void> analyzeCrop() async {
    if (_selectedImage == null) {
      _errorMessage = 'Please select an image first';
      _state = DiagnosisState.error;
      notifyListeners();
      return;
    }

    if (_selectedCrop == null) {
      _errorMessage = 'Please select a crop type';
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

      // TODO: Replace this mock data with a call to the actual Gemini Vision API through a Cloud Function.
      // This is mock data for demonstration
      await Future.delayed(const Duration(seconds: 2));

      _currentDiagnosis = _getMockDiagnosis(savedImage.path);

      // Save to history
      await _saveDiagnosis(_currentDiagnosis!);
      await _loadDiagnosisHistory();

      _state = DiagnosisState.completed;
    } catch (e) {
      _state = DiagnosisState.error;
      _errorMessage = 'Failed to analyze image: $e';
    }

    notifyListeners();
  }

  Future<void> _saveDiagnosis(DiagnosisEntity diagnosis) async {
    try {
      final model = DiagnosisModel.fromEntity(diagnosis);
      await HiveService.instance.saveDiagnosis(diagnosis.id, model.toJson());
    } catch (e) {
      debugPrint('Error saving diagnosis: $e');
    }
  }

  Future<void> deleteDiagnosis(String id) async {
    try {
      await HiveService.instance.deleteDiagnosis(id);
      await _loadDiagnosisHistory();
    } catch (e) {
      debugPrint('Error deleting diagnosis: $e');
    }
  }

  Future<void> clearHistory() async {
    try {
      await HiveService.instance.clearDiagnosisHistory();
      _diagnosisHistory = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  void reset() {
    _state = DiagnosisState.initial;
    _selectedImage = null;
    _currentDiagnosis = null;
    _errorMessage = null;
    notifyListeners();
  }

  void viewDiagnosis(DiagnosisEntity diagnosis) {
    _currentDiagnosis = diagnosis;
    _state = DiagnosisState.completed;
    notifyListeners();
  }

  DiagnosisEntity _getMockDiagnosis(String imagePath) {
    // Randomly decide if healthy or diseased for demo
    final isHealthy = DateTime.now().millisecond % 3 == 0;

    if (isHealthy) {
      return DiagnosisEntity(
        id: const Uuid().v4(),
        cropType: _selectedCrop!,
        imagePath: imagePath,
        isHealthy: true,
        confidence: 0.95,
        symptoms: const [],
        preventionTips: const [
          'Continue regular watering schedule',
          'Monitor for any early signs of pest activity',
          'Apply preventive fungicide spray if weather becomes humid',
        ],
        diagnosedAt: DateTime.now(),
      );
    }

    return DiagnosisEntity(
      id: const Uuid().v4(),
      cropType: _selectedCrop!,
      imagePath: imagePath,
      isHealthy: false,
      diseaseName: 'Late Blight',
      confidence: 0.87,
      severity: DiseaseSeverity.medium,
      symptoms: const [
        'Water-soaked lesions on leaves',
        'White fungal growth on leaf undersides',
        'Brown spots spreading rapidly',
        'Stem lesions present',
      ],
      rootCause: 'Caused by Phytophthora infestans fungus. Spreads rapidly in cool, wet conditions.',
      treatment: const TreatmentPlan(
        chemical: ChemicalTreatment(
          productName: 'Mancozeb 75% WP',
          dosage: '2.5g per liter of water',
          method: 'Foliar spray covering all plant surfaces',
          timing: 'Apply immediately, repeat after 7 days',
          precautions: [
            'Wear protective gloves and mask',
            'Do not spray during windy conditions',
            'Maintain 7-day pre-harvest interval',
          ],
        ),
        organic: OrganicTreatment(
          name: 'Copper Hydroxide',
          preparation: 'Mix 3g per liter of water',
          application: 'Spray on affected and surrounding plants',
          frequency: 'Every 5-7 days until symptoms subside',
        ),
        culturalPractices: [
          'Remove and destroy infected plant parts',
          'Improve air circulation between plants',
          'Avoid overhead irrigation',
          'Rotate crops next season',
        ],
      ),
      preventionTips: const [
        'Use disease-resistant varieties',
        'Maintain proper plant spacing',
        'Apply preventive fungicide before rainy season',
        'Monitor weather forecasts for disease-favorable conditions',
      ],
      diagnosedAt: DateTime.now(),
    );
  }
}
