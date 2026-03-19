import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }
    if (_passwordController.text.length < 6) {
      setState(() => _errorMessage =
        'Password must be at least 6 characters.');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = ''; });
    try {
      final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      await credential.user?.updateDisplayName(
        _nameController.text.trim());
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70, height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: const Icon(Icons.check_circle,
                    color: Color(0xFF00B894), size: 40),
                ),
                const SizedBox(height: 16),
                const Text('Account Created!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0077B6))),
                const SizedBox(height: 8),
                Text(
                  'Your account has been successfully created. Please log in to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen()),
                        (route) => false);
                    },
                    child: const Text('Go to Login',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.code == 'email-already-in-use'
          ? 'This email is already registered.'
          : e.code == 'invalid-email'
            ? 'Invalid email address.'
            : e.code == 'weak-password'
              ? 'Password is too weak.'
              : 'Sign up failed. Please try again.';
      });
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
              const SizedBox(height: 10),

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
              const SizedBox(height: 20),

              // Logo and title — same style as login
              Center(
                child: Column(children: [
                  Container(
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
                    child: const Icon(Icons.water_drop,
                      size: 44, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text('AquaMonitor',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6))),
                  const SizedBox(height: 6),
                  Text('Create your account',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500)),
                ]),
              ),
              const SizedBox(height: 28),

              // Name field
              _buildLabel('Full Name'),
              _buildTextField(
                controller: _nameController,
                hint: 'Enter your full name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              // Email field
              _buildLabel('Email'),
              _buildTextField(
                controller: _emailController,
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password field
              _buildLabel('Password'),
              _buildTextField(
                controller: _passwordController,
                hint: 'At least 6 characters',
                icon: Icons.lock_outline,
                obscure: _obscurePassword,
                onToggle: () => setState(
                  () => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: 16),

              // Confirm password field
              _buildLabel('Confirm Password'),
              _buildTextField(
                controller: _confirmPasswordController,
                hint: 'Re-enter your password',
                icon: Icons.lock_outline,
                obscure: _obscureConfirm,
                onToggle: () => setState(
                  () => _obscureConfirm = !_obscureConfirm),
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

              // Sign up button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _isLoading ? null : _signup,
                  child: _isLoading
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                    : const Text('Create Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),

              // Login link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text('Sign In',
                        style: TextStyle(
                          color: Color(0xFF0077B6),
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    VoidCallback? onToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
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
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: Colors.grey.shade400),
          suffixIcon: onToggle != null
            ? IconButton(
                icon: Icon(
                  obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                  color: Colors.grey.shade400),
                onPressed: onToggle)
            : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}