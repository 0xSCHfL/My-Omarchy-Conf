---
name: obsidian-budget
description: >
  Manage the user's personal budget tracker in Obsidian. Use this skill whenever
  the user wants to track money, add expenses or income, check their balance, or
  see how much they've spent. Triggers on: "add expense", "add income", "i spent",
  "i received", "show my balance", "how much did i spend", "show budget", "check
  my money", pasting a list of expenses. Always use this skill for money/budget
  tracking — don't just answer inline, update the Obsidian file.
---

# Obsidian Budget Skill

Track income and expenses in the user's monthly budget file in Obsidian.

## Budget folder

`/home/sohaib/Dropbox/Notes/Obsidian Vault/Live_Style/Budget/`

Monthly files are named: `YYYY-MM Month.md`  
Example: `2026-05 May.md`

Template for new months: `_Template.md`

## Finding the current month file

Today's date comes from the system context (`currentDate`). Derive the filename:
- `2026-05-03` → `2026-05 May.md`
- Always check if the file exists before writing. If it doesn't exist, create it by copying `_Template.md` and updating the frontmatter (`month`, `title`).

## Commands the user can give

### Add an expense
Phrases like: "add expense 150 food lunch", "i spent 50 on transport", "add 200 shopping"

1. Parse: amount, category, description (description can be empty)
2. Append a row to the `## 📋 Transactions` table
3. Update the matching row in `## 📂 By Category` (add to total)
4. Update `💸 Expenses` in the Summary (add to total)
5. Recalculate `💚 Savings` = Income − Expenses

### Add income
Phrases like: "add income 3000 salary", "i received 500 freelance"

1. Parse: amount, category/description
2. Append a row to the Transactions table (Type = income)
3. Update `💵 Income` in the Summary
4. Recalculate `💚 Savings`

### Show balance / summary
Phrases like: "show my balance", "how much left", "show budget may"

Read the current month file and display:
```
💰 Budget — May 2026
💵 Income:   X DH
💸 Expenses: X DH
💚 Savings:  X DH

Top spending:
  🍔 Food: X DH
  🚗 Transport: X DH
  ...
```

## Transaction row format

```markdown
| 05-03 | 🍔 Food | Lunch at restaurant | 150 DH | expense |
| 05-03 | 💵 Salary | Monthly salary | 3000 DH | income |
```

- Date: `MM-DD` format
- Category: use the emoji + name from the By Category table
- Amount: always `X DH`
- Type: `expense` or `income`

## Category mapping

When the user gives a category name (even abbreviated or in French/Darija), map it:

| User says | Category |
|-----------|----------|
| food, manger, makla, resto, lunch, dinner | 🍔 Food |
| transport, taxi, bus, uber, essence | 🚗 Transport |
| games, netflix, entertainment, lih9a | 🎮 Entertainment |
| phone, internet, electricity, bills, facture | 📱 Bills |
| clothes, shopping, shoes, hawa2ij | 👕 Shopping |
| doctor, pharmacy, health, saha | 💊 Health |
| anything else | 📦 Other |

## Updating totals

When editing the file, do a clean read-then-write:
1. Read the current file
2. Parse the existing totals from the Summary and By Category sections
3. Add the new amounts
4. Write the updated file with correct totals

Savings is always: Income total − Expenses total (can be negative if overspent).

## Creating a new month

If the user asks about a month that has no file yet:
1. Read `_Template.md`
2. Create a new file with correct `month` and `title` in frontmatter
3. Proceed with the requested action

## Steps

1. Identify the action (add expense / add income / show balance)
2. Find or create the current month file
3. Read the file to get current totals
4. Apply the change (append transaction row + update totals)
5. Write the updated file
6. Confirm: "Added **150 DH** (🍔 Food — Lunch). Expenses this month: **X DH**, Savings: **X DH**."
