import 'package:employee_app/screens/forgot_password/otp_verification_screen.dart';
import 'package:employee_app/screens/login/login_screen.dart';
import 'package:employee_app/widgets/app_text_field.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  bool _isLoading = false;
  bool _hasAttemptedSubmit = false;
  String? _emailError;
  String? _networkError;
  String? _successMessage;

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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      _networkError = null;
      _successMessage = null;
      _emailError = email.isEmpty
          ? 'Email address is required'
          : !_isValidEmail(email)
              ? 'Please enter a valid email address'
              : null;
    });
  }

  Future<void> _onSendOtp() async {
    HapticFeedback.lightImpact();
    setState(() {
      _hasAttemptedSubmit = true;
      _networkError = null;
      _successMessage = null;
    });
    _validateEmail();
    if (_emailError != null) return;

    final email = _emailController.text.trim();

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (email.toLowerCase() == 'error@veda.com') {
      setState(() {
        _isLoading = false;
        _networkError =
            'Unable to connect. Please check your network and try again.';
      });
      showAuthSnackBar(
        context,
        'Network error. Please try again.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = false;
      _successMessage = 'Verification code sent to $email';
    });
    showAuthSnackBar(context, 'OTP sent successfully');

    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    Navigator.of(context).push(
      authPageRoute(
        OtpVerificationScreen(email: email),
      ),
    );
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushAndRemoveUntil(
      authPageRoute(const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      fadeAnimation: _fadeAnimation,
      children: [
        AuthFormCard(
          title: 'Forgot Password?',
          subtitle:
              'Enter your registered email address to receive a verification code.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_networkError != null) ...[
                AuthMessageBanner(
                  message: _networkError!,
                  isSuccess: false,
                ),
                const SizedBox(height: 16),
              ],
              if (_successMessage != null) ...[
                AuthMessageBanner(
                  message: _successMessage!,
                  isSuccess: true,
                ),
                const SizedBox(height: 16),
              ],
              AppTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'Enter your registered email',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                errorText: _hasAttemptedSubmit ? _emailError : null,
                onSubmitted: (_) => _onSendOtp(),
              ),
              const SizedBox(height: 32),
              GradientButton(
                label: 'Send OTP',
                isLoading: _isLoading,
                onPressed: _onSendOtp,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AuthLinkRow(
          prefixText: 'Remember your password?',
          linkText: 'Back to Sign In',
          onLinkPressed: _navigateToSignIn,
        ),
      ],
    );
  }
}
