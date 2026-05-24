// test/unit/bva_validation_test.dart
//
// Black-Box Test Cases — Boundary Value Analysis (BVA) & Equivalence Partitioning (EP)

import 'package:flutter_test/flutter_test.dart';
import 'package:fatum/core/validators.dart'; // ← production code

// ─────────────────────────────────────────────────────────────────────────────
// Helper
// ─────────────────────────────────────────────────────────────────────────────

/// Generates a string of exactly [n] characters (repeating 'A').
String strOf(int n) => 'A' * n;

// ─────────────────────────────────────────────────────────────────────────────
void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // [A] Edit Post — reflectionText
  //
  //  Rule (from _EditPostPageState._save() + TextField maxLength):
  //    • text.trim().isEmpty  → blocked   ("Reflection cannot be empty...")
  //    • length > 500         → blocked   (maxLength: 500 on TextField)
  //    • 1 ≤ length ≤ 500    → allowed
  //
  //  Partitions:
  //    Invalid lower : length = 0           (empty / whitespace-only)
  //    Valid         : 1 ≤ length ≤ 500
  //    Invalid upper : length > 500
  // ═══════════════════════════════════════════════════════════════════════════
  group('[A] reflectionText — canSaveReflection() BVA (1–500 chars)', () {

    // ── EP: Valid partition ─────────────────────────────────────────────────
    test('BVA-A1 [EP_VALID] Typical post (53 chars) → can save', () {
      const input = 'The blood moon revealed my path through the darkness.';
      expect(canSaveReflection(input), isTrue);
    });

    // ── BVA: Lower boundary ─────────────────────────────────────────────────
    test('BVA-A2 [MIN] 1 character → can save', () {
      expect(canSaveReflection(strOf(1)), isTrue);
    });

    test('BVA-A3 [MIN-1] Empty string (0 chars) → cannot save', () {
      // This is exactly what UT-09 already covers; listed here for BVA completeness.
      expect(canSaveReflection(''), isFalse);
    });

    test('BVA-A4 [MIN-1 whitespace] Spaces-only → cannot save (trim blocks it)', () {
      expect(canSaveReflection('   '), isFalse);
    });

    test('BVA-A5 [MIN+1] 2 characters → can save', () {
      expect(canSaveReflection(strOf(2)), isTrue);
    });

    // ── BVA: Upper boundary ─────────────────────────────────────────────────
    test('BVA-A6 [MAX-1] 499 characters → can save', () {
      expect(canSaveReflection(strOf(499)), isTrue);
    });

    test('BVA-A7 [MAX] 500 characters → can save', () {
      expect(canSaveReflection(strOf(500)), isTrue);
    });

    test('BVA-A8 [MAX+1] 501 characters → cannot save', () {
      // TextField has maxLength: 500 so the user cannot type beyond 500,
      // but this test guards the underlying logic directly.
      expect(canSaveReflection(strOf(501)), isFalse);
    });

    // ── EP: Far outside valid partition ─────────────────────────────────────
    test('BVA-A9 [EP_INVALID] 1000 characters → cannot save', () {
      expect(canSaveReflection(strOf(1000)), isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // [B] Awakening — Email Field
  //
  //  Rule (from _AwakeningPageState._buildFields() validator):
  //    • null or empty       → 'Email is required'
  //    • does not contain @  → 'Enter a valid email'
  //    • otherwise           → null  (valid)
  //
  //  Partitions:
  //    Invalid : empty, no @, null
  //    Valid   : anything with @ present
  // ═══════════════════════════════════════════════════════════════════════════
  group('[B] Awakening email — emailValidator() EP', () {

    // ── EP: Valid ────────────────────────────────────────────────────────────
    test('BVA-B1 [EP_VALID] Standard email → no error', () {
      expect(emailValidator('chommakorn@fatum.app'), isNull);
    });

    test('BVA-B2 [EP_VALID] Email with dots and subdomain → no error', () {
      expect(emailValidator('user.name@student.tu.ac.th'), isNull);
    });

    test('BVA-B3 [EP_VALID] Numeric local part → no error', () {
      expect(emailValidator('68130702313@student.tu.ac.th'), isNull);
    });

    // ── EP: Invalid — empty ──────────────────────────────────────────────────
    test('BVA-B4 [EP_INVALID] Empty string → "Email is required"', () {
      expect(emailValidator(''), equals('Email is required'));
    });

    test('BVA-B5 [EP_INVALID] Null value → "Email is required"', () {
      expect(emailValidator(null), equals('Email is required'));
    });

    // ── EP: Invalid — missing @ ──────────────────────────────────────────────
    test('BVA-B6 [EP_INVALID] No @ symbol → "Enter a valid email"', () {
      expect(emailValidator('userexample.com'), equals('Enter a valid email'));
    });

    test('BVA-B7 [EP_INVALID] Only a domain, no @ → "Enter a valid email"', () {
      expect(emailValidator('example.com'), equals('Enter a valid email'));
    });

    test('BVA-B8 [EP_INVALID] Plain text no @ → "Enter a valid email"', () {
      expect(emailValidator('notanemail'), equals('Enter a valid email'));
    });

    // ── Edge: @ present but degenerate ───────────────────────────────────────
    test('BVA-B9 [EDGE] Only @ character → no error (rule only checks contains)', () {
      // Production rule is !v.contains('@') — bare "@" passes the contains check.
      // This test documents the current contract (not ideal, but real behaviour).
      expect(emailValidator('@'), isNull,
          reason: '"@" contains @ so validator returns null per current rule');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // [C] Awakening — Password Field
  //
  //  Rule (from _AwakeningPageState._buildFields() validator):
  //    • null or empty    → 'Password is required'
  //    • length < 6       → 'At least 6 characters'
  //    • length >= 6      → null  (valid)
  //
  //  Partitions:
  //    Invalid lower : length = 0  (empty)
  //    Invalid lower : 1 <= length <= 5
  //    Valid         : length >= 6
  // ═══════════════════════════════════════════════════════════════════════════
  group('[C] Awakening password — passwordValidator() BVA (min 6 chars)', () {

    // ── EP: Valid ────────────────────────────────────────────────────────────
    test('BVA-C1 [EP_VALID] Strong password (12 chars) → no error', () {
      expect(passwordValidator('Fatum@2024!!'), isNull);
    });

    // ── BVA: Lower boundary ─────────────────────────────────────────────────
    test('BVA-C2 [MIN] Exactly 6 characters → no error', () {
      expect(passwordValidator('abcdef'), isNull);
    });

    test('BVA-C3 [MIN-1] Exactly 5 characters → "At least 6 characters"', () {
      expect(passwordValidator('abcde'), equals('At least 6 characters'));
    });

    test('BVA-C4 [MIN+1] Exactly 7 characters → no error', () {
      expect(passwordValidator('abcdefg'), isNull);
    });

    // ── EP: Invalid — empty ──────────────────────────────────────────────────
    test('BVA-C5 [EP_INVALID] Empty string → "Password is required"', () {
      expect(passwordValidator(''), equals('Password is required'));
    });

    test('BVA-C6 [EP_INVALID] Null → "Password is required"', () {
      expect(passwordValidator(null), equals('Password is required'));
    });

    // ── EP: Invalid — too short ──────────────────────────────────────────────
    test('BVA-C7 [EP_INVALID] 1 character → "At least 6 characters"', () {
      expect(passwordValidator('a'), equals('At least 6 characters'));
    });

    test('BVA-C8 [EP_INVALID] 3 characters → "At least 6 characters"', () {
      expect(passwordValidator('abc'), equals('At least 6 characters'));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // [D] Regression sweep — all boundaries in one shot
  // ═══════════════════════════════════════════════════════════════════════════
  group('[D] Regression — all boundary values in one sweep', () {
    test('reflectionText boundary sweep', () {
      expect(canSaveReflection(''),         isFalse); // BVA-A3 MIN-1
      expect(canSaveReflection('   '),      isFalse); // BVA-A4 whitespace
      expect(canSaveReflection(strOf(1)),   isTrue);  // BVA-A2 MIN
      expect(canSaveReflection(strOf(2)),   isTrue);  // BVA-A5 MIN+1
      expect(canSaveReflection(strOf(499)), isTrue);  // BVA-A6 MAX-1
      expect(canSaveReflection(strOf(500)), isTrue);  // BVA-A7 MAX
      expect(canSaveReflection(strOf(501)), isFalse); // BVA-A8 MAX+1
    });

    test('email partition sweep', () {
      expect(emailValidator('user@example.com'), isNull);
      expect(emailValidator(''),   equals('Email is required'));
      expect(emailValidator(null), equals('Email is required'));
      expect(emailValidator('nodomain'), equals('Enter a valid email'));
    });

    test('password boundary sweep', () {
      expect(passwordValidator(null),      equals('Password is required'));
      expect(passwordValidator(''),        equals('Password is required'));
      expect(passwordValidator('abcde'),   equals('At least 6 characters'));
      expect(passwordValidator('abcdef'),  isNull);
      expect(passwordValidator('abcdefg'), isNull);
    });
  });
}