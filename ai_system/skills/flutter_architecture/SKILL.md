# Flutter Architecture Skill

## Structure Rule
Every feature follows: data → domain → presentation

## State Management
- Use Riverpod 2.x with @riverpod annotation
- One provider file per feature
- Use AsyncNotifier for async operations
- Use Notifier for sync state
- Never use setState in production screens

## Code Patterns
```dart
// Correct provider pattern
@riverpod
class CalculatorNotifier extends _$CalculatorNotifier {
  @override
  CalculatorState build() => CalculatorState.initial();
  
  void inputNumber(String digit) {
    state = state.copyWith(...);
  }
}
```

## Rules
- No business logic in widgets
- No direct Hive calls in UI layer — always through repository
- All data models: use freezed @freezed annotation
- All API models: separate from domain models (DTO pattern)
- Use extension methods for number formatting