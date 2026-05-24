import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../core/shell_page.dart';
import '../../core/validators.dart';

class AwakeningPage extends StatefulWidget {
  const AwakeningPage({super.key});

  @override
  State<AwakeningPage> createState() => _AwakeningPageState();
}

class _AwakeningPageState extends State<AwakeningPage> {
  bool _isLogin = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _loading = false;
  String? _errorMessage;

  final _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    setState(() {
      _isLogin = index == 0;
      _errorMessage = null;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      if (_isLogin) {
        await _authService.signInWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        await _authService.registerWithEmail(
          _emailController.text.trim(),
          _passwordController.text,
          username: _usernameController.text.trim(),
        );
      }
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ShellPage()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ShellPage()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = _parseError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Enter your email above first.');
      return;
    }
    try {
      await _authService.sendPasswordReset(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent.')),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = _parseError(e));
    }
  }

  String _parseError(Object e) {
    final msg = e.toString();
    
    // ✅ User cancelled Google sign-in — show nothing
    if (msg.contains('sign_in_canceled') || msg.contains('canceled')) return '';
    if (msg.contains('popup-closed-by-user') || msg.contains('popup_closed')) return '';

    if (msg.contains('user-not-found') || msg.contains('wrong-password') || msg.contains('invalid-credential')) {
      return 'Invalid email or password.';
    }
    if (msg.contains('email-already-in-use')) return 'This email is already registered.';
    if (msg.contains('weak-password')) return 'Password must be at least 6 characters.';
    if (msg.contains('invalid-email')) return 'Please enter a valid email.';
    if (msg.contains('network-request-failed')) return 'Network error. Check your connection.';
    return 'Something went wrong. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C1A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/signin_signup_bg.png',
              fit: BoxFit.cover,
              
            ),
          ),
          SafeArea(
          child: Center(
          child: SizedBox(
            width: 480,
            child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Text(
                      'FATUM',
                      style: GoogleFonts.kaiseiTokumin(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'The blood moon reveals what fate has sealed',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.pinyonScript(fontSize: 20, color: Colors.white),
                    ),
                    const SizedBox(height: 32),
                    _TabSelector(
                      labels: const ['Awakening', 'Rebirth'],
                      selectedIndex: _isLogin ? 0 : 1,
                      onSelect: _switchTab,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF161820),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFields(),
                            if (_errorMessage != null && _errorMessage!.isNotEmpty) ...[ //fix
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                style: GoogleFonts.spectral(
                                  color: AppColors.bloodRedLight,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2D5BE3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        'Enter the Darkness',
                                        style: GoogleFonts.cinzel(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Expanded(child: Divider(color: Colors.white24)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    'or',
                                    style: GoogleFonts.cinzel(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider(color: Colors.white24)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: OutlinedButton.icon(
                                onPressed: _loading ? null : _googleSignIn,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white24),
                                  backgroundColor: const Color(0xFF1A1D26),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const _GoogleIcon(),
                                label: Text(
                                  'Continue with Google',
                                  style: GoogleFonts.cinzel(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Email', style: GoogleFonts.spectral(fontSize: 12, color: Colors.white54)),
        const SizedBox(height: 6),
        _GothicTextField(
          controller: _emailController,
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          // validator: (v) {
          //   if (v == null || v.isEmpty) return 'Email is required';
          //   if (!v.contains('@')) return 'Enter a valid email';
          //   return null;
          // },
          validator: emailValidator,
        ),
        const SizedBox(height: 16),
        Text('Password', style: GoogleFonts.spectral(fontSize: 12, color: Colors.white54)),
        const SizedBox(height: 6),
        _GothicTextField(
          controller: _passwordController,
          hint: 'Enter your password',
          obscure: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: Colors.white54,
              size: 20,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password is required';
            if (v.length < 6) return 'At least 6 characters';
            return null;
          },
        ),
        if (_isLogin) ...[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _forgotPassword,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                'Forgot password?',
                style: GoogleFonts.spectral(fontSize: 12, color: Colors.white60),
              ),
            ),
          ),
        ],
        if (!_isLogin) ...[
          const SizedBox(height: 16),
          Text('Confirm Password', style: GoogleFonts.spectral(fontSize: 12, color: Colors.white54)),
          const SizedBox(height: 6),
          _GothicTextField(
            controller: _confirmController,
            hint: 'Confirm Your Password',
            obscure: true,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please confirm your password';
              if (v != _passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text('Username', style: GoogleFonts.spectral(fontSize: 12, color: Colors.white54)),
          const SizedBox(height: 6),
          _GothicTextField(
            controller: _usernameController,
            hint: 'Your name in The Coven',
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Username is required';
              return null;
            },
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

// --- Tab selector ---

class _TabSelector extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final void Function(int) onSelect;

  const _TabSelector({
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? const Color(0x331A4FFF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected ? Colors.white : Colors.white54,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// --- Gothic text field ---

class _GothicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _GothicTextField({
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.spectral(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.spectral(fontSize: 14, color: Colors.white38),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.4)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCC2222)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCC2222)),
        ),
        errorStyle: GoogleFonts.spectral(fontSize: 11, color: const Color(0xFFCC2222)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}

// Google icon (CustomPainter — no network dependency)
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 20, height: 20, child: CustomPaint(painter: _GooglePainter()));
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = rect.center;
    final radius = size.width / 2;
    final segments = [
      (0.0, 90.0, const Color(0xFF4285F4)),
      (90.0, 90.0, const Color(0xFF34A853)),
      (180.0, 90.0, const Color(0xFFFBBC05)),
      (270.0, 90.0, const Color(0xFFEA4335)),
    ];
    for (final (start, sweep, color) in segments) {
      final paint = Paint()..color = color..style = PaintingStyle.fill;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(rect, start * 3.14159 / 180, sweep * 3.14159 / 180, false)
        ..close();
      canvas.drawPath(path, paint);
    }
    canvas.drawCircle(center, radius * 0.55, Paint()..color = const Color(0xFF1A1D26));
    canvas.drawRect(
      Rect.fromLTWH(center.dx, center.dy - radius * 0.2, radius, radius * 0.4),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
