import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String rawMessage;
  final VoidCallback onActionPressed;

  const ErrorView({
    super.key,
    required this.rawMessage,
    required this.onActionPressed,
  });

  String get _getCustomMessage {
    if (rawMessage.contains('NOT_RANKABLE_ERROR')) {
      return 'The topic requested cannot be processed into a structured ranking. Please try a different or more specific subject.';
    }

    final message = rawMessage.toLowerCase();

    if (message.contains('socketexception') ||
        message.contains('network') ||
        message.contains('timeout') ||
        message.contains('http')) {
      return 'We are having trouble connecting to our servers. Please check your internet connection and try again.';
    }

    if (message.contains('quota') ||
        message.contains('rate limit') ||
        message.contains('429')) {
      return 'Our AI is receiving too many requests right now. Please wait a moment before trying again.';
    }

    return 'An unexpected error occurred while analyzing the topic. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(
                    alpha: 0.2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_motion_outlined,
                  size: 54,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 28),

              Text(
                'Unable to Rank',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              Text(
                _getCustomMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              FilledButton.icon(
                onPressed: onActionPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.search, size: 18),
                label: const Text(
                  'Try Another Topic',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
