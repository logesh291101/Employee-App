import 'dart:async';

import 'package:employee_app/screens/forgot_password/reset_password_screen.dart';
import 'package:employee_app/widgets/auth/auth_page_route.dart';
import 'package:employee_app/widgets/auth/auth_widgets.dart';
import 'package:employee_app/widgets/gradient_button.dart';
import 'package:employee_app/widgets/otp_input_field.dart';
import 'package:employee_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.email,
  });

  final String email;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  static const _demoOtp = '123456';
  static const _initialSeconds = 119;

  final _otpKey = GlobalKey<OtpInputFieldState>();

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  int _remainingSeconds = _initialSeconds;
  bool _isLoading = false;
  bool _isExpired = false;
  String? _otpError;
  String? _successMessage;
  String _otpValue = '';

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
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = _initialSeconds;
    _isExpired = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        setState(() => _isExpired = true);
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  String get _formattedTimer {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _onResendOtp() {
    if (_isLoading) return;
    HapticFeedback.lightImpact();
    _otpKey.currentState?.clear();
    setState(() {
      _otpError = null;
      _successMessage = null;
      _otpValue = '';
    });
    _startTimer();
    showAuthSnackBar(context, 'A new OTP has been sent to your email');
  }

  Future<void> _onVerifyOtp() async {
    HapticFeedback.lightImpact();
    setState(() {
      _otpError = null;
      _successMessage = null;
    });

    if (_otpValue.length < 6) {
      setState(() => _otpError = 'Please enter the complete verification code');
      return;
    }

    if (_isExpired) {
      setState(() => _otpError = 'OTP has expired. Please request a new code.');
      return;
    }

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(seconds: 1500));
    if (!mounted) return;

    if (_otpValue != _demoOtp) {
      setState(() {
        _isLoading = false;
        _otpError = 'Invalid OTP. Please check the code and try again.';
      });
      showAuthSnackBar(context, 'Invalid verification code', isError: true);
      return;
    }

    setState(() {
      _isLoading = false;
      _successMessage = 'OTP verified successfully';
    });
    showAuthSnackBar(context, 'OTP verified successfully');

    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    Navigator.of(context).push(
      authPageRoute(ResetPasswordScreen(email: widget.email)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      fadeAnimation: _fadeAnimation,
      children: [
        AuthFormCard(
          title: 'Verify OTP',
          subtitle: 'Enter the verification code sent to ${widget.email}.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_otpError != null) ...[
                AuthMessageBanner(message: _otpError!, isSuccess: false),
                const SizedBox(height: 16),
              ],
              if (_successMessage != null) ...[
                AuthMessageBanner(message: _successMessage!, isSuccess: true),
                const SizedBox(height: 16),
              ],
              OtpInputField(
                key: _otpKey,
                hasError: _otpError != null,
                onChanged: (value) => setState(() => _otpValue = value),
                onCompleted: (_) => _onVerifyOtp(),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  _isExpired
                      ? 'OTP has expired'
                      : 'OTP expires in $_formattedTimer',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _isExpired ? AppColors.grey700 : AppColors.grey900,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AuthLinkRow(
                prefixText: "Didn't receive the code?",
                linkText: 'Resend OTP',
                onLinkPressed: _onResendOtp,
              ),
              const SizedBox(height: 32),
              GradientButton(
                label: 'Verify OTP',
                isLoading: _isLoading,
                onPressed: _onVerifyOtp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
