<div align="center">

# CalcSphere

### All-in-One Calculator App for Android

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![Material You](https://img.shields.io/badge/Material_You-Dynamic_Color-6750A4?style=for-the-badge)](https://m3.material.io)

*A beautifully designed, feature-rich calculator app built with Flutter — 16 calculators in one app, wrapped in a modern, iOS-inspired UI with full Material You theming.*

[Features](#-features) · [Screenshots](#-screenshots) · [Tech Stack](#-tech-stack) · [Getting Started](#-getting-started) · [Project Structure](#-project-structure)

</div>

---

<h2 align="center">📱 About CalcSphere</h2>

<p align="center">
CalcSphere is a multi-purpose calculator app that goes beyond basic arithmetic. Whether you're a student, professional, shopper, or commuter — CalcSphere has a calculator tailored for your need. It features a deeply customizable theming system (Material You, OLED, custom accent colors), a slide-in calculation history panel, and a consistent, animated numpad shared across every screen.
</p>

---

<h2 align="center">✨ Features</h2>

<h3 align="center">🧮 16 Calculators</h3>

<div align="center">

| Calculator | Route | Description |
|-----------|-------|-------------|
| **Calculator** | `/calculator` | Expression-based standard + scientific calculator with live syntax-colored input and history |
| **Currency** | `/currency` | Convert between world currencies with a swap button and searchable currency picker |
| **Unit Converter** | `/unit-converter` | Convert Length, Weight, Temperature, and more across categories |
| **Discount** | `/discount` | Price, discount %, and tax → final price with amount saved |
| **GST** | `/gst` | Add/remove GST from a price across multiple input fields |
| **Fuel Cost** | `/fuel-cost` | Trip distance + fuel efficiency + fuel price → total trip cost |
| **Fuel Efficiency** | `/fuel-efficiency` | Distance + fuel added → km/L, L/100km, and MPG |
| **Body Metrics** | `/body-metrics` | BMI calculator with Metric/Imperial support and visual indicator |
| **Loan / EMI** | `/loan` | Monthly EMI, total interest, and optional amortization table |
| **GPA** | `/gpa` | Grade-point average calculator with add/remove subject entries |
| **Tip** | `/tip` | Bill splitting with quick tip-% chips and per-person amount |
| **World Time** | `/world-time` | Live current time across multiple selectable global cities |
| **Hex Converter** | `/hex` | Convert between Decimal, Hex, Octal, and Binary simultaneously |
| **Unit Price** | `/unit-price` | Compare up to 4 items to find the best price-per-unit deal |
| **Percentage** | `/percentage` | "X is what % of Y", "What is X% of Y", and % change modes |
| **Date Calculator** | `/date` | Days-between-dates and add/subtract-days modes |

</div>

<h3 align="center">🎨 UI & Theming</h3>

<div align="center">

- **Material You** — Dynamic color sourced from your wallpaper (Android 12+)
- **Light / Dark / System / OLED (true black)** modes
- **16 custom accent colors** with live preview cards
- **Liquid Mode & Bloom** — glass/glow visual effect toggles
- **Custom palette picker** for Material You tonal variants
- **Samsung-style slide-in History Panel** on the calculator screen
- **Consistent animated NumPad** shared across all calculator screens
- **App Drawer** with a Favourites section + full alphabetized calculator list
- **Portrait-locked** — optimized exclusively for portrait mode

</div>

<h3 align="center">⚙️ Technical Highlights</h3>

<div align="center">

- **Riverpod** (`StateNotifierProvider`) — reactive state for theme, accent color, toggles, and favourites, all persisted to Hive
- **go_router** — declarative routing across all 16 calculators + Settings + Theme screens
- Expression-based calculator built on native `TextField` architecture
- Custom `ExpressionTextEditingController` — colors operators (`+ − × ÷ ^ %`) inline using the live theme accent, with native cursor support
- `DraggableScrollableSheet` history panel + bottom-sheet scientific function picker (trig, log, hyperbolic functions)
- Feature-based folder structure (`controller` / `presentation` / `widgets` per feature) for clean separation of concerns
- `SafeArea` handled correctly across all screens, including custom NumPad containers

</div>

---

<h2 align="center">📸 Screenshots</h2>

<p align="center"><i>Coming soon — screenshots will be added after the first public release.</i></p>

---

<h2 align="center">🛠 Tech Stack</h2>

<div align="center">

| Category | Technology |
|----------|-----------|
| **Framework** | [Flutter](https://flutter.dev) (SDK `^3.10.8`) |
| **Language** | [Dart](https://dart.dev) 3.x |
| **State Management** | [flutter_riverpod](https://riverpod.dev) `^2.6.1` |
| **Routing** | [go_router](https://pub.dev/packages/go_router) `^14.8.1` |
| **Local Storage** | [hive](https://pub.dev/packages/hive) / [hive_flutter](https://pub.dev/packages/hive_flutter) `^2.2.3` / `^1.1.0` |
| **Dynamic Color** | [dynamic_color](https://pub.dev/packages/dynamic_color) `^1.8.1` |
| **Fonts** | [google_fonts](https://pub.dev/packages/google_fonts) `^6.2.1` — Inter |
| **Icons** | [iconsax](https://pub.dev/packages/iconsax), [lucide_icons](https://pub.dev/packages/lucide_icons), [lucide_icons_flutter](https://pub.dev/packages/lucide_icons_flutter) |
| **Networking** | [http](https://pub.dev/packages/http) `^1.2.1`, [dio](https://pub.dev/packages/dio) `^5.7.0` |
| **Charts** | [fl_chart](https://pub.dev/packages/fl_chart) `^0.68.0` |
| **Utilities** | [intl](https://pub.dev/packages/intl), [uuid](https://pub.dev/packages/uuid), [connectivity_plus](https://pub.dev/packages/connectivity_plus), [auto_size_text](https://pub.dev/packages/auto_size_text) |
| **Sharing / Info** | [share_plus](https://pub.dev/packages/share_plus), [url_launcher](https://pub.dev/packages/url_launcher), [package_info_plus](https://pub.dev/packages/package_info_plus) |
| **Platform** | Android (package name: `calc_sphere`) |

</div>

---

<h2 align="center">🚀 Getting Started</h2>

<h3 align="center">Prerequisites</h3>

<div align="center">

Make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.10.8` (Dart SDK bundled)
- Android Studio / VS Code with the Flutter extension
- An Android device or emulator (API 21+)

</div>

<h3 align="center">Setup</h3>

```bash
# 1. Clone the repository
git clone https://github.com/Raees-Yuuki/CalcSphere.git
cd CalcSphere

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device/emulator
flutter run
```

<h3 align="center">Build a release APK</h3>

```bash
flutter build apk --release
```

---

<h2 align="center">📦 Key Dependencies</h2>

```yaml
dependencies:
  flutter_riverpod: ^2.6.1     # State management
  go_router: ^14.8.1           # Declarative routing
  hive: ^2.2.3                 # Local storage (preferences + history boxes)
  hive_flutter: ^1.1.0
  dynamic_color: ^1.8.1        # Material You dynamic color
  google_fonts: ^6.2.1         # Inter font
  fl_chart: ^0.68.0            # Charts (loan amortization, etc.)
  dio: ^5.7.0                  # HTTP client (currency rates)
  intl: ^0.20.2                # Date/number formatting
```

---

<h2 align="center">📂 Project Structure</h2>

```
lib/
├── main.dart                      # App entry point, Hive init, DynamicColorBuilder
├── core/
│   ├── router/app_router.dart     # go_router config — all 16 routes + settings/theme
│   ├── theme/
│   │   ├── app_theme.dart         # Light/Dark ThemeData, OLED variant
│   │   └── color_tokens.dart      # iOS-inspired color system + accent presets
│   ├── widgets/                   # Shared widgets: NumPad, ModalNumPad, AppDrawer, SwapButton
│   └── utils/                     # expr_parser, number_formatter, input_validator
├── features/
│   ├── calculator/                # Standard + scientific calculator
│   │   ├── controller/            # CalculatorController, ExpressionTextEditingController
│   │   └── presentation/          # CalculatorScreen + widgets (editor, toolbar)
│   ├── currency/
│   ├── unit_converter/
│   ├── discount/
│   ├── gst/
│   ├── fuel_cost/
│   ├── fuel_efficiency/
│   ├── body_metrics/
│   ├── loan/
│   ├── grade_average/             # GPA calculator
│   ├── tip/
│   ├── world_time/
│   ├── hex_converter/
│   ├── unit_price/
│   ├── percentage/
│   ├── date_calculator/
│   └── settings/
│       └── presentation/          # SettingsScreen, ThemeScreen, PalettePickerSheet
└── shared/
    ├── models/calculator_info.dart  # Metadata (id, name, route, icon, color) for drawer & routing
    ├── providers/theme_provider.dart # Riverpod providers for theme mode, accent, toggles, favourites
    └── services/history_service.dart # Hive-backed calculation history
```

<p align="center">Each feature module follows a <code>controller</code> / <code>presentation</code> / <code>widgets</code> split, keeping business logic separate from UI.</p>

---

<h2 align="center">🔒 Privacy</h2>

<p align="center">
CalcSphere does <b>not</b> collect, transmit, or share any personal data. All data (history, preferences, theme settings) is stored locally on the device using Hive.
</p>

<p align="center">
For full details, see the <a href="PRIVACY_POLICY.md">Privacy Policy</a> and <a href="TERMS_OF_SERVICE.md">Terms of Service</a>.
</p>

---

<h2 align="center">🤝 Contributing</h2>

<p align="center">Contributions are welcome! If you find a bug or have a feature request:</p>

<div align="center">

1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature-name`
3. Make your changes and commit: `git commit -m "feat: add your feature"`
4. Push to your fork: `git push origin feature/your-feature-name`
5. Open a Pull Request

</div>

<p align="center">Please follow the existing <code>controller</code> / <code>presentation</code> folder structure and keep commits atomic.</p>

---

<h2 align="center">📄 License</h2>

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

<p align="center">⭐ If you find CalcSphere useful, please give it a star!</p>
