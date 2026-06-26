import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/login/login_screen.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:employee_app/widgets/password_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _employeeIdController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _hasAttemptedSubmit = false;
  PasswordStrength _passwordStrength = PasswordStrength.none;

  String? _employeeIdError;
  String? _fullNameError;
  String? _emailError;
  String? _mobileError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {
      _passwordStrength =
          evaluatePasswordStrength(_passwordController.text);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _employeeIdController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  void _validateForm() {
    final employeeId = _employeeIdController.text.trim();
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _mobileController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _employeeIdError =
          employeeId.isEmpty ? 'Employee ID is required' : null;
      _fullNameError = fullName.isEmpty ? 'Full name is required' : null;
      _emailError = email.isEmpty
          ? 'Email address is required'
          : !_isValidEmail(email)
              ? 'Please enter a valid email address'
              : null;
      _mobileError = mobile.isEmpty ? 'Mobile number is required' : null;
      _passwordError = password.isEmpty ? 'Password is required' : null;
      _confirmPasswordError = confirmPassword.isEmpty
          ? 'Please confirm your password'
          : password != confirmPassword
              ? 'Passwords do not match'
              : null;
    });
  }

  bool get _isFormValid {
    return _employeeIdError == null &&
        _fullNameError == null &&
        _emailError == null &&
        _mobileError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  Future<void> _onCreateAccount() async {
    setState(() => _hasAttemptedSubmit = true);
    _validateForm();
    if (!_isFormValid) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 48.0 : 20.0;
    final maxContentWidth = screenWidth > 600 ? 480.0 : double.infinity;
    final logoWidth = screenWidth > 600 ? 140.0 : 120.0;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          _buildBackgroundPattern(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  24 + bottomInset,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLogo(logoWidth),
                        const SizedBox(height: 28),
                        _buildFormCard(),
                        const SizedBox(height: 24),
                        _buildSignInPrompt(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _SubtlePatternPainter(),
      ),
    );
  }

  Widget _buildLogo(double width) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/veda_group_logo.png',
            width: width,
            fit: BoxFit.contain,
          ),
        ),
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
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create Account',
            style: GoogleFonts.inter(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Register your employee account to access company services',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          AppTextField(
            controller: _employeeIdController,
            label: 'Employee ID',
            hint: 'Enter your employee ID',
            prefixIcon: Icons.badge_outlined,
            textInputAction: TextInputAction.next,
            errorText: _hasAttemptedSubmit ? _employeeIdError : null,
          ),
          const SizedBox(height: 18),
          AppTextField(
            controller: _fullNameController,
            label: 'Full Name',
            hint: 'Enter your full name',
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            errorText: _hasAttemptedSubmit ? _fullNameError : null,
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
            controller: _passwordController,
            label: 'Password',
            hint: 'Create a password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            errorText: _hasAttemptedSubmit ? _passwordError : null,
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey500,
                size: 22,
              ),
            ),
          ),
          if (_passwordController.text.isNotEmpty) ...[
            const SizedBox(height: 10),
            PasswordStrengthIndicator(strength: _passwordStrength),
          ],
          const SizedBox(height: 18),
          AppTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            errorText: _hasAttemptedSubmit ? _confirmPasswordError : null,
            suffixIcon: IconButton(
              onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey500,
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 32),
          GradientButton(
            label: 'Create Account',
            isLoading: _isLoading,
            onPressed: _onCreateAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildSignInPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.grey700,
          ),
        ),
        TextButton(
          onPressed: _navigateToSignIn,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign In',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class _SubtlePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.grey100.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.08),
      80,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.25),
      60,
      paint..color = AppColors.grey100.withOpacity(0.35),
    );
    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.55),
      100,
      paint..color = AppColors.grey100.withOpacity(0.25),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
