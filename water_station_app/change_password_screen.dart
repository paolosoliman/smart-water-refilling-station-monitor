import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  String _errorMessage = '';
  bool _success = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'New passwords do not match.');
      return;
    }
    if (_newPasswordController.text.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters.');
      return;
    }
    setState(() { _isLoading = true; _errorMessage = ''; });
    try {
      final user = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text.trim(),
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(_newPasswordController.text.trim());
      setState(() => _success = true);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.code == 'wrong-password'
          ? 'Current password is incorrect.'
          : e.code == 'weak-password'
            ? 'New password is too weak.'
            : 'Failed to change password. Try again.';
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

              if (!_success) ...[
                // Icon
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.lock_outline,
                      size: 44, color: Color(0xFF0077B6)),
                  ),
                ),
                const SizedBox(height: 24),

                const Center(
                  child: Text('Change Password',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6))),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Enter your current password and choose a new one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500)),
                ),
                const SizedBox(height: 32),

                // Current password
                _buildLabel('Current Password'),
                _buildTextField(
                  controller: _currentPasswordController,
                  hint: 'Enter current password',
                  icon: Icons.lock_outline,
                  obscure: _obscureCurrent,
                  onToggle: () => setState(
                    () => _obscureCurrent = !_obscureCurrent),
                ),
                const SizedBox(height: 16),

                // New password
                _buildLabel('New Password'),
                _buildTextField(
                  controller: _newPasswordController,
                  hint: 'At least 6 characters',
                  icon: Icons.lock_outline,
                  obscure: _obscureNew,
                  onToggle: () => setState(
                    () => _obscureNew = !_obscureNew),
                ),
                const SizedBox(height: 16),

                // Confirm new password
                _buildLabel('Confirm New Password'),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hint: 'Re-enter new password',
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
                      border: Border.all(color: const Color(0xFFFFCDD2)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.error_outline,
                        color: Color(0xFFE53935), size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_errorMessage,
                        style: const TextStyle(
                          color: Color(0xFFE53935), fontSize: 12))),
                    ]),
                  ),
                const SizedBox(height: 24),

                // Change button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isLoading ? null : _changePassword,
                    child: _isLoading
                      ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                      : const Text('Change Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
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
                      child: const Icon(Icons.check_circle_outline,
                        size: 54, color: Color(0xFF00B894)),
                    ),
                    const SizedBox(height: 24),
                    const Text('Password Changed!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00B894))),
                    const SizedBox(height: 12),
                    Text(
                      'Your password has been successfully updated.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500)),
                    const SizedBox(height: 40),
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
                        child: const Text('Go Back',
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