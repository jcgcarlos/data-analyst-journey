#!/bin/bash

# ----------------------------------------
# Data Analyst Journey Commit Script
# Run after every study session: bash commit_session.sh
# ----------------------------------------

REPO_PATH="/Users/jc/Projects/data-analyst-journey"
cd "$REPO_PATH"

# Check if there's anything to commit
if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing to commit. No changes detected."
  exit 0
fi

# Stage all changes
git add .

# Get a summary of what changed
DIFF_STAT=$(git diff --staged --stat)
DIFF_DETAIL=$(git diff --staged --name-only)

echo "Changed files:"
echo "$DIFF_DETAIL"
echo ""

# ----------------------------------------
# GENERATE COMMIT MESSAGE
# ----------------------------------------

# Filter to core session deliverables — SQL files, markdown notes, notebooks, Python scripts
DELIVERABLE_FILES=$(echo "$DIFF_DETAIL" | grep -E "\.(sql|md|py|ipynb)$" | grep -v "README.md" | grep -v "commit_session.sh" || true)

# If there are deliverable files, get their diff for context
if [ -n "$DELIVERABLE_FILES" ]; then
  DELIVERABLE_DIFF=$(git diff --staged -- $DELIVERABLE_FILES | head -500)
else
  DELIVERABLE_DIFF=""
fi

COMMIT_MSG=$(claude -p "You are writing a Git commit message for JC's learning repo: data-analyst-journey. JC is a BI Specialist actively upskilling toward a Senior Data Analyst role in fintech, SaaS, or e-commerce. This repo tracks his weekly study sessions across three tracks.

The three learning tracks:
- SQL: progressing through foundations (filtering, aggregation, string/date manipulation, data cleaning) → intermediate (JOINs, CTEs, subqueries, set operations, window functions) → advanced (business case studies, full analysis projects)
- Python: pandas fundamentals, data cleaning, EDA, visualization (matplotlib/seaborn)
- LookML/Looker: views, dimensions, measures, explores, model/explore wiring, derived tables

Key repo conventions:
- SQL exercises are themed around fintech/SaaS/e-commerce business scenarios (never BPO)
- notes.md entries are written in JC's voice — first-person learning journal, feeds his LinkedIn series 'AHA Moments for an Analyst'
- .ipynb notebooks follow a structured format: markdown cells for context, code cells for execution, summary tables

Here are ALL files changed this session:
$DIFF_DETAIL

Here are the core deliverable files only (SQL, Python, notebooks, notes):
$DELIVERABLE_FILES

Here is the diff of the deliverable files:
$DELIVERABLE_DIFF

Write a Git commit message with:
- Subject line: max 50 chars. Name the CONCEPT or SKILL being built — frame it as what JC can now do, not what file was added. Bad: 'Add window functions SQL exercise'. Good: 'SQL: rank users by transaction value with DENSE_RANK'. For notes.md commits, surface the core insight, not just 'update notes'.
- Body: 3 lines max.
  Line 1: what concept or technique was practiced and what business question it answers.
  Line 2: what clicked, what was tricky, or what pattern will stick — the real learning signal.
  Line 3: what this session sets up next — show the progression, not just task completion.

IMPORTANT: This repo is public and will be seen by hiring managers and senior analysts. Write like someone who is serious about their craft and intentional about their growth. Never describe file mechanics (added X lines, updated Y file) — describe the analytical skill being built. Do NOT mention README updates, script changes, or folder structure changes unless they are the only thing committed.

If only non-deliverable files changed (scripts, config, README), write a short housekeeping commit message instead.

Voice: direct, sharp, no fluff, no corporate language, no emojis, lowercase where it feels natural. Reads like a focused analyst, not a task log.

Output the commit message only. Nothing else. No explanation.")

echo "Proposed commit message:"
echo "---"
echo "$COMMIT_MSG"
echo "---"
echo ""

# Ask for confirmation before committing
read -p "Commit with this message? (y/n): " CONFIRM

if [ "$CONFIRM" = "y" ]; then
  git commit -m "$COMMIT_MSG"
  git push origin main
  echo ""
  echo "Done. Committed and pushed."
else
  echo "Cancelled. Nothing committed."
  git reset HEAD .
fi