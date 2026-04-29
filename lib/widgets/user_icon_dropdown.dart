import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/awakening/awakening_page.dart';
import '../services/auth_service.dart';

/// Floating user avatar top-right — tapping shows account sheet.
class UserIconDropdown extends StatelessWidget {
  const UserIconDropdown({super.key});

  String _initial(User? user) {
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name.toUpperCase().characters.first;
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) return email.toUpperCase().characters.first;
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild when auth state changes (e.g. after displayName update)
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snap) {
        final user = snap.data ?? FirebaseAuth.instance.currentUser;
        final initial = _initial(user);
        return GestureDetector(
          onTap: () => _showAccountSheet(context, user),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.15),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: GoogleFonts.cinzel(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAccountSheet(BuildContext context, User? user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AccountSheet(user: user),
    );
  }
}

// --- Account sheet ---

class _AccountSheet extends StatefulWidget {
  final User? user;
  const _AccountSheet({required this.user});

  @override
  State<_AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends State<_AccountSheet> {
  String _initial(User? user) {
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name.toUpperCase().characters.first;
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) return email.toUpperCase().characters.first;
    return '?';
  }

  void _openEditProfile(User? u) {
    Navigator.of(context).pop();
    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _EditProfileSheet(user: u),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use userChanges so the sheet reflects fresh displayName
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snap) {
        final u = snap.data ?? widget.user;
        final email = u?.email ?? '';
        final displayName = u?.displayName?.trim();
        final name = (displayName != null && displayName.isNotEmpty)
            ? displayName
            : email.split('@').first;
        final initial = _initial(u);

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF111116),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              // Avatar + user info + settings icon
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                      border: Border.all(color: Colors.white24),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: GoogleFonts.cinzel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.cinzel(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          email,
                          style: GoogleFonts.cinzel(fontSize: 12, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  // Settings icon
                  GestureDetector(
                    onTap: () => _openEditProfile(u),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.settings_outlined, color: Colors.white54, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
              const SizedBox(height: 20),
              // Sign out button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await AuthService().signOut();
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const AwakeningPage(),
                        ),
                        (_) => false,
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFCC2222),
                    side: const BorderSide(color: Color(0xFFCC2222)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    'SIGN OUT',
                    style: GoogleFonts.cinzel(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: const Color(0xFFCC2222),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- Edit profile sheet ---

class _EditProfileSheet extends StatefulWidget {
  final User? user;
  const _EditProfileSheet({required this.user});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _usernameCtrl;
  final TextEditingController _currentPasswordCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  bool _saving = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController(
      text: widget.user?.displayName?.trim() ?? '',
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final username = _usernameCtrl.text.trim();
    final currentPassword = _currentPasswordCtrl.text;
    final newPassword = _newPasswordCtrl.text;
    final confirm = _confirmCtrl.text;

    if (username.isEmpty) {
      setState(() => _error = 'Username cannot be empty.');
      return;
    }
    final changingPassword = currentPassword.isNotEmpty || newPassword.isNotEmpty || confirm.isNotEmpty;
    if (changingPassword) {
      if (currentPassword.isEmpty) {
        setState(() => _error = 'Enter your current password.');
        return;
      }
      if (newPassword.length < 6) {
        setState(() => _error = 'New password must be at least 6 characters.');
        return;
      }
      if (newPassword != confirm) {
        setState(() => _error = 'New passwords do not match.');
        return;
      }
    }

    setState(() { _saving = true; _error = null; _success = null; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Reauthenticate before password change
      if (changingPassword) {
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(cred);
        await user.updatePassword(newPassword);
      }

      // Update display name
      if (username != (user.displayName ?? '')) {
        await user.updateDisplayName(username);
      }

      await user.reload();
      if (mounted) {
        setState(() { _success = 'Profile updated.'; _saving = false; });
        _currentPasswordCtrl.clear();
        _newPasswordCtrl.clear();
        _confirmCtrl.clear();
      }
    } on FirebaseAuthException catch (e) {
      String msg = e.message ?? 'Something went wrong.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        msg = 'Current password is incorrect.';
      }
      if (mounted) setState(() { _error = msg; _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111116),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Edit Profile',
              style: GoogleFonts.cinzel(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Username field
            Text('Username', style: GoogleFonts.spectral(fontSize: 11, color: Colors.white54, letterSpacing: 1)),
            const SizedBox(height: 6),
            _Field(controller: _usernameCtrl, hint: 'Username'),
            const SizedBox(height: 16),
            // Change password section
            Text('Change Password', style: GoogleFonts.spectral(fontSize: 11, color: Colors.white54, letterSpacing: 1)),
            const SizedBox(height: 6),
            _Field(controller: _currentPasswordCtrl, hint: 'Current Password', obscure: true),
            const SizedBox(height: 8),
            _Field(controller: _newPasswordCtrl, hint: 'New Password', obscure: true),
            const SizedBox(height: 8),
            _Field(controller: _confirmCtrl, hint: 'Confirm New Password', obscure: true),
            const SizedBox(height: 16),
            // Error / success
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: GoogleFonts.spectral(fontSize: 12, color: const Color(0xFFCC2222))),
              ),
            if (_success != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_success!, style: GoogleFonts.spectral(fontSize: 12, color: Colors.greenAccent)),
              ),
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5BE3),
                  disabledBackgroundColor: const Color(0xFF2D5BE3).withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        'SAVE',
                        style: GoogleFonts.cinzel(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  const _Field({required this.controller, required this.hint, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.spectral(fontSize: 13, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.spectral(fontSize: 13, color: Colors.white30),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
