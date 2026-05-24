<div align="center">

<img src="assets/readme/moodboard.png" width="100%" alt="FATUM Mood Board"/>

<br/>

### 🌑 [— Enter the Darkness — fatum-371c1.web.app](https://fatum-371c1.web.app/)

<br/>

```
███████╗ █████╗ ████████╗██╗   ██╗███╗   ███╗
██╔════╝██╔══██╗╚══██╔══╝██║   ██║████╗ ████║
█████╗  ███████║   ██║   ██║   ██║██╔████╔██║
██╔══╝  ██╔══██║   ██║   ██║   ██║██║╚██╔╝██║
██║     ██║  ██║   ██║   ╚██████╔╝██║ ╚═╝ ██║
╚═╝     ╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝
```

*The blood moon reveals what fate has sealed.*

<br/>

[![Flutter](https://img.shields.io/badge/Flutter-3.41.7-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Hosting-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.11.5-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

*Inspired by ENHYPEN · DARK BLOOD*

<br/>

---

</div>

## ✦ Overview

**FATUM** is a gothic-themed tarot reading app built with Flutter. Draw from the **22-card Major Arcana**, receive prophecies shaped by card position and orientation, preserve readings in a private **Blood Moon Diary**, and share revelations with a social community known as **The Coven**.

---

## ✦ App Screens

<div align="center">

| | | |
|:---:|:---:|:---:|
| <img src="assets/readme/1.png" width="220"/> | <img src="assets/readme/2.png" width="220"/> | <img src="assets/readme/3.png" width="220"/> |
| *Enter the Darkness* | *What does fate speak to?* | *The cards await* |
| <img src="assets/readme/4.png" width="220"/> | <img src="assets/readme/5.png" width="220"/> | <img src="assets/readme/6.png" width="220"/> |
| *Card Selection* | *Your fate is sealed* | *Inscribe your prophecy* |
| <img src="assets/readme/7.png" width="220"/> | <img src="assets/readme/8.png" width="220"/> | <img src="assets/readme/9.png" width="220"/> |
| *The Coven* | *Edit your prophecy* | *Blood Moon Diary* |

</div>

---

## ✦ Features

<details>
<summary><b>🔮 Tarot Readings</b></summary>
<br>

Draw from the **22-card Major Arcana** in a three-card spread.

**Choose your topic:**

| ♥ Love | ✦ Career | ✧ Health |
|---|---|---|
| **◈ Finance** | **△ Study** | **∞ Life Path** |

**Each prophecy is shaped by:**
- Card identity
- Position — *Past · Present · Future*
- Orientation — *Upright / Reversed*

Animated card spin & reveal · Topic-aware prophecy system · Atmospheric gothic UI

</details>

<details>
<summary><b>🩸 Blood Moon Diary</b></summary>
<br>

A private, offline journal powered by **Hive**.

- Save readings locally
- Filter by topic or date range
- Revisit full prophecy details across all three card positions

</details>

<details>
<summary><b>🕯 The Coven</b></summary>
<br>

A real-time community feed powered by **Cloud Firestore**.

- Publish readings with personal reflections
- React to others' prophecies
- Filter by topic
- Edit or delete your own posts

</details>

<details>
<summary><b>🔐 Authentication</b></summary>
<br>

Powered by **Firebase Authentication**.

- Email & password — *Awakening / Rebirth*
- Google Sign-In
- Password reset via email

</details>

---

## ✦ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| Local Storage | Hive |
| Hosting | Firebase Hosting |
| Typography | Cormorant Garamond · Roboto Mono |

---

## ✦ Project Structure

```
lib/
├── core/            # App shell & routing
├── data/            # Tarot deck data & prophecy texts
├── models/          # App data models
├── pages/
│   ├── awakening/   # Authentication flows
│   ├── reading/     # Tarot reading experience
│   ├── diary/       # Blood Moon Diary
│   ├── coven/       # Community feed
│   └── edit_post/   # Edit / delete posts
├── services/        # Firebase & local services
├── theme/           # Colors & visual styling
└── ui/
    ├── atoms/       # Primitive UI components
    ├── molecules/   # Composite widgets
    └── templates/   # Layout wrappers
```

---

## ✦ Getting Started

**Prerequisites**

- Flutter SDK
- Firebase project with Authentication and Cloud Firestore enabled
- Generate `lib/firebase_options.dart` via:

```bash
flutterfire configure
```

> ⚠️ `firebase_options.dart` is gitignored — do not commit it.

**Run the App**

```bash
flutter pub get

flutter run              # Android / default device
flutter run -d chrome    # Web (Chrome)
```

---

## ✦ Testing

FATUM follows the **Testing Pyramid** — all unit and widget tests run without a device or Firebase connection.

```bash
flutter test   # Run all tests
```

| Tier | File | Cases | What it covers |
|---|---|---|---|
| Unit | `reading_logic_test.dart` | 9 | ReadingLogic, Hive serialisation, Daily Lock, canSave |
| Unit (BVA) | `bva_validation_test.dart` | 29 | Email, password, reflectionText — EP & Boundary Value Analysis |
| Widget | `widget_test.dart` | 10 | TopicPicker, CardGridStep, Reveal Button state |
| Integration | `app_test.dart` | 10 | Navigation flows, scaffold rendering across all pages |

---

## ✦ CI / CD

| Trigger | Target | Expires |
|---|---|---|
| Pull Request → `main` | Preview channel | 7 days |
| Push → `main` | Live production | Never |

---

## ✦ Academic Context

Developed for:
- **SEA605** — Mobile Application Design and Development
- **SEA606** — Modern Software Testing

---

<div align="center">

<br/>

*Built with Flutter, Firebase, and a love for gothic storytelling.*

<br/>

```
— what fate has sealed, only blood can reveal —
```

</div>
