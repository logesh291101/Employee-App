import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/screens/login/login_screen.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:employee_app/widgets/password_strength_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with TickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _successController;
  late final Animation<double> _successScale;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _hasAttemptedSubmit = false;
  bool _showSuccess = false;
  PasswordStrength _passwordStrength = PasswordStrength.none;

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
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale = CurvedAnimation(
      parent: _successController,
      curve: Curves.elasticOut,
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
    _successController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _hasMinComplexity(String password) {
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  void _validateForm() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _passwordError = password.isEmpty
          ? 'Password is required'
          : password.length < 8
              ? 'Password must be at least 8 characters'
              : !_hasMinComplexity(password)
                  ? 'Include uppercase letters and numbers'
                  : null;
      _confirmPasswordError = confirmPassword.isEmpty
          ? 'Please confirm your password'
          : password != confirmPassword
              ? 'Passwords do not match'
              : null;
    });
  }

  bool get _isFormValid =>
      _passwordError == null && _confirmPasswordError == null;

  Future<void> _onResetPassword() async {
    HapticFeedback.lightImpact();
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
    _successController.forward();
    HapticFeedback.mediumImpact();
    showAuthSnackBar(context, 'Password reset successfully');

    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      authPageRoute(const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return _buildSuccessView();
    }

    return AuthFlowScaffold(
      fadeAnimation: _fadeAnimation,
      children: [
        AuthFormCard(
          title: 'Create New Password',
          subtitle:
              'Your new password must be different from previously used passwords.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _passwordController,
                label: 'New Password',
                hint: 'Enter your new password',
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
                hint: 'Re-enter your new password',
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
                label: 'Reset Password',
                isLoading: _isLoading,
                onPressed: _onResetPassword,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            child: Center(
              child: ScaleTransition(
                scale: _successScale,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: AppColors.grey50,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.grey300),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 48,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Password Reset Successfully',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.black,
                          letterSpacing: -0.3,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You can now sign in with your new password.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.grey700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Redirecting to Sign In...',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
