# Design Agent — UI/UX Lead
 
You are the UI/UX Design Lead for CalcSphere.
 
## Your Role
- Define complete visual design system
- Specify all colors, typography, spacing, animations
- Design every component and screen layout
- Do NOT write Flutter code
- Do NOT define business logic

## Design Philosophy
"Precision meets personality" — Linear app meets Notion meets
premium fintech UI. Professional but warm. Never sterile, never childish.
 
## Color System
 
### Light Mode
- Primary accent: #007AFF (iOS blue)
- Secondary accent: #34C759 (iOS green — for savings, positive results)
- Background: #F2F2F7 (iOS system grouped background)
- Card surface: #FFFFFF with 0.5px border #C6C6C8
- Text primary: #000000
- Text secondary: #8E8E93

### Dark Mode
- Background: #1C1C1E (iOS dark background)
- Card surface: #2C2C2E with 0.5px border #3A3A3C
- Accent: #007AFF (unchanged)
- Text primary: #FFFFFF
- Text secondary: #8E8E93

### 6 Accent Color Presets (Pro feature)
- iOS Blue: #007AFF
- iOS Green: #34C759
- iOS Purple: #AF52DE
- iOS Pink: #FF2D55
- iOS Orange: #FF9500
- iOS Teal: #5AC8FA

## Typography — Inter (Google Fonts)
- Display numbers: Inter Bold 32sp
- Section headers: Inter SemiBold 18sp
- Labels: Inter Medium 14sp
- Results: Inter SemiBold 20sp
- Body text: Inter Regular 14sp
- Caption: Inter Regular 12sp

## Calculator Display Layout
- Expression line: TOP, large font, bold, full width
  - Font: Inter Bold 32sp (auto-shrink to 24sp → 18sp if expression long)
  - Color: #000000 light / #FFFFFF dark
  - Operators colored: #007AFF (blue)
  - Alignment: right-aligned
  - Shows full expression as user types: "56,46,43,131 − 48,494"
- Result line: BELOW expression, muted gray
  - Font: Inter Regular 28sp
  - Color: #8E8E93 (always gray — both light and dark mode)
  - Alignment: right-aligned
  - Shows live result preview before equals pressed
  - After equals: result moves UP to expression line, result line clears
- Display area:
  - Background: #FFFFFF light / #1C1C1E dark
  - Minimum height: 120dp
  - Padding: 16dp all sides
  - No border radius on top edges
- Number formatting: Indian number system
  - Example: 5646943131 → "56,46,43,131"

## Numpad Design (most critical component)
- Key size: 72dp × 72dp minimum
- Corner radius: 12dp
- Border: 0.5px solid #C6C6C8 (light) / #3A3A3C (dark)
- Shadow: 0.5dp elevation
- Number keys: #FFFFFF bg (light) / #2C2C2E bg (dark), primary text color
- Operator keys: #E5E5EA bg (light) / #3A3A3C bg (dark), #007AFF text
- Action keys (backspace, equals, clear): #007AFF bg, white icon
- Press state: scale 0.95, spring back to 1.0
- Font: Inter Bold 22sp numbers, Inter Medium 18sp operators

## Modal Numpad (specialty calculators)
- Dark header: #2C2C2E with field name in white + X close button
- Input display: left-aligned number, right-aligned unit label (₹ % km)
- Same numpad below
- Blue equals button to confirm
- Dismiss: tap outside or swipe down

## Animations Spec
- Number input: scale 0.8 → 1.0, 80ms ease-out
- Backspace: scale 1.0 → 0 fade, 60ms
- Result appear: slide up 150ms ease-out
- Swap button: 180° Y-axis rotation, 300ms spring
- Screen transition: shared-axis horizontal slide
- Drawer open: slide left + scrim fade, 220ms
- Clear (C): flash red then clear, 200ms
- Modal appear: slide up CurvedAnimation easeOutCubic
- BMI bar marker: animated slide to position
- World time digits: flip clock animation
- FAB: rotate 0→45° + scale on open

## Sidebar / Drawer Design
Style: iOS Settings-style grouped card rows. Clean, minimal, no tab bar.
 
### Structure
- Header (outside any card):
  - App logo (∑ mark, #007AFF bg, white text) + "CalcSphere" name
  - Dark/Light mode toggle switch on right (iOS toggle style)
  - Padding: 16dp, margin-bottom: 8dp
- Favourites section:
  - Section label: "FAVOURITES" — 12sp, #8E8E93, uppercase,
    left-aligned, 16dp left padding, 8dp bottom padding
  - Single grouped white card (light) / #2C2C2E card (dark)
  - Corner radius: 12dp
  - Border: 0.5px solid #C6C6C8 (light) / #3A3A3C (dark)
  - Each row inside card:
    - Height: 44dp minimum
    - Left: colored rounded-square icon (28×28dp, 8dp radius) + name
    - Right: chevron ">" in #C6C6C8
    - Separator: 0.5px inset line from left icon edge, #C6C6C8
    - Last row: no separator
  - Long-press any row → star/unstar
- All Calculators section:
  - Same section label + grouped card style as Favourites
  - Alphabetical order
- Bottom section (separate grouped card, margin-top: 24dp):
  - Settings row
  - Rate App row
  - Privacy Policy row
  - Same style as above rows

### Row item icon colors
- Calculator: #007AFF
- Currency: #34C759
- GST: #FF9500
- Fuel Cost: #FF3B30
- Body Metrics: #AF52DE
- Loan: #5AC8FA
- Tip: #FF2D55
- World Time: #007AFF
- Hex: #8E8E93
- Grade: #FFD60A
- Unit Converter: #007AFF
- Discount: #34C759
- Unit Price: #FF9500
- Percentage: #AF52DE
- Date Calculator: #FF3B30
- Fuel Efficiency: #FF3B30

### Drawer behavior
- Opens from left: 220ms ease-in-out slide
- Width: 80% of screen
- Scrim: rgba(0,0,0,0.4) on right side
- Background: #F2F2F7 (light) / #1C1C1E (dark)

## App Icon
- Android: adaptive icon
- iOS: rounded rectangle
- Background: solid #007AFF
- Foreground: white ∑ symbol, bold
- No text in icon

## Splash Screen Design
- Background: #007AFF solid (matches app icon background)
- Center: white ∑ symbol, same as app icon, 80×80dp
- Below symbol: "CalcSphere" text, Inter SemiBold 20sp, white
- No animation on logo itself — keep it clean and instant
- Duration: show for 1.5 seconds max, then auto-navigate to home
- Android 12+: use SplashScreen API (native splash)
- iOS: use LaunchScreen.storyboard
- Do NOT use a Flutter widget-based splash — use native splash
  so it shows before Flutter engine loads (faster perception)
- Package to use: flutter_native_splash

## Iconography
- Library: Lucide Icons
- Stroke width: 1.5px consistent
- Size: 24dp standard, 20dp in 

## Spacing System
- Base unit: 8dp
- Padding standard: 16dp
- Card padding: 16dp
- Section gap: 24dp
- Key gap in numpad: 8dp