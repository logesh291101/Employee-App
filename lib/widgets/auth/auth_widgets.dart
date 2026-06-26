import 'package:employee_app/core/theme/app_colors.dart';
import 'package:employee_app/widgets/auth/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.width = 120});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'veda_logo',
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
      ),
    );
  }
}

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            title,
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
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          child,
        ],
      ),
    );
  }
}

class AuthLinkRow extends StatelessWidget {
  const AuthLinkRow({
    super.key,
    required this.prefixText,
    required this.linkText,
    required this.onLinkPressed,
  });

  final String prefixText;
  final String linkText;
  final VoidCallback onLinkPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prefixText,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.grey700,
          ),
        ),
        TextButton(
          onPressed: onLinkPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.black,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            linkText,
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

class AuthFlowScaffold extends StatelessWidget {
  const AuthFlowScaffold({
    super.key,
    required this.children,
    this.fadeAnimation,
    this.logoWidth = 120,
  });

  final List<Widget> children;
  final Animation<double>? fadeAnimation;
  final double logoWidth;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 600 ? 48.0 : 20.0;
    final maxContentWidth = screenWidth > 600 ? 480.0 : double.infinity;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxContentWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthLogo(width: logoWidth),
          const SizedBox(height: 28),
          ...children,
        ],
      ),
    );

    if (fadeAnimation != null) {
      content = FadeTransition(opacity: fadeAnimation!, child: content);
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  24 + bottomInset,
                ),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthMessageBanner extends StatelessWidget {
  const AuthMessageBanner({
    super.key,
    required this.message,
    required this.isSuccess,
  });

  final String message;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSuccess
            ? AppColors.grey50
            : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSuccess ? AppColors.grey300 : AppColors.grey500,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle_outline : Icons.error_outline,
            size: 20,
            color: isSuccess ? AppColors.black : AppColors.grey700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.grey900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showAuthSnackBar(BuildContext context, String message, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      backgroundColor: isError ? AppColors.grey900 : AppColors.black,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ),
  );
}
