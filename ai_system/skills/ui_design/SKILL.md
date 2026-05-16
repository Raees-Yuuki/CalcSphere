# UI Design Skill

## Spacing
- Always use multiples of 8dp
- Minimum touch target: 44dp
- Standard padding: 16dp
- Card internal padding: 16dp

## Color Usage
- Never hardcode hex in widgets — always use Theme.of(context)
- Accent for: active states, CTAs, positive results
- Mint teal only for: savings, best value, positive delta
- Red only for: errors, negative delta, clear button flash

## Typography
- Never use FontWeight.w400 for numbers — use w600 minimum
- Result numbers: always largest text on screen
- Labels: always lighter than values visually

## Component Rules
- Every list item: min 56dp height
- Every card: 8dp or 12dp corner radius
- Dividers: use Divider(height: 1) not Container height
- Loading states: use Shimmer effect, never empty white space

## Anti-patterns (never do these)
- No Lorem ipsum placeholder text
- No magic numbers — use const tokens
- No hardcoded colors
- No widget trees deeper than 7 levels without extracting widget