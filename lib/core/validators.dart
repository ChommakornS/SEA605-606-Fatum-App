// lib/core/validators.dart
//
// Pure-Dart validation helpers extracted from production pages.
// Having logic here (instead of inline in widgets) lets unit tests
// test the REAL validation rules without spinning up a Flutter engine.
//
// Pages that use these:
//   lib/pages/awakening/awakening_page.dart   → emailValidator, passwordValidator
//   lib/pages/edit_post/edit_post_page.dart   → canSaveReflection

// ─────────────────────────────────────────────────────────────────────────────
// Edit Post — reflectionText
//   Source rule: _save() checks text.isEmpty; TextField has maxLength: 500
// ─────────────────────────────────────────────────────────────────────────────

/// Returns true when [text] (after trim) is non-empty and ≤ 500 characters.
/// Mirrors the Save-button gate in _EditPostPageState._save().
bool canSaveReflection(String text) {
  final t = text.trim();
  return t.isNotEmpty && t.length <= 500;
}

// ─────────────────────────────────────────────────────────────────────────────
// Awakening — email field
//   Source rule: validator inside _buildFields() in _AwakeningPageState
//     if (v == null || v.isEmpty) return 'Email is required';
//     if (!v.contains('@'))       return 'Enter a valid email';
// ─────────────────────────────────────────────────────────────────────────────

/// Returns null (valid) or an error message string.
/// Mirrors the email TextFormField validator in AwakeningPage.
String? emailValidator(String? v) {
  if (v == null || v.isEmpty) return 'Email is required';
  if (!v.contains('@')) return 'Enter a valid email';
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// Awakening — password field
//   Source rule:
//     if (v == null || v.isEmpty) return 'Password is required';
//     if (v.length < 6)           return 'At least 6 characters';
// ─────────────────────────────────────────────────────────────────────────────

/// Returns null (valid) or an error message string.
/// Mirrors the password TextFormField validator in AwakeningPage.
String? passwordValidator(String? v) {
  if (v == null || v.isEmpty) return 'Password is required';
  if (v.length < 6) return 'At least 6 characters';
  return null;
}