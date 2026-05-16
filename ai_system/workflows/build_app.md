# CalcSphere Build Workflow
 
## Before Starting Any Step
Manager must:
1. Read progress.md
2. Check completed_steps list
3. Skip any step already marked complete
4. Start from first incomplete step
---
 
## Step 1 — Product Definition
Assign to: product_agent
Task: Generate complete PRD with all 16 module specs
Output required:
```json
{
  "status": "success",
  "agent": "product_agent",
  "step": "1",
  "data": {
    "modules_defined": ["all 16 listed"],
    "ux_flows_defined": ["drawer", "calculator", "..."]
  },
  "errors": [],
  "next_action": "design_agent and backend_agent can now start"
}
```
Gate: All 16 modules defined? errors empty? → Proceed
On fail: Retry with hint "List all 16 modules explicitly"
 
---
 
## Step 2 — Design System + Backend (PARALLEL)
Run design_agent and backend_agent at the same time.
They are independent — no need to wait for each other.
 
### Step 2A — Design System
Assign to: design_agent
Input: PRD from Step 1
Task: Define complete visual system
Output required:
```json
{
  "status": "success",
  "agent": "design_agent",
  "step": "2A",
  "data": {
    "color_tokens_defined": true,
    "typography_defined": true,
    "numpad_spec_defined": true,
    "drawer_spec_defined": true,
    "animation_spec_defined": true
  },
  "errors": [],
  "next_action": "frontend_agent can now build UI"
}
```
Gate: All design tokens defined? → Proceed
 
### Step 2B — Backend & Services
Assign to: backend_agent
Input: PRD from Step 1
Task: Build all services, Firebase setup, API integration
Output required:
```json
{
  "status": "success",
  "agent": "backend_agent",
  "step": "2B",
  "data": {
    "services_created": ["CurrencyApiService", "HistoryService",
                         "PreferencesService", "IAPService"],
    "firebase_setup": true,
    "hive_boxes_defined": true,
    "api_keys_secured": true,
    "remote_config_setup": true
  },
  "errors": [],
  "next_action": "frontend_agent can now consume these APIs"
}
```
Gate: All services created? API keys NOT hardcoded? → Proceed
 
---
 
## Step 3 — Frontend Build
Assign to: frontend_agent
Input: Design system (Step 2A) + Backend interfaces (Step 2B)
Task: Build all 16 screens + shared components
Skills to use: flutter_architecture, ui_design
Output required:
```json
{
  "status": "success",
  "agent": "frontend_agent",
  "step": "3",
  "data": {
    "screens_built": ["all 16 listed"],
    "shared_widgets": ["NumPad", "AppDrawer", "ModalNumPad",
                       "SwapButton", "EmptyState"],
    "splash_screen": true,
    "deep_links_configured": true,
    "input_validation": true,
    "empty_states": true
  },
  "errors": [],
  "next_action": "qa_agent can now test all screens"
}
```
Gate: All 16 screens built? No compile errors? → Proceed
 
---
 
## Step 4 — QA Testing
Assign to: qa_agent
Input: Complete codebase from Step 3
Task: Full test pass across all categories
Skills to use: testing
Output required:
```json
{
  "status": "success | fail",
  "agent": "qa_agent",
  "step": "4",
  "data": {
    "tests_passed": ["math_accuracy", "ui_design", "performance",
                     "network", "deep_links", "accessibility"],
    "bugs_found": 0
  },
  "errors": [],
  "next_action": "ready for release | fix bugs listed in errors"
}
```
Gate: Zero Critical bugs, zero High bugs → Proceed
On fail: Send bug list to frontend_agent, repeat Step 3 for affected screens only
 
---
 
## Step 5 — Fix & Iterate
If QA fails:
1. Manager sends specific bug list to frontend_agent
2. frontend_agent fixes only the failing screens
3. qa_agent re-tests only affected screens
4. Repeat until QA gate passes
5. Manager updates progress.md after each fix cycle
---
 
## Step 6 — Release Checklist
Manager final review — all must be true:
- All 16 calculators functional: yes
- Dark mode verified: yes
- Performance 60fps confirmed: yes
- Crash rate 0% in testing: yes
- Splash screen working: yes
- Deep links all tested: yes
- API keys not hardcoded: yes
- Remote Config live: yes
- Input validation on all screens: yes
- Empty states on all screens: yes
- progress.md fully updated: yes
---
 
## Progress Tracking Format
Manager writes to progress.md after every step:
 
```markdown
## Step [N] — [Agent] — [SUCCESS/FAIL] — [timestamp]
- Completed: [description]
- Files created: [list]
- Errors found: [list or none]
- Retry count: [0/1/2/3]
- Next step: [step number]
```
 
## Dynamic Step Rules
- Manager can jump to any step if user requests
- Manager skips completed steps automatically
- Manager can re-run single step without full rebuild
- Manager runs Step 2A and 2B in parallel always