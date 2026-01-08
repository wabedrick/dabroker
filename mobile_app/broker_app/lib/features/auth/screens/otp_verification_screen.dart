import 'package:broker_app/core/theme/app_theme.dart';
import 'package:broker_app/core/widgets/skeleton_box.dart';
import 'package:broker_app/features/home/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import 'login_screen.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String identifier;
  final String purpose;

  const OtpVerificationScreen({
    super.key,
    required this.identifier,
    required this.purpose,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isResending = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _otpCode {
    return _otpControllers.map((c) => c.text).join();
  }

  Future<void> _handleVerify() async {
    if (_otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter complete OTP code'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final success = await ref
        .read(authStateProvider.notifier)
        .verifyOtp(
          identifier: widget.identifier,
          otp: _otpCode,
          purpose: widget.purpose,
        );

    if (!mounted) return;

    if (success) {
      // Navigate to home or login
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => widget.purpose == 'registration'
              ? const LoginScreen()
              : const MainScreen(),
        ),
        (route) => false,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Verification successful!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      final error = ref.read(authStateProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Verification failed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _handleResend() async {
    if (_isResending) return;
    setState(() {
      _isResending = true;
    });

    final success = await ref
        .read(authStateProvider.notifier)
        .resendOtp(identifier: widget.identifier, purpose: widget.purpose);

    if (!mounted) return;

    setState(() {
      _isResending = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('A new OTP has been sent.'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      final error = ref.read(authStateProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Unable to resend OTP'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Widget _buildOtpField(int index) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          // Auto-verify when all fields are filled
          if (index == 5 && value.isNotEmpty) {
            _handleVerify();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final showSkeleton = authState.isLoading;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Back Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: showSkeleton
                    ? const KeyedSubtree(
                        key: ValueKey('otp_skeleton'),
                        child: _OtpSkeleton(),
                      )
                    : KeyedSubtree(
                        key: const ValueKey('otp_form'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32),
                            // Illustration
                            Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.lock_outline,
                                  size: 60,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Title
                            Text(
                              'Verify OTP',
                              style: Theme.of(context).textTheme.displayMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Enter the 6-digit code sent to\n${widget.identifier}',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),
                            // OTP Fields
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                6,
                                (index) => _buildOtpField(index),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Verify Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : _handleVerify,
                                child: authState.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text('Verify OTP'),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Resend OTP
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't receive the code? ",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: _isResending
                                      ? null
                                      : _handleResend,
                                  child: _isResending
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text('Resend'),
                                ),
                              ],
                            ),
                          ],
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

class _OtpSkeleton extends StatelessWidget {
  const _OtpSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Center(child: SkeletonBox(width: 120, height: 120, borderRadius: 60)),
        const SizedBox(height: 32),
        const SkeletonBox(width: 160, height: 28),
        const SizedBox(height: 12),
        const SkeletonBox(width: 220, height: 18),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (_) => SkeletonBox(width: 46, height: 56, borderRadius: 14),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, child: SkeletonBox(height: 56)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SkeletonBox(width: 150, height: 16),
            SizedBox(width: 8),
            SkeletonBox(width: 70, height: 16),
          ],
        ),
      ],
    );
  }
}
