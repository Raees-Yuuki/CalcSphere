# Testing Skill

## Unit Tests (required for all)
- All calculation logic (math functions)
- All state notifiers (Riverpod providers)
- All repository methods
- Currency conversion accuracy

## Widget Tests (required for key screens)
- NumPad widget: all key types
- Calculator screen: full input → result flow
- Currency screen: swap, select currency, show rate

## Test Pattern
```dart
void main() {
  group('CalculatorNotifier', () {
    test('basic addition works', () {
      final notifier = CalculatorNotifier();
      notifier.inputNumber('2');
      notifier.inputOperator('+');
      notifier.inputNumber('3');
      notifier.calculate();
      expect(notifier.state.result, '5');
    });
  });
}
```

## Coverage Target
- Business logic: 90%+ coverage
- UI widgets: 60%+ coverage
- Integration: all happy paths covered