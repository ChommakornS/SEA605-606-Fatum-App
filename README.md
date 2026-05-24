# FATUM  
*A gothic tarot experience forged in Flutter.*

🌑 **Live Preview (Deployed App):**  
[FATUM Web App](https://fatum-371c1--pr-11-f7cot55z.web.app/?utm_source=chatgpt.com)

> ⚠️ Link will expire on **20 May 2026**

---

## 🩸 Inspiration

FATUM was heavily inspired by ENHYPEN's **DARK BLOOD** concept and atmosphere — combining gothic aesthetics, fate, blood, prophecy, and dark fantasy storytelling into an interactive tarot experience.

🎵 Inspiration Reference:  
[ENHYPEN – DARK BLOOD Concept Video](https://www.youtube.com/watch?v=47SAocGDKrw&list=RD47SAocGDKrw&start_radio=1&pp=ygUSZW5oeXBlbiBkYXJrIGJsb29koAcB&utm_source=chatgpt.com)

---

## ✨ Overview

**FATUM** is a gothic-themed tarot reading application built with Flutter.  
Users can perform mystical readings, preserve prophecies inside a personal **Blood Moon Diary**, and share revelations with a social community known as **The Coven**.

The experience combines animated tarot interactions, offline persistence, Firebase-powered social features, and dark atmospheric UI design.

---

# 🩸 Visual Showcase

## 🌑 Mood Board

![FATUM Mood Board](assets/readme/moodboard.png)

> The visual identity of FATUM draws from gothic romance, blood rituals, cathedral architecture, tarot symbolism, moonlit atmospheres, and the DARK BLOOD aesthetic.

---

## 🔮 App Screenshots

| | | |
|---|---|---|
| ![Log In](assets/readme/1.png) | ![Blood Mood Reading Main](assets/readme/2.png) | ![Awaiting the Reading](assets/readme/3.png) |
| ![Card Selection](assets/readme/4.png) | ![Fate Revealed](assets/readme/5.png) | ![Write to The Coven](assets/readme/6.png) |
| ![The Coven Feed](assets/readme/7.png) | ![Edit the Prophecy](assets/readme/8.png) | ![Blood Moon Diary](assets/readme/9.png) |

### Featured Screens
1. Log In  
2. Blood Mood Reading — Main Page  
3. Blood Mood Reading — Awaiting Ritual  
4. Tarot Card Selection  
5. Fate Revealed  
6. Write a Post to The Coven  
7. The Coven Community Feed  
8. Edit the Prophecy  
9. Blood Moon Diary  

---

# 🕯 Features

## 🔮 Tarot Readings

Perform a three-card reading using the **22-card Major Arcana deck**.

### Reading Flow
- Select a topic:
  - Love
  - Career
  - Health
  - Finance
  - Study
  - Life Path
- Draw 3 tarot cards
- Watch cards animate and reveal themselves
- Receive unique prophecies based on:
  - Card identity
  - Reading position *(Past · Present · Future)*
  - Orientation *(Upright / Reversed)*

### Highlights
- Animated card spin & reveal
- Topic-aware prophecy system
- Atmospheric gothic presentation

---

## 🩸 Blood Moon Diary

Seal readings into a private offline journal.

### Capabilities
- Save readings locally with Hive
- Browse previous prophecies
- Filter by:
  - Topic
  - Date range
- View complete prophecy details for:
  - Past
  - Present
  - Future

---

## 🕯 The Coven

A shared space for mystical confessions and tarot revelations.

### Community Features
- Publish readings to a public feed
- Add personal reflections
- React to other users' prophecies
- Filter by topic
- View your own posts
- Edit or delete your entries

Powered by Cloud Firestore for real-time social interaction.

---

## 🔐 Authentication

Supports multiple authentication flows via Firebase Authentication.

### Included
- Email & password sign-in
- User registration
- Google Sign-In
- Password reset via email

---

# ⚙️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| Local Storage | Hive |
| Hosting | Firebase Hosting |
| Fonts | Google Fonts |
| UI Style | Gothic / Mystical Theme |

### Typography
- Cormorant Garamond
- Roboto Mono

---

# 📁 Project Structure

```txt
lib/
├── core/           # App shell & routing
├── data/           # Tarot deck data & prophecy texts
├── models/         # App data models
├── pages/
│   ├── awakening/  # Authentication flows
│   ├── reading/    # Tarot reading experience
│   ├── diary/      # Blood Moon Diary
│   ├── coven/      # Community feed
│   └── edit_post/  # Edit/Delete community posts
├── services/       # Firebase & local services
├── theme/          # Colors & visual styling
└── ui/
    ├── atoms/      # Primitive UI components
    ├── molecules/  # Composite widgets
    └── templates/  # Layout wrappers
```

---

# 🚀 Getting Started

## Prerequisites

Before running the project, ensure you have:

- Flutter SDK installed
- A Firebase project configured
- Firebase Authentication enabled
- Cloud Firestore enabled

You will also need:

```txt
lib/firebase_options.dart
```

Generated using:

```bash
flutterfire configure
```

> `firebase_options.dart` is gitignored and should not be committed.

---

## ▶ Run the App

```bash
flutter pub get
flutter run
```

---

## 🌐 Run on Web

```bash
flutter run -d chrome
```

---

# 🔥 Firebase Services Used

- Firebase Authentication
- Cloud Firestore
- Firebase Hosting

---

# 🧪 Testing

- Widget Testing
- Manual UI Testing
- Authentication Flow Validation
- Firebase Integration Testing
- Form Validation Testing
- CRUD Testing for The Coven posts

---

# 🎨 Design Direction

FATUM explores:
- Gothic minimalism
- Ritual-inspired interaction
- Mystical typography
- Dark cinematic color palettes
- Symbolic storytelling through tarot systems

---

# 🚢 CI / CD

This project uses **GitHub Actions** for automated preview deployments.

### Workflow
- Pull requests targeting `main`
- Trigger Firebase Hosting preview deploys
- Generate sharable preview environments automatically

---

# 🕯 Future Ideas

Potential expansions for FATUM:

- Full 78-card tarot deck
- AI-generated prophecy interpretations
- Daily tarot draws
- Push notifications
- User profiles & follower system
- Ritual achievements / progression
- Dark ambient soundtrack

---

# 📜 Academic Use

This project was developed as part of coursework for:

- SEA605 — Mobile Application Design and Development
- SEA606 — Software Testing

It is intended for educational and portfolio purposes.

---

# 🩸 Author

Built with Flutter, Firebase, and a love for gothic storytelling.
