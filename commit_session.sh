#!/bin/bash

# ----------------------------------------
# Study Session Commit Script
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

# Filter to only study files (exclude READMEs, scripts, config)
STUDY_FILES=$(echo "$DIFF_DETAIL" | grep -v "README.md" | grep -v "commit_session.sh" | grep -v ".txt" || true)

# If there are study files, get their diff for context
if [ -n "$STUDY_FILES" ]; then
  STUDY_DIFF=$(git diff --staged -- $STUDY_FILES | head -500)
else
  STUDY_DIFF=""
fi

COMMIT_MSG=$(claude -p "You are writing a Git commit message for JC, a BI Specialist upskilling toward a Senior Data Analyst role. JC studies SQL, Python, Statistics, and Looker/LookML.

Here are ALL files changed this session:
$DIFF_DETAIL

Here are the STUDY files only (ignore README and script changes):
$STUDY_FILES

Here is the diff of the study files:
$STUDY_DIFF

Write a Git commit message with:
- Subject line: max 50 chars, direct, says exactly what was studied or practiced. Examples: 'Add SQL subquery practice - FROM clause', 'Python loops session 3 - list iteration'
- Body: 3 lines max. Line 1: what topic or concept was covered. Line 2: what actually got done or what clicked. Line 3: one honest note about what was tricky or what clicked.

IMPORTANT: The commit message should highlight what JC LEARNED or PRACTICED this session. Do NOT mention README updates, script changes, or folder structure changes — those are automated housekeeping. Focus entirely on the study content.

If no study files changed (only README or scripts), write a short housekeeping commit message instead.

Voice: write like JC texts a colleague. Direct, no fluff, no corporate language, no emojis, lowercase where it feels natural. Sound like a person, not a changelog.

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