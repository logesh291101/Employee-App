import 'package:flutter/material.dart';

Route<T> authPageRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.04, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      );

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: slideAnimation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
