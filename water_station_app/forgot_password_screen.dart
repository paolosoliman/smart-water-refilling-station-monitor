import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() =>
    _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email.');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = 'Please enter a valid email.');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = ''; });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      if (mounted) setState(() => _emailSent = true);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.code == 'user-not-found'
          ? 'No account found with this email address.'
          : e.code == 'invalid-email'
            ? 'Please enter a valid email address.'
            : e.code == 'too-many-requests'
              ? 'Too many attempts. Please try again later.'
              : 'Something went wrong. Please try again.';
      });
    } catch (e) {
      setState(() =>
        _errorMessage = 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10),
                    ],
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                    size: 16, color: Color(0xFF0077B6)),
                ),
              ),
              const SizedBox(height: 32),

              if (!_emailSent) ...[
                // Logo
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0077B6).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Icon(Icons.lock_reset,
                      size: 44, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),

                const Center(
                  child: Text('Forgot Password?',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6))),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Enter your registered email and we will send you a password reset link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500)),
                ),
                const SizedBox(height: 32),

                // Email field
                Text('Email Address',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10),
                    ],
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your registered email',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.email_outlined,
                        color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Info box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF0077B6).withOpacity(0.2)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.info_outline,
                      color: Color(0xFF0077B6), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Make sure to use the email you registered with. Check your spam folder if you don\'t see the email.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade700))),
                  ]),
                ),
                const SizedBox(height: 12),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFFFCDD2)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline,
                        color: Color(0xFFE53935), size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage,
                        style: const TextStyle(
                          color: Color(0xFFE53935),
                          fontSize: 12))),
                    ]),
                  ),
                const SizedBox(height: 24),

                // Send button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isLoading ? null : _sendResetEmail,
                    child: _isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send, size: 18),
                            SizedBox(width: 8),
                            Text('Send Reset Link',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                          ],
                        ),
                  ),
                ),
              ] else ...[

                // Success state
                Center(
                  child: Column(children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.mark_email_read_outlined,
                        size: 54,
                        color: Color(0xFF00B894)),
                    ),
                    const SizedBox(height: 24),
                    const Text('Email Sent!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00B894))),
                    const SizedBox(height: 12),
                    Text(
                      'A password reset link has been sent to:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _emailController.text.trim(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0077B6))),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFFE082)),
                      ),
                      child: Column(children: [
                        Row(children: [
                          const Icon(Icons.tips_and_updates,
                            color: Color(0xFFFF9800), size: 16),
                          const SizedBox(width: 8),
                          Text('What to do next:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.orange.shade800)),
                        ]),
                        const SizedBox(height: 8),
                        _StepItem('1', 'Open your email inbox'),
                        _StepItem('2', 'Look for an email from Firebase'),
                        _StepItem('3', 'Check spam/junk folder if not found'),
                        _StepItem('4', 'Click the reset link in the email'),
                        _StepItem('5', 'Set your new password'),
                        _StepItem('6', 'Come back and login with new password'),
                      ]),
                    ),
                    const SizedBox(height: 24),

                    // Resend button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF0077B6)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14),
                        ),
                        onPressed: () =>
                          setState(() => _emailSent = false),
                        child: const Text('Resend Email',
                          style: TextStyle(
                            color: Color(0xFF0077B6),
                            fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Back to login button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0077B6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back to Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String step, text;
  const _StepItem(this.step, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Container(
          width: 20, height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800),
            borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(step,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold))),
        ),
        const SizedBox(width: 8),
        Text(text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange.shade800)),
      ]),
    );
  }
}