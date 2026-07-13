import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class HelpSupportSheet extends StatelessWidget {
  const HelpSupportSheet({super.key});

  static const List<Map<String, dynamic>> _faqs = [
    {
      'q': 'How do I track my order?',
      'a': 'Go to My Orders > Select your order > Tap "Track Order". You will see real-time tracking updates.',
    },
    {
      'q': 'Can I cancel my order?',
      'a': 'You can cancel an order within 1 hour of placing it, as long as it hasn\'t been shipped yet. Go to My Orders and tap "Cancel Order".',
    },
    {
      'q': 'What is the return policy?',
      'a': 'We offer a 7-day hassle-free return policy. Items must be unused and in original packaging. Go to My Orders to initiate a return.',
    },
    {
      'q': 'How long does delivery take?',
      'a': 'Standard delivery takes 3-5 business days within Dhaka and 5-7 days outside Dhaka.',
    },
    {
      'q': 'Is my payment information secure?',
      'a': 'Yes! We use industry-standard 256-bit SSL encryption. We never store your full card details on our servers.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
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
            const Text('Help & Support', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: AppSizes.sm),

            // Contact Cards
            Row(
              children: [
                _ContactCard(icon: Iconsax.call, label: 'Call Us', sub: '09617-000000', color: Colors.green),
                const SizedBox(width: 10),
                _ContactCard(icon: Iconsax.message, label: 'Live Chat', sub: 'Avg. 2 min', color: AppColors.primary),
                const SizedBox(width: 10),
                _ContactCard(icon: Iconsax.sms, label: 'Email', sub: 'support@shopnest.com', color: const Color(0xFFFF6B35)),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            const Text('Frequently Asked Questions', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: AppSizes.sm),

            ..._faqs.map((faq) => _FaqTile(question: faq['q'] as String, answer: faq['a'] as String)),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;

  const _ContactCard({required this.icon, required this.label, required this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(color: AppColors.textMuted, fontSize: 9), textAlign: TextAlign.center, maxLines: 2),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;
  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _expanded ? AppColors.primary.withValues(alpha: 0.4) : AppColors.darkBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            ListTile(
              title: Text(widget.question, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w500)),
            trailing: Icon(
              _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColors.textMuted,
              size: 20,
            ),
            onTap: () => setState(() => _expanded = !_expanded),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            dense: true,
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Text(widget.answer, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.6)),
            ),
          ],
        ),
      ),
    );
  }
}
