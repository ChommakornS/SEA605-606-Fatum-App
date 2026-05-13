# FATUM

**FATUM** is a gothic-themed tarot reading app built with Flutter. It lets users draw cards, receive prophecies, seal readings into a personal diary, and share insights with a community called The Coven.
Link: https://fatum-371c1--pr-11-f7cot55z.web.app/
---

## Features

### Reading
- Pick a topic (Love, Career, Health, Finance, Study, Life Path)
- Choose 3 cards from a 22-card Major Arcana deck
- Cards spin and reveal with animation
- Each card delivers a prophecy based on topic and orientation (upright / reversed)

### Blood Diary
- Seal readings locally using Hive for offline persistence
- Filter entries by topic and date range
- View full prophecy text per card position (Past · Present · Future)

### The Coven
- Share readings and personal reflections to a community feed (Firestore)
- React to others' prophecies
- Filter posts by topic or view your own posts
- Edit or delete your own posts

### Auth
- Email/password sign-in and registration
- Google Sign-In
- Password reset via email

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Local Storage | Hive |
| Hosting | Firebase Hosting |
| Fonts | Google Fonts (Cormorant Garamond, Roboto Mono) |

---

## Project Structure

```
lib/
├── core/           # Shell, router
├── data/           # Tarot deck data & prophecy texts
├── models/         # Data models (TarotCard, DiaryEntry, CovenPost)
├── pages/
│   ├── awakening/  # Auth (sign in / register)
│   ├── reading/    # Topic picker, card grid, spin reveal
│   ├── diary/      # Blood diary
│   ├── coven/      # Community feed & inscribe sheet
│   └── edit_post/  # Edit / delete post
├── services/       # AuthService, FirestoreService, DiaryService
├── theme/          # App colors
└── ui/
    ├── atoms/      # Primitive widgets (buttons, fields, badges)
    ├── molecules/  # Composite widgets (card stack, dropdowns, tabs)
    └── templates/  # Layout wrappers (web-centered layout)
```

---

## Getting Started

### Prerequisites
- Flutter SDK
- Firebase project with Authentication and Firestore enabled
- `lib/firebase_options.dart` (generated via `flutterfire configure`, gitignored)

### Run

```bash
flutter pub get
flutter run
```

### Web

```bash
flutter run -d chrome
```

---

## CI / CD
Pull requests from feature branches to `main` trigger a Firebase Hosting preview deploy via GitHub Actions.
