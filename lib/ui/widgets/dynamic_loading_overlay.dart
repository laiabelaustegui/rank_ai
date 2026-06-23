// lib/presentation/widgets/dynamic_loading_overlay.dart
import 'dart:async';
import 'package:flutter/material.dart';

class DynamicLoadingOverlay extends StatefulWidget {
  const DynamicLoadingOverlay({super.key});

  @override
  State<DynamicLoadingOverlay> createState() => _DynamicLoadingOverlayState();
}

class _DynamicLoadingOverlayState extends State<DynamicLoadingOverlay> {
  final List<String> _loadingMessages = [
    'Analyzing your request...',
    'Selecting the best options...',
    'Evaluating criteria and ratings...',
  ];

  int _currentMessageIndex = 0;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    // Rotación de mensajes cada 4 segundos
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 4000), (timer) {
      if (mounted) {
        setState(() {
          _currentMessageIndex =
              (_currentMessageIndex + 1) % _loadingMessages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      // Capa semitransparente para que el Shimmer de fondo se intuya de forma elegante
      color: theme.scaffoldBackgroundColor.withValues(alpha: 0.6),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: Text(
                  _loadingMessages[_currentMessageIndex],
                  key: ValueKey<int>(_currentMessageIndex),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
