import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/diagnosis_entity.dart';
import '../../providers/crop_diagnosis_provider.dart';
import 'widgets/diagnosis_result_card.dart';

class DiagnosisScreen extends StatelessWidget {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Consumer<CropDiagnosisProvider>(
      builder: (context, provider, child) {
        if (provider.state == DiagnosisState.completed && provider.hasResult) {
          return _DiagnosisResultView(
            diagnosis: provider.currentDiagnosis!,
            onBack: () => provider.reset(),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(context, provider, localizations),
              const SizedBox(height: 24),
              _buildCropSelector(context, provider, localizations),
              const SizedBox(height: 24),
              _buildAnalyzeButton(context, provider, localizations),
              const SizedBox(height: 32),
              _buildHistorySection(context, provider, localizations),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    CropDiagnosisProvider provider,
    AppLocalizations? loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc?.scanCrop ?? 'Scan Crop',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showImageSourceDialog(context, provider, loc),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.dividerLight,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: provider.selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      provider.selectedImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 48,
                        color: AppColors.textSecondaryLight,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tap to capture or select image',
                        style: TextStyle(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => provider.pickImageFromCamera(),
                icon: const Icon(Icons.camera_alt),
                label: Text(loc?.takePhoto ?? 'Camera'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => provider.pickImageFromGallery(),
                icon: const Icon(Icons.photo_library),
                label: Text(loc?.chooseGallery ?? 'Gallery'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showImageSourceDialog(
    BuildContext context,
    CropDiagnosisProvider provider,
    AppLocalizations? loc,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(loc?.takePhoto ?? 'Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  provider.pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(loc?.chooseGallery ?? 'Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  provider.pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCropSelector(
    BuildContext context,
    CropDiagnosisProvider provider,
    AppLocalizations? loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc?.selectCrop ?? 'Select Crop',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.supportedCrops.map((crop) {
            final isSelected = provider.selectedCrop == crop;
            final cropName = loc?.translate(crop) ?? crop;
            
            return ChoiceChip(
              label: Text(cropName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  provider.setSelectedCrop(crop);
                }
              },
              selectedColor: AppColors.primaryLight,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton(
    BuildContext context,
    CropDiagnosisProvider provider,
    AppLocalizations? loc,
  ) {
    final canAnalyze = provider.selectedImage != null && 
                       provider.selectedCrop != null &&
                       !provider.isAnalyzing;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: canAnalyze ? () => provider.analyzeCrop() : null,
        icon: provider.isAnalyzing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.search),
        label: Text(
          provider.isAnalyzing
              ? (loc?.analyzing ?? 'Analyzing...')
              : 'Analyze Crop',
        ),
      ),
    );
  }

  Widget _buildHistorySection(
    BuildContext context,
    CropDiagnosisProvider provider,
    AppLocalizations? loc,
  ) {
    if (provider.diagnosisHistory.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              loc?.diagnosisHistory ?? 'Diagnosis History',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (provider.diagnosisHistory.isNotEmpty)
              TextButton(
                onPressed: () => _showClearHistoryDialog(context, provider),
                child: const Text('Clear All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.diagnosisHistory.take(5).length,
          itemBuilder: (context, index) {
            final diagnosis = provider.diagnosisHistory[index];
            return _DiagnosisHistoryItem(
              diagnosis: diagnosis,
              onTap: () => provider.viewDiagnosis(diagnosis),
              onDelete: () => provider.deleteDiagnosis(diagnosis.id),
            );
          },
        ),
      ],
    );
  }

  void _showClearHistoryDialog(
    BuildContext context,
    CropDiagnosisProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Clear History'),
          content: const Text('Are you sure you want to clear all diagnosis history?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.clearHistory();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }
}

class _DiagnosisHistoryItem extends StatelessWidget {
  final DiagnosisEntity diagnosis;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DiagnosisHistoryItem({
    required this.diagnosis,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 56,
            height: 56,
            child: File(diagnosis.imagePath).existsSync()
                ? Image.file(
                    File(diagnosis.imagePath),
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: AppColors.backgroundLight,
                    child: const Icon(Icons.image_not_supported),
                  ),
          ),
        ),
        title: Text(
          diagnosis.isHealthy
              ? 'Healthy Plant'
              : diagnosis.diseaseName ?? 'Unknown',
          style: TextStyle(
            color: diagnosis.isHealthy ? AppColors.success : AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${diagnosis.cropType} • ${_formatDate(diagnosis.diagnosedAt)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!diagnosis.isHealthy && diagnosis.severity != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSeverityColor(diagnosis.severity!).withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  diagnosis.severity!.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: _getSeverityColor(diagnosis.severity!),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              iconSize: 20,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getSeverityColor(DiseaseSeverity severity) {
    switch (severity) {
      case DiseaseSeverity.low:
        return AppColors.warning;
      case DiseaseSeverity.medium:
        return AppColors.warningDark;
      case DiseaseSeverity.high:
        return AppColors.error;
    }
  }
}

class _DiagnosisResultView extends StatelessWidget {
  final DiagnosisEntity diagnosis;
  final VoidCallback onBack;

  const _DiagnosisResultView({
    required this.diagnosis,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Result'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: DiagnosisResultCard(diagnosis: diagnosis),
      ),
    );
  }
}
