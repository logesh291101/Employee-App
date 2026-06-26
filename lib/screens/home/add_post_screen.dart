import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _captionController = TextEditingController();
  final _tagController = TextEditingController();

  String? _mediaType;
  bool _isPosting = false;
  String? _captionError;
  String? _mediaError;

  static const _previewAsset = 'assets/images/veda_group_logo.png';

  @override
  void dispose() {
    _captionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _selectImage() {
    HapticFeedback.selectionClick();
    setState(() {
      _mediaType = 'image';
      _mediaError = null;
    });
  }

  void _selectVideo() {
    HapticFeedback.selectionClick();
    setState(() {
      _mediaType = 'video';
      _mediaError = null;
    });
  }

  bool _validate() {
    var valid = true;
    setState(() {
      _captionError = _captionController.text.trim().isEmpty
          ? 'Caption is required'
          : null;
      _mediaError =
          _mediaType == null ? 'Please select an image or video' : null;

      if (_captionError != null || _mediaError != null) {
        valid = false;
      }
    });
    return valid;
  }

  Future<void> _submitPost() async {
    if (!_validate()) {
      HapticFeedback.heavyImpact();
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isPosting = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() => _isPosting = false);
    showAuthSnackBar(context, 'Post added successfully.');
    Navigator.of(context).pop<Map<String, dynamic>>({
      'caption': _captionController.text.trim(),
      'tag': _tagController.text.trim(),
      'mediaType': _mediaType,
      'imageAsset': _previewAsset,
      'createdAt': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.black,
        ),
        title: Text(
          'Add Post',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Upload',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _UploadOptionCard(
                                icon: Icons.image_outlined,
                                label: 'Image',
                                isSelected: _mediaType == 'image',
                                onTap: _selectImage,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _UploadOptionCard(
                                icon: Icons.videocam_outlined,
                                label: 'Video',
                                isSelected: _mediaType == 'video',
                                onTap: _selectVideo,
                              ),
                            ),
                          ],
                        ),
                        if (_mediaError != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _mediaError!,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        if (_mediaType != null) ...[
                          const SizedBox(height: 16),
                          _buildMediaPreview(),
                        ],
                        const SizedBox(height: 28),
                        Text(
                          'Post Details',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _captionController,
                          label: 'Caption',
                          hint: 'Write a caption for your post',
                          prefixIcon: Icons.notes_outlined,
                          textInputAction: TextInputAction.next,
                          errorText: _captionError,
                          onChanged: (_) {
                            if (_captionError != null) {
                              setState(() => _captionError = null);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _tagController,
                          label: 'Tag',
                          hint: 'Add a tag (optional)',
                          prefixIcon: Icons.tag_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: GradientButton(
                    label: 'Post',
                    isLoading: _isPosting,
                    onPressed: _submitPost,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    final isVideo = _mediaType == 'video';

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _previewAsset,
            fit: BoxFit.cover,
            color: isVideo ? AppColors.black.withOpacity(0.35) : null,
            colorBlendMode: isVideo ? BlendMode.darken : null,
          ),
          if (isVideo)
            Center(
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  size: 30,
                  color: AppColors.black,
                ),
              ),
            ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isVideo ? 'Video selected' : 'Image selected',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadOptionCard extends StatelessWidget {
  const _UploadOptionCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.black : AppColors.grey300,
              width: isSelected ? 1.5 : 1,
            ),
            color: isSelected ? AppColors.grey50 : AppColors.white,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 28,
                color: isSelected ? AppColors.black : AppColors.grey700,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.black : AppColors.grey700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
