import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.fullName,
    required this.email,
    required this.mobile,
    required this.officeLocation,
    required this.address,
  });

  final String fullName;
  final String email;
  final String mobile;
  final String officeLocation;
  final String address;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileController;
  late final TextEditingController _locationController;
  late final TextEditingController _addressController;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  bool _isLoading = false;
  bool _hasAttemptedSubmit = false;
  bool _showSuccess = false;

  String? _nameError;
  String? _emailError;
  String? _mobileError;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _mobileController = TextEditingController(text: widget.mobile);
    _locationController = TextEditingController(text: widget.officeLocation);
    _addressController = TextEditingController(text: widget.address);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _locationController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  bool _isValidMobile(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 10;
  }

  void _validateForm() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final location = _locationController.text.trim();

    setState(() {
      _nameError = name.isEmpty ? 'Full name is required' : null;
      _emailError = email.isEmpty
          ? 'Email address is required'
          : !_isValidEmail(email)
              ? 'Please enter a valid email address'
              : null;
      _mobileError = mobile.isEmpty
          ? 'Mobile number is required'
          : !_isValidMobile(mobile)
              ? 'Please enter a valid mobile number'
              : null;
      _locationError =
          location.isEmpty ? 'Office location is required' : null;
    });
  }

  bool get _isFormValid =>
      _nameError == null &&
      _emailError == null &&
      _mobileError == null &&
      _locationError == null;

  void _onChangePhoto() {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Change Profile Picture',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Image upload is not connected yet. This is a UI preview.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.grey700,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Take Photo'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Choose from Gallery'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onUpdateProfile() async {
    HapticFeedback.mediumImpact();
    setState(() => _hasAttemptedSubmit = true);
    _validateForm();
    if (!_isFormValid) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _showSuccess = true;
    });
    HapticFeedback.mediumImpact();
    showAuthSnackBar(context, 'Profile updated successfully');

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    Navigator.of(context).pop<Map<String, String>>({
      'fullName': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'mobile': _mobileController.text.trim(),
      'officeLocation': _locationController.text.trim(),
      'address': _addressController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return _buildSuccessView();
    }

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
          'Edit Profile',
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
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 24 + bottomInset),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildPhotoSection(),
                    const SizedBox(height: 28),
                    _buildFormCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    final name = _nameController.text.trim();
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _onChangePhoto,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey300, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: AppColors.grey100,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : 'L',
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    size: 18,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TextButton.icon(
            onPressed: _onChangePhoto,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Change Profile Picture'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.grey300.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Contact Details',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 20),
          AppTextField(
            controller: _nameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            errorText: _hasAttemptedSubmit ? _nameError : null,
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _emailController,
            label: 'Email Address',
            hint: 'Enter your email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            errorText: _hasAttemptedSubmit ? _emailError : null,
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _mobileController,
            label: 'Mobile Number',
            hint: 'Enter your mobile number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            errorText: _hasAttemptedSubmit ? _mobileError : null,
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _locationController,
            label: 'Office Location',
            hint: 'Enter your office location',
            prefixIcon: Icons.location_on_outlined,
            textInputAction: TextInputAction.next,
            errorText: _hasAttemptedSubmit ? _locationError : null,
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _addressController,
            label: 'Address (Optional)',
            hint: 'Enter your address',
            prefixIcon: Icons.home_outlined,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 32),
          GradientButton(
            label: 'Update Profile',
            isLoading: _isLoading,
            onPressed: _onUpdateProfile,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.grey50,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey300),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 44,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Profile Updated',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Returning to profile...',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.grey700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
