import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme_colors.dart';

// ── Chat Message Model ────────────────────────────────────────────────────────
class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  _ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

// ── Mock Q&A Database ─────────────────────────────────────────────────────────
const _mockResponses = [
  'I understand your concern. Based on what you\'ve described, it sounds like you may need a standard analgesic like Paracetamol (500mg) taken every 4–6 hours with food. However, if symptoms persist beyond 3 days, please consult a doctor.',
  'That\'s a great question! Drug interactions are very important. These two medicines should generally be taken at least 2 hours apart to avoid reduced absorption. Always inform all your healthcare providers of everything you take.',
  'For general antibiotic courses, it is very important to complete the full prescribed duration even if you feel better. Stopping early can cause antibiotic resistance. Please continue as prescribed.',
  'I recommend checking with your doctor before combining these supplements with your current prescription. Some herbal products can affect how the body processes prescription drugs.',
  'Regarding your dosage question — the standard adult dose for this medicine is typically once daily in the morning with food. Never double-dose if you miss one.',
  'That side effect you mentioned is listed as uncommon but possible. If it persists or becomes severe, you should stop the medication and consult your physician immediately.',
  'Blood pressure medicines should generally be taken at the same time every day for consistency. Try setting a daily phone reminder. Avoid missing doses as blood pressure can spike suddenly.',
  'Your concern about the expiry date is valid — never use medications past their expiry date. The chemical composition can change and it may be less effective or potentially harmful.',
];

// ── Screen ────────────────────────────────────────────────────────────────────
class AskPharmacistScreen extends ConsumerStatefulWidget {
  const AskPharmacistScreen({super.key});

  @override
  ConsumerState<AskPharmacistScreen> createState() =>
      _AskPharmacistScreenState();
}

class _AskPharmacistScreenState extends ConsumerState<AskPharmacistScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[];
  bool _isTyping = false;
  int _responseIndex = 0;

  @override
  void initState() {
    super.initState();
    // Greeting message from pharmacist
    _messages.add(_ChatMessage(
      text: AppStrings.pharmacistGreeting,
      isUser: false,
      time: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isUser: true,
        time: DateTime.now(),
      ));
      _isTyping = true;
      _controller.clear();
    });
    _scrollToBottom();

    // Simulate pharmacist typing delay (1.5–2s)
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(
        text: _mockResponses[_responseIndex % _mockResponses.length],
        isUser: false,
        time: DateTime.now(),
      ));
      _responseIndex++;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bgColor,
      appBar: AppBar(
        backgroundColor: context.surfaceColor,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.pharmacyGradientStart,
                    AppColors.pharmacyGradientEnd,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('👩‍⚕️', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. Nadia — Pharmacist',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimaryColor,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.pharmacyPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Online · Certified Pharmacist',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.pharmacyPrimary),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.call, color: AppColors.pharmacyPrimary),
            onPressed: () => _showCallDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        children: [
          // Quick suggestion chips
          _QuickSuggestions(onTap: (q) {
            _controller.text = q;
            _sendMessage();
          }),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const _TypingIndicator();
                }
                final msg = _messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),

          // Input bar
          _MessageInputBar(
            controller: _controller,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Voice Consultation'),
        content: const Text(
            'Live voice consultations are available between 9 AM – 6 PM, Saturday to Thursday. '
            'Would you like to schedule a call?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pharmacyPrimary),
            child: const Text('Schedule',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ── Quick Suggestion Chips ───────────────────────────────────────────────────
class _QuickSuggestions extends StatelessWidget {
  final void Function(String) onTap;

  const _QuickSuggestions({required this.onTap});

  static const _suggestions = [
    'Drug interaction?',
    'Dosage for adults?',
    'Side effects?',
    'Safe in pregnancy?',
    'Generic alternative?',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      color: context.surfaceColor,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final s = _suggestions[index];
          return GestureDetector(
            onTap: () => onTap(s),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.pharmacyPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.pharmacyPrimary.withOpacity(0.4)),
              ),
              child: Text(
                s,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.pharmacyPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Chat Bubble ───────────────────────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.pharmacyGradientStart,
                    AppColors.pharmacyGradientEnd,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Text('👩‍⚕️', style: TextStyle(fontSize: 14))),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.pharmacyPrimary
                    : context.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 13,
                  color: isUser ? Colors.white : context.textPrimaryColor,
                  height: 1.45,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: context.cardColor,
                shape: BoxShape.circle,
                border: Border.all(color: context.borderColor),
              ),
              child: const Center(
                  child: Text('👤', style: TextStyle(fontSize: 14))),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Typing Indicator ──────────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _dotControllers;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _dotControllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
    _dotAnimations = _dotControllers
        .map((c) => Tween<double>(begin: 0, end: -8)
            .chain(CurveTween(curve: Curves.easeInOut))
            .animate(c))
        .toList();

    // Stagger dot animations
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _dotControllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.pharmacyGradientStart,
                  AppColors.pharmacyGradientEnd,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
                child: Text('👩‍⚕️', style: TextStyle(fontSize: 14))),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _dotAnimations[i],
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, _dotAnimations[i].value),
                    child: child,
                  ),
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                    decoration: const BoxDecoration(
                      color: AppColors.pharmacyPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message Input Bar ─────────────────────────────────────────────────────────
class _MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInputBar(
      {required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.surfaceColor,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: AppStrings.typeMessage,
                hintStyle:
                    TextStyle(color: context.textMutedColor, fontSize: 14),
                filled: true,
                fillColor: context.bgColor,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide:
                      BorderSide(color: context.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(
                      color: AppColors.pharmacyPrimary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.pharmacyGradientStart,
                    AppColors.pharmacyGradientEnd,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.send_1,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
