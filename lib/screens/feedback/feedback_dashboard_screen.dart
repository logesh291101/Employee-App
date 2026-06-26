import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/profile/widgets/profile_app_bar.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackDashboardScreen extends StatefulWidget {
  const FeedbackDashboardScreen({super.key, this.showBackButton = false});

  final bool showBackButton;

  @override
  State<FeedbackDashboardScreen> createState() =>
      _FeedbackDashboardScreenState();
}

class _FeedbackDashboardScreenState extends State<FeedbackDashboardScreen> {
  final _feedbackSubjectController = TextEditingController();
  final _feedbackDescriptionController = TextEditingController();
  final _suggestionTitleController = TextEditingController();
  final _suggestionDescriptionController = TextEditingController();

  String? _feedbackCategory;
  String? _suggestionCategory;
  int _rating = 0;
  bool _isSubmittingFeedback = false;
  bool _isSubmittingSuggestion = false;

  List<Map<String, String>> _suggestions = [
    {
      'title': 'Flexible break timings',
      'category': 'Workplace Improvements',
      'description': 'Allow flexible break slots during peak project hours.',
      'date': '28 May 2026',
    },
    {
      'title': 'Mobile app dark mode',
      'category': 'Product Ideas',
      'description': 'Add dark mode support for better usability.',
      'date': '20 May 2026',
    },
  ];

  static const _feedbackCategories = [
    'Work Environment',
    'Management',
    'Tools & Systems',
    'Team Collaboration',
    'Other',
  ];

  static const _suggestionCategories = [
    'Process Improvements',
    'Workplace Improvements',
    'Product Ideas',
    'Employee Engagement Ideas',
  ];

  @override
  void dispose() {
    _feedbackSubjectController.dispose();
    _feedbackDescriptionController.dispose();
    _suggestionTitleController.dispose();
    _suggestionDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_feedbackCategory == null ||
        _feedbackSubjectController.text.trim().isEmpty ||
        _feedbackDescriptionController.text.trim().isEmpty) {
      HapticFeedback.heavyImpact();
      showAuthSnackBar(context, 'Please fill all required fields');
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _isSubmittingFeedback = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _isSubmittingFeedback = false;
      _feedbackCategory = null;
      _rating = 0;
      _feedbackSubjectController.clear();
      _feedbackDescriptionController.clear();
    });
    showAuthSnackBar(context, 'Feedback submitted successfully.');
  }

  Future<void> _submitSuggestion() async {
    if (_suggestionCategory == null ||
        _suggestionTitleController.text.trim().isEmpty ||
        _suggestionDescriptionController.text.trim().isEmpty) {
      HapticFeedback.heavyImpact();
      showAuthSnackBar(context, 'Please fill all required fields');
      return;
    }
    HapticFeedback.mediumImpact();
    setState(() => _isSubmittingSuggestion = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _isSubmittingSuggestion = false;
      _suggestions.insert(0, {
        'title': _suggestionTitleController.text.trim(),
        'category': _suggestionCategory!,
        'description': _suggestionDescriptionController.text.trim(),
        'date': '03 Jun 2026',
      });
      _suggestionCategory = null;
      _suggestionTitleController.clear();
      _suggestionDescriptionController.clear();
    });
    showAuthSnackBar(context, 'Suggestion submitted successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ProfileAppBar(
        title: 'Feedback & Suggestions',
        showBackButton: widget.showBackButton,
        onSettingsTap: () {},
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFeedbackForm(),
                  const SizedBox(height: 28),
                  _buildSuggestionsForm(),
                  const SizedBox(height: 28),
                  _buildSuggestionsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return _FormCard(
      title: 'Employee Feedback',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDropdown(
            label: 'Feedback Category',
            value: _feedbackCategory,
            items: _feedbackCategories,
            onChanged: (v) => setState(() => _feedbackCategory = v),
          ),
          const SizedBox(height: 16),
          _buildField('Subject', _feedbackSubjectController, 'Enter subject'),
          const SizedBox(height: 16),
          _buildField(
            'Description',
            _feedbackDescriptionController,
            'Share your feedback',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Text(
            'Rating (Optional)',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (i) {
              final star = i + 1;
              return IconButton(
                onPressed: () => setState(() => _rating = star),
                icon: Icon(
                  star <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: star <= _rating
                      ? const Color(0xFFF57C00)
                      : AppColors.grey500,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          GradientButton(
            label: 'Submit Feedback',
            height: 48,
            isLoading: _isSubmittingFeedback,
            onPressed: _submitFeedback,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsForm() {
    return _FormCard(
      title: 'Suggestions & Ideas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDropdown(
            label: 'Category',
            value: _suggestionCategory,
            items: _suggestionCategories,
            onChanged: (v) => setState(() => _suggestionCategory = v),
          ),
          const SizedBox(height: 16),
          _buildField('Title', _suggestionTitleController, 'Suggestion title'),
          const SizedBox(height: 16),
          _buildField(
            'Description',
            _suggestionDescriptionController,
            'Describe your idea',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: 'Submit Suggestion',
            height: 48,
            isLoading: _isSubmittingSuggestion,
            onPressed: _submitSuggestion,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Submitted Suggestions',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ..._suggestions.map(
          (s) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        s['title']!,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.grey300),
                      ),
                      child: Text(
                        s['category']!,
                        style: GoogleFonts.inter(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  s['description']!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.grey700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  s['date']!,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text('Select'),
              items: items
                  .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
