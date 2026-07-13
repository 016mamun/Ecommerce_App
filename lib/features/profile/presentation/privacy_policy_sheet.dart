import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class PrivacyPolicySheet extends StatelessWidget {
  const PrivacyPolicySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.93,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppColors.darkBorder, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            const Text('Privacy Policy', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Last updated: July 2025', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: AppSizes.lg),

            _PolicySection(
              title: '1. Information We Collect',
              content: 'We collect information you provide directly to us, such as when you create an account, make a purchase, or contact us for support. This includes your name, email address, phone number, shipping address, and payment information.\n\nWe also automatically collect certain information about your device and how you interact with our app, including IP address, device type, operating system, and browsing behavior within the app.',
            ),
            _PolicySection(
              title: '2. How We Use Your Information',
              content: 'We use the information we collect to:\n• Process and fulfill your orders\n• Send order confirmations and shipping updates\n• Respond to your comments and questions\n• Send promotional communications (with your consent)\n• Monitor and analyze trends and usage\n• Detect and prevent fraudulent transactions',
            ),
            _PolicySection(
              title: '3. Information Sharing',
              content: 'We do not sell, trade, or otherwise transfer your personal information to outside parties except to trusted third parties who assist us in operating our app and conducting our business, so long as those parties agree to keep this information confidential.\n\nWe may also release your information when we believe release is appropriate to comply with the law.',
            ),
            _PolicySection(
              title: '4. Data Security',
              content: 'We implement industry-standard security measures including 256-bit SSL encryption, secure servers, and regular security audits to protect your personal information. Your payment information is never stored on our servers — all transactions are processed through secure payment gateways.',
            ),
            _PolicySection(
              title: '5. Cookies & Tracking',
              content: 'We use cookies and similar tracking technologies to track the activity on our service and hold certain information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.',
            ),
            _PolicySection(
              title: '6. Your Rights',
              content: 'You have the right to:\n• Access your personal data\n• Correct inaccurate data\n• Request deletion of your data\n• Object to processing of your data\n• Request restriction of processing\n• Data portability\n\nTo exercise any of these rights, please contact us at privacy@shopnest.com.',
            ),
            _PolicySection(
              title: '7. Contact Us',
              content: 'If you have any questions about this Privacy Policy, please contact us at:\n\nShopNest Bangladesh Ltd.\nEmail: privacy@shopnest.com\nPhone: 09617-000000\nAddress: Dhaka, Bangladesh',
            ),
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }
}

class _PolicySection extends StatelessWidget {
  final String title;
  final String content;
  const _PolicySection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
