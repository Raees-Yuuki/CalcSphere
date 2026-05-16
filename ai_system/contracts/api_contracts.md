# CalcSphere — Inter-Agent Data Contracts
 
This file defines the exact data format that agents must use
when passing information to each other.
If any agent returns data in a different format — reject it.
 
---
 
## 1. Currency API Contract
 
### Request (frontend → backend)
```json
{
  "from": "USD",
  "to": "INR",
  "amount": 100
}
```
 
### Response (backend → frontend)
```json
{
  "result": 9491.00,
  "rate": 94.91,
  "lastUpdated": "2026-05-03T10:00:00Z",
  "isFromCache": true
}
```
 
---
 
## 2. Calculation History Contract
 
### Save entry (frontend → backend)
```json
{
  "calculatorType": "standard",
  "expression": "56,46,43,131 − 48,494",
  "result": "56,45,94,637",
  "timestamp": "2026-05-03T10:00:00Z"
}
```
 
### Fetch history (backend → frontend)
```json
{
  "entries": [
    {
      "id": "uuid",
      "calculatorType": "standard",
      "expression": "56,46,43,131 − 48,494",
      "result": "56,45,94,637",
      "timestamp": "2026-05-03T10:00:00Z"
    }
  ],
  "total": 1
}
```
 
---
 
## 3. User Preferences Contract
 
### Save (frontend → backend)
```json
{
  "theme": "dark | light | system",
  "accentColor": "#007AFF",
  "numberFormat": "indian | international",
  "decimalPlaces": 2,
  "hapticEnabled": true,
  "homeCurrency": "INR",
  "favouriteCalculators": ["calculator", "currency", "gst"],
  "isProUser": false
}
```
 
### Load (backend → frontend)
Same structure — all fields always present with defaults.
 
---
 
## 4. IAP Purchase Verification Contract
 
### Request (frontend → backend/Firebase Function)
```json
{
  "productId": "calcsphere_pro",
  "platform": "android | ios",
  "purchaseToken": "token_string"
}
```
 
### Response (backend → frontend)
```json
{
  "verified": true,
  "isProUser": true,
  "error": null
}
```
 
---
 
## 5. BMI / BMR Calculation Contract
 
### Request (frontend → calculation service)
```json
{
  "height": 175,
  "heightUnit": "cm",
  "weight": 70,
  "weightUnit": "kg",
  "age": 25,
  "gender": "male | female"
}
```
 
### Response
```json
{
  "bmi": 22.9,
  "bmiCategory": "Normal",
  "bmr": 1724,
  "bmrUnit": "kcal/day"
}
```
 
---
 
## 6. Loan Calculation Contract
 
### Request
```json
{
  "principal": 500000,
  "interestRate": 8.5,
  "periodMonths": 60,
  "interestOnlyMonths": 0,
  "repaymentMethod": "equal_total | equal_principal | bullet"
}
```
 
### Response
```json
{
  "monthlyPayment": 10247.50,
  "totalInterest": 114850.00,
  "totalPayment": 614850.00,
  "amortizationTable": [
    {
      "month": 1,
      "payment": 10247.50,
      "principal": 6830.83,
      "interest": 3416.67,
      "balance": 493169.17
    }
  ]
}
```
 
---
 
## 7. GPA Calculation Contract
 
### Request
```json
{
  "subjects": [
    {
      "name": "Mathematics",
      "credits": 4,
      "grade": "A",
      "gradePoints": 10
    }
  ],
  "gradingScale": "10 | 4"
}
```
 
### Response
```json
{
  "gpa": 9.2,
  "totalCredits": 20,
  "totalGradePoints": 184
}
```
 
---
 
## 8. Agent Output Contract (ALL agents must use this)
 
Every agent response to manager must follow this format:
 
```json
{
  "status": "success | fail",
  "agent": "agent_name",
  "step": "1",
  "data": {
    "summary": "what was completed",
    "files_created": [],
    "files_modified": []
  },
  "errors": [],
  "next_action": "what manager should do next"
}
```
 
### Failure example
```json
{
  "status": "fail",
  "agent": "frontend_agent",
  "step": "4",
  "data": {},
  "errors": [
    "GoRouter dependency version conflict",
    "NumPad widget missing from core/widgets"
  ],
  "next_action": "Resolve dependency conflict then retry step 4"
}
```
 
---
 
## Contract Rules
 
- Frontend NEVER calls Firebase directly — always through backend services
- Backend NEVER returns raw API response — always mapped to contract format
- All amounts: stored as num (not String) — formatted only in UI layer
- All timestamps: ISO 8601 format — "2026-05-03T10:00:00Z"
- All currency amounts: 2 decimal places minimum
- Null fields: always include with null value — never omit keys