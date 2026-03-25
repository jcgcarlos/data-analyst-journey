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
# AUTO-UPDATE README FILES
# Detects which folder(s) have new/changed files
# and asks Claude to update the corresponding README
# ----------------------------------------

# Check for new or changed Python files
PYTHON_CHANGES=$(echo "$DIFF_DETAIL" | grep "^python/" | grep -v "README.md" || true)

# Check for new or changed SQL files
SQL_CHANGES=$(echo "$DIFF_DETAIL" | grep "^sql/" | grep -v "README.md" || true)

if [ -n "$PYTHON_CHANGES" ]; then
  echo "Python changes detected. Updating python/README.md..."

  # Get current README content
  CURRENT_README=$(cat python/README.md 2>/dev/null || echo "")

  # Get the current folder structure
  FOLDER_TREE=$(find python -type f -name "*.ipynb" -o -name "*.py" | sort)

  # Get diff content of the changed files (first 500 lines to stay within limits)
  CHANGED_CONTENT=$(git diff --staged -- $PYTHON_CHANGES | head -500)

  claude -p "You are updating the python/README.md for JC's data-analyst-journey portfolio repo.

Here is the current README:
$CURRENT_README

Here are ALL .ipynb and .py files currently in the python folder:
$FOLDER_TREE

Here is the diff of what changed this session:
$CHANGED_CONTENT

Your job:
1. Update the 'Folder Structure' section to reflect the current file tree exactly (include all files and subfolders).
2. If there are NEW files that don't appear in the 'Concepts Covered' table yet, add a row for each one. For each new row:
   - File: the filename
   - Concept: read the diff to identify what Python concept the notebook covers
   - Business Context: infer a short BI/BA business context from the exercises or content
3. Do NOT remove or change existing rows unless the filename changed.
4. Do NOT change the About section, structure section, or any other part of the README.
5. Output the complete updated README.md content. Nothing else — no explanation, no markdown fences." > python/README.md

  echo "python/README.md updated."
  git add python/README.md
  echo ""
fi

if [ -n "$SQL_CHANGES" ]; then
  echo "SQL changes detected. Updating sql/README.md..."

  CURRENT_README=$(cat sql/README.md 2>/dev/null || echo "")

  FOLDER_TREE=$(find sql -type f -name "*.sql" | sort)

  CHANGED_CONTENT=$(git diff --staged -- $SQL_CHANGES | head -500)

  claude -p "You are updating the sql/README.md for JC's data-analyst-journey portfolio repo.

Here is the current README:
$CURRENT_README

Here are ALL .sql files currently in the sql folder:
$FOLDER_TREE

Here is the diff of what changed this session:
$CHANGED_CONTENT

Your job:
1. Update the 'Folder Structure' section to reflect the current file tree exactly.
2. If there are NEW files that don't appear in the 'Concepts Covered' table yet, add a row for each one. For each new row:
   - File: the filename
   - Concept: read the diff to identify what SQL concept the file covers
   - Business Context: infer a short business context from the queries
3. Do NOT remove or change existing rows unless the filename changed.
4. Do NOT change the About section, structure section, dataset section, or any other part of the README.
5. Output the complete updated README.md content. Nothing else — no explanation, no markdown fences." > sql/README.md

  echo "sql/README.md updated."
  git add sql/README.md
  echo ""
fi

# ----------------------------------------
# GENERATE COMMIT MESSAGE
# ----------------------------------------

# Re-capture diff detail after README updates
DIFF_DETAIL=$(git diff --staged --name-only)
DIFF_STAT=$(git diff --staged --stat)

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