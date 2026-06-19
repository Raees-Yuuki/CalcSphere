# CalcSphere

### All-in-One Calculator App for Android

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![Material You](https://img.shields.io/badge/Material_You-Dynamic_Color-6750A4?style=for-the-badge)](https://m3.material.io)

*A beautifully designed, feature-rich calculator app built with Flutter — combining everyday math with powerful specialty calculators, all wrapped in a modern Material You UI.*

[Features](#-features) · [Screenshots](#-screenshots) · [Tech Stack](#-tech-stack) · [Getting Started](#-getting-started) · [Project Structure](#-project-structure)



## 📱 About CalcSphere

CalcSphere is a multi-purpose calculator app that goes beyond basic arithmetic. Whether you're a student, professional, or everyday user — CalcSphere has a calculator tailored for your need. It features Material You dynamic theming, a slide-in calculation history panel, and a responsive numpad used consistently across all screens.

---

## ✨ Features

### 🧮 Calculators
| Calculator | Description |
|-----------|-------------|
| **Standard Calculator** | Full expression-based calculator with history panel |
| **Scientific Calculator** | Trigonometric, logarithmic, power, and advanced math functions |
| **GST Calculator** | Calculate GST-inclusive/exclusive prices with multiple tax slabs |
| **EMI / Loan Calculator** | Monthly EMI, total interest, and amortization breakdown |
| **Body Metrics (BMI)** | BMI calculator with visual indicator, supports Metric & Imperial |
| **Grade Average** | GPA/percentage calculator with swipe-to-delete subject entries |
| **Hex Converter** | Convert between Decimal, Binary, Octal, and Hexadecimal |
| **Currency Converter** | Live exchange rate conversion between world currencies |
| **Unit Converter** | Convert Length, Weight, Temperature, Speed, Area, and more |
| **World Time** | View current time across multiple global time zones |

### 🎨 UI & Theming
- **Material You** — Dynamic color support that adapts to your wallpaper
- **Light / Dark / AMOLED** mode support
- **Samsung-style slide-in History Panel** on the main calculator
- **Consistent NumPad** — Shared across all calculator screens
- **App Drawer** — Quick navigation between all calculators
- **Portrait-locked** — Optimized exclusively for portrait mode

### ⚙️ Technical Highlights
- Riverpod-powered state management — reactive and scalable
- Hive local storage — fast, lightweight, persistent data
- Expression-based calculator using native `TextField` architecture
- Custom `ExpressionTextEditingController` with blinking cursor
- `DraggableScrollableSheet` history panel
- `SafeArea` applied correctly across all screens

---

## 📸 Screenshots

> *Coming soon — screenshots will be added after the first public release.*

---

## 🛠 Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | [Flutter](https://flutter.dev) 3.x |
| **Language** | [Dart](https://dart.dev) 3.x |
| **State Management** | [Riverpod](https://riverpod.dev) |
| **Local Storage** | [Hive](https://pub.dev/packages/hive) |
| **Dynamic Color** | [dynamic_color](https://pub.dev/packages/dynamic_color) |
| **Fonts** | [Google Fonts](https://pub.dev/packages/google_fonts) — Inter |
| **Platform** | Android (iOS structure present but untested) |

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.0.0`
- [Dart SDK](https://dart.dev/get-dart) `>=3.0.0`
- Android Studio / VS Code with Flutter extension
- Android device or emulator (API 21+)

## 📦 Key Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.x.x      # State management
  hive_flutter: ^1.x.x          # Local storage
  dynamic_color: ^1.7.0         # Material You dynamic color
  google_fonts: ^6.x.x          # Inter font
  intl: ^0.x.x                  # Date/number formatting
```

---

## 🔒 Privacy

CalcSphere does **not** collect, transmit, or share any personal data. All data (history, preferences) is stored locally on the device using Hive.

For full details, see the [Privacy Policy](PRIVACY_POLICY.md) and [Terms of Service](TERMS_OF_SERVICE.md).

---

## 🤝 Contributing

Contributions are welcome! If you find a bug or have a feature request:

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make your changes and commit: `git commit -m "feat: add your feature"`
4. Push to your fork: `git push origin feature/your-feature-name`
5. Open a Pull Request

Please follow the existing code style and keep commits atomic.

---

## 📄 License

```
MIT License

Copyright (c) 2025 Raees-Yuuki

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
provided, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.
```

---

⭐ If you find CalcSphere useful, please give it a star!
