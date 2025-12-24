import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/diagnosis_entity.dart';

class DiagnosisResultCard extends StatelessWidget {
  final DiagnosisEntity diagnosis;

  const DiagnosisResultCard({
    super.key,
    required this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageSection(context),
        const SizedBox(height: 16),
        _buildStatusCard(context),
        if (!diagnosis.isHealthy) ...[
          const SizedBox(height: 16),
          _buildSymptomsCard(context),
          const SizedBox(height: 16),
          _buildTreatmentCard(context),
        ],
        const SizedBox(height: 16),
        _buildPreventionCard(context),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: File(diagnosis.imagePath).existsSync()
            ? Image.file(
                File(diagnosis.imagePath),
                fit: BoxFit.cover,
              )
            : Container(
                color: AppColors.backgroundLight,
                child: const Icon(Icons.image_not_supported, size: 64),
              ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      color: diagnosis.isHealthy
          ? AppColors.success.withAlpha(25)
          : AppColors.error.withAlpha(25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  diagnosis.isHealthy ? Icons.check_circle : Icons.warning,
                  color: diagnosis.isHealthy ? AppColors.success : AppColors.error,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        diagnosis.isHealthy
                            ? 'Healthy Plant'
                            : diagnosis.diseaseName ?? 'Disease Detected',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: diagnosis.isHealthy
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                      Text(
                        'Crop: ${diagnosis.cropType.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetric(
                  context,
                  'Confidence',
                  '${(diagnosis.confidence * 100).round()}%',
                  Icons.analytics,
                ),
                if (diagnosis.severity != null) ...[
                  const SizedBox(width: 24),
                  _buildMetric(
                    context,
                    'Severity',
                    diagnosis.severity!.name.toUpperCase(),
                    Icons.warning_amber,
                    color: _getSeverityColor(diagnosis.severity!),
                  ),
                ],
              ],
            ),
            if (diagnosis.rootCause != null) ...[
              const Divider(height: 24),
              Text(
                'Root Cause',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                diagnosis.rootCause!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.textSecondaryLight),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSymptomsCard(BuildContext context) {
    if (diagnosis.symptoms.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.visibility, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  'Symptoms',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...diagnosis.symptoms.map((symptom) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: AppColors.error),
                  const SizedBox(width: 12),
                  Expanded(child: Text(symptom)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentCard(BuildContext context) {
    if (diagnosis.treatment == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.medical_services, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Treatment',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (diagnosis.treatment!.chemical != null)
              _buildTreatmentSection(
                context,
                'Chemical Treatment',
                Icons.science,
                AppColors.error,
                [
                  'Product: ${diagnosis.treatment!.chemical!.productName}',
                  'Dosage: ${diagnosis.treatment!.chemical!.dosage}',
                  'Method: ${diagnosis.treatment!.chemical!.method}',
                  'Timing: ${diagnosis.treatment!.chemical!.timing}',
                ],
              ),
            if (diagnosis.treatment!.organic != null) ...[
              const Divider(height: 24),
              _buildTreatmentSection(
                context,
                'Organic Treatment',
                Icons.eco,
                AppColors.success,
                [
                  'Name: ${diagnosis.treatment!.organic!.name}',
                  'Preparation: ${diagnosis.treatment!.organic!.preparation}',
                  'Application: ${diagnosis.treatment!.organic!.application}',
                  'Frequency: ${diagnosis.treatment!.organic!.frequency}',
                ],
              ),
            ],
            if (diagnosis.treatment!.culturalPractices.isNotEmpty) ...[
              const Divider(height: 24),
              Text(
                'Cultural Practices',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...diagnosis.treatment!.culturalPractices.map((practice) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(practice)),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<String> details,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...details.map((detail) => Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 26),
          child: Text(detail, style: Theme.of(context).textTheme.bodySmall),
        )),
      ],
    );
  }

  Widget _buildPreventionCard(BuildContext context) {
    if (diagnosis.preventionTips.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shield, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  'Prevention Tips',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...diagnosis.preventionTips.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withAlpha(25),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(entry.value)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
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
