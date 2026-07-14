import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme_colors.dart';

/// A bottom sheet that simulates uploading a prescription photo.
/// No real file system access is needed — the upload flow is mocked.
class PrescriptionUploadSheet extends StatefulWidget {
  const PrescriptionUploadSheet({super.key});

  @override
  State<PrescriptionUploadSheet> createState() =>
      _PrescriptionUploadSheetState();
}

class _PrescriptionUploadSheetState extends State<PrescriptionUploadSheet>
    with TickerProviderStateMixin {
  // States: idle | uploading | success
  String _uploadState = 'idle';
  String? _selectedSource;
  double _progress = 0.0;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 24).chain(
      CurveTween(curve: Curves.elasticIn),
    ).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _simulateUpload(String source) async {
    setState(() {
      _selectedSource = source;
      _uploadState = 'uploading';
      _progress = 0.0;
    });

    // Simulate progress in steps
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      setState(() => _progress = i / 10.0);
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    setState(() => _uploadState = 'success');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 8,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: context.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.pharmacyGradientStart,
                      AppColors.pharmacyGradientEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Iconsax.document_upload,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.uploadPrescription,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  Text(
                    AppStrings.prescriptionNote,
                    style: TextStyle(
                        fontSize: 11, color: context.textMutedColor),
                    maxLines: 2,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Upload source options or progress/success
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: _buildContent(),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_uploadState == 'idle') {
      return Column(
        key: const ValueKey('idle'),
        children: [
          // Dashed upload area
          GestureDetector(
            onTap: () => _simulateUpload('gallery'),
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.pharmacyLight.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.pharmacyPrimary.withOpacity(0.5),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.image, size: 40,
                      color: AppColors.pharmacyPrimary.withOpacity(0.7)),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to select or drag & drop',
                    style: TextStyle(
                      color: AppColors.pharmacyPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'JPG, PNG, PDF up to 10MB',
                    style: TextStyle(
                        fontSize: 11,
                        color: AppColors.pharmacyPrimary.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('or choose source',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 16),
          // Source buttons row
          Row(
            children: [
              Expanded(
                child: _SourceButton(
                  icon: Iconsax.camera,
                  label: AppStrings.uploadFromCamera,
                  color: AppColors.pharmacyPrimary,
                  onTap: () => _simulateUpload('camera'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SourceButton(
                  icon: Iconsax.gallery,
                  label: AppStrings.uploadFromGallery,
                  color: AppColors.pharmacySecondary,
                  onTap: () => _simulateUpload('gallery'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SourceButton(
                  icon: Iconsax.document,
                  label: AppStrings.uploadFromFiles,
                  color: AppColors.pharmacyDark,
                  onTap: () => _simulateUpload('files'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    if (_uploadState == 'uploading') {
      return Column(
        key: const ValueKey('uploading'),
        children: [
          const SizedBox(height: 8),
          // Animated file icon
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (_, val, child) => Transform.scale(scale: val, child: child),
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.pharmacyLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.document_upload,
                  size: 36, color: AppColors.pharmacyPrimary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Uploading via ${_selectedSource ?? "gallery"}...',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.pharmacyPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: AppColors.pharmacyLight,
              color: AppColors.pharmacyPrimary,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(_progress * 100).toInt()}%',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.pharmacyPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    // Success state
    return Column(
      key: const ValueKey('success'),
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.elasticOut,
          builder: (_, val, child) =>
              Transform.scale(scale: val, child: child),
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.pharmacyGradientStart,
                  AppColors.pharmacyGradientEnd,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded,
                color: Colors.white, size: 44),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.prescriptionUploaded,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.pharmacyPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Our pharmacist will verify your prescription within 2 hours.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pharmacyPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
