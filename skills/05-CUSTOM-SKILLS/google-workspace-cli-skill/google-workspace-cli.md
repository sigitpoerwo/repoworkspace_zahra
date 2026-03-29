---
name: google-workspace-cli
description: Automate Google Workspace (Drive, Gmail, Calendar, Sheets, Docs) via CLI. Use for bulk operations, teaching automation, grading workflows, or AI agent integration.
---

# Google Workspace CLI (`gws`): Unified Workspace Automation

## When to Use This Skill

**Trigger this skill when:**
- User asks to "automate Google Drive/Gmail/Calendar/Sheets"
- User wants to "bulk create folders/emails/events"
- User mentions "grade distribution" or "student management"
- User asks to "send bulk emails" or "manage calendar"
- User needs to "export/import Google Workspace data"
- User wants to "integrate with Google APIs"
- User mentions "teaching automation" or "classroom management"

**DO NOT trigger when:**
- Simple one-time tasks (use web interface instead)
- User prefers GUI over CLI
- No Google Workspace account available
- Task requires real-time collaboration (use web interface)

## Core Workflow

### Step 1: Identify Task Category

Determine which Google Workspace service is needed:

1. **Drive** → File/folder management, sharing, export
2. **Gmail** → Email sending, filtering, labeling
3. **Calendar** → Event creation, scheduling, reminders
4. **Sheets** → Spreadsheet creation, data manipulation
5. **Docs** → Document creation, editing, formatting
6. **Chat** → Team messaging, notifications
7. **Multi-Service** → Cross-service workflows

### Step 2: Check Authentication

Verify user has:
- Google Cloud Project (or can create one)
- Google Workspace account
- `gws` CLI installed
- Authenticated via OAuth

### Step 3: Execute Workflow

Follow the appropriate workflow based on task category.

## Installation & Setup

### Prerequisites

```bash
# Check Node.js version (18+ required)
node --version

# If not installed, download from: https://nodejs.org/
```

### Installation

```bash
# Option 1: npm (recommended)
npm install -g @googleworkspace/cli

# Option 2: Homebrew (macOS/Linux)
brew install googleworkspace-cli

# Option 3: Cargo (from source)
cargo install --git https://github.com/googleworkspace/cli --locked

# Verify installation
gws --version
```

### Authentication Setup

**Method 1: Automated Setup (Fastest)**
```bash
# Requires gcloud CLI installed
gws auth setup     # Creates GCP project, enables APIs, logs in
gws auth login     # Subsequent logins
```

**Method 2: Manual Setup**
```bash
# 1. Create Google Cloud Project
# Go to: https://console.cloud.google.com/

# 2. Enable APIs
# Go to: https://console.cloud.google.com/apis/library

# 3. Create OAuth Client
# Go to: https://console.cloud.google.com/apis/credentials
# Type: Desktop app
# Download JSON to: ~/.config/gws/client_secret.json

# 4. Add yourself as test user
# Go to: https://console.cloud.google.com/apis/credentials/consent
# Add your email under "Test users"

# 5. Login
gws auth login
```

**Method 3: Service Account (CI/CD)**
```bash
# Export credentials from authenticated machine
gws auth export --unmasked > credentials.json

# On target machine
export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/path/to/credentials.json
gws drive files list  # Works without login
```

### Scope Selection

```bash
# For unverified apps (testing mode), limit scopes to avoid 25-scope limit
gws auth login -s drive,gmail,sheets,calendar

# Available services:
# drive, gmail, calendar, sheets, docs, chat, admin, classroom, forms, slides
```

## Workflows for Lecturers

### Workflow A: Bulk Email to Students

**Use Case:** Send announcements, reminders, or notifications to class

**Input:** Recipient list, subject, message body

**Process:**
```bash
# 1. Prepare message
cat > message.json <<EOF
{
  "to": "class-spring-2024@university.edu",
  "subject": "Reminder: Assignment Due Tomorrow",
  "body": "Dear Students,\n\nThis is a reminder that Assignment 3 is due tomorrow at 11:59 PM.\n\nBest regards,\nProf. [Name]"
}
EOF

# 2. Send email
gws gmail messages send --json "$(cat message.json)"

# 3. Verify sent
gws gmail messages list --params '{"q":"from:me subject:Reminder","maxResults":1}'
```

**Output:** Email sent to all recipients

**Example:**
```
User: "Send reminder email to my class about tomorrow's deadline"

Process:
1. Prepare email content
2. Use gws gmail messages send
3. Confirm delivery

Result: Email sent to class-spring-2024@university.edu
```

### Workflow B: Create Assignment Folders

**Use Case:** Organize student submissions by week/topic

**Input:** Number of weeks/assignments, naming pattern

**Process:**
```bash
# 1. Create parent folder
PARENT_ID=$(gws drive files create \
  --json '{"name":"Spring-2024-Assignments","mimeType":"application/vnd.google-apps.folder"}' \
  | jq -r '.id')

# 2. Create weekly folders
for week in {1..14}; do
  gws drive files create \
    --json "{
      \"name\":\"Week-$week-Assignment\",
      \"mimeType\":\"application/vnd.google-apps.folder\",
      \"parents\":[\"$PARENT_ID\"]
    }"
  echo "Created: Week-$week-Assignment"
done

# 3. Share with students (view-only)
gws drive permissions create \
  --file-id "$PARENT_ID" \
  --json '{"type":"user","role":"reader","emailAddress":"class-2024@university.edu"}'
```

**Output:** 14 organized folders ready for submissions

**Example:**
```
User: "Create folders for 14 weeks of assignments"

Process:
1. Create parent folder "Spring-2024-Assignments"
2. Loop create Week-1 through Week-14 folders
3. Share with class email

Result: Organized folder structure in Google Drive
```

### Workflow C: Grade Distribution via Sheets

**Use Case:** Create and update grade spreadsheet

**Input:** Student list, assignment scores

**Process:**
```bash
# 1. Create spreadsheet
SHEET_ID=$(gws sheets spreadsheets create \
  --json '{"properties":{"title":"Grades-Spring-2024"}}' \
  | jq -r '.spreadsheetId')

# 2. Add headers
gws sheets spreadsheets values update \
  --spreadsheet-id "$SHEET_ID" \
  --range "Sheet1!A1:F1" \
  --json '{
    "values":[["Student ID","Name","Midterm","Final","Project","Total"]]
  }'

# 3. Add student data (from CSV)
gws sheets spreadsheets values append \
  --spreadsheet-id "$SHEET_ID" \
  --range "Sheet1!A2" \
  --json "{\"values\":$(cat students.csv | jq -R -s -c 'split(\"\n\") | map(split(\",\"))')}"

# 4. Add formula for total
gws sheets spreadsheets batchUpdate \
  --spreadsheet-id "$SHEET_ID" \
  --json '{
    "requests":[{
      "repeatCell":{
        "range":{"sheetId":0,"startRowIndex":1,"startColumnIndex":5,"endColumnIndex":6},
        "cell":{"userEnteredValue":{"formulaValue":"=C2+D2+E2"}},
        "fields":"userEnteredValue"
      }
    }]
  }'

# 5. Share with TAs
gws sheets spreadsheets permissions create \
  --spreadsheet-id "$SHEET_ID" \
  --json '{"type":"user","role":"writer","emailAddress":"ta@university.edu"}'

# 6. Get shareable link
echo "Spreadsheet URL: https://docs.google.com/spreadsheets/d/$SHEET_ID"
```

**Output:** Grade spreadsheet with formulas and sharing configured

**Example:**
```
User: "Create grade spreadsheet for my class with automatic total calculation"

Process:
1. Create new spreadsheet
2. Add headers (Student ID, Name, Midterm, Final, Project, Total)
3. Import student list
4. Add SUM formula for Total column
5. Share with TAs

Result: Collaborative grade tracking spreadsheet
```

### Workflow D: Calendar Management

**Use Case:** Schedule office hours, lectures, deadlines

**Input:** Event details, recurrence pattern

**Process:**
```bash
# 1. Create recurring office hours
gws calendar events insert \
  --calendar-id primary \
  --json '{
    "summary":"Office Hours",
    "description":"Drop-in for questions and discussions",
    "start":{"dateTime":"2024-03-25T14:00:00","timeZone":"America/New_York"},
    "end":{"dateTime":"2024-03-25T16:00:00","timeZone":"America/New_York"},
    "recurrence":["RRULE:FREQ=WEEKLY;BYDAY=MO,WE;COUNT=14"],
    "reminders":{"useDefault":false,"overrides":[{"method":"email","minutes":60}]}
  }'

# 2. Create assignment deadlines
for week in {1..14}; do
  DATE=$(date -d "2024-03-25 +$((week*7)) days" +%Y-%m-%d)
  gws calendar events insert \
    --calendar-id primary \
    --json "{
      \"summary\":\"Assignment $week Due\",
      \"start\":{\"date\":\"$DATE\"},
      \"end\":{\"date\":\"$DATE\"},
      \"reminders\":{\"useDefault\":false,\"overrides\":[{\"method\":\"email\",\"minutes\":1440}]}
    }"
done

# 3. Share calendar with students (read-only)
gws calendar acl insert \
  --calendar-id primary \
  --json '{"role":"reader","scope":{"type":"user","value":"class-2024@university.edu"}}'

# 4. Export calendar to share link
CALENDAR_ID=$(gws calendar calendarList list | jq -r '.items[] | select(.summary=="primary") | .id')
echo "Calendar URL: https://calendar.google.com/calendar/embed?src=$CALENDAR_ID"
```

**Output:** Organized calendar with recurring events and deadlines

**Example:**
```
User: "Set up office hours every Monday and Wednesday for the semester"

Process:
1. Create recurring event (14 weeks)
2. Set time: 2-4 PM
3. Add email reminder 1 hour before
4. Share calendar with class

Result: Automated office hours schedule
```

### Workflow E: Document Generation

**Use Case:** Create syllabus, handouts, or templates

**Input:** Document content, formatting requirements

**Process:**
```bash
# 1. Create document from template
DOC_ID=$(gws docs documents create \
  --json '{"title":"Syllabus-Spring-2024-CS101"}' \
  | jq -r '.documentId')

# 2. Add content
gws docs documents batchUpdate \
  --document-id "$DOC_ID" \
  --json '{
    "requests":[
      {
        "insertText":{
          "location":{"index":1},
          "text":"CS 101: Introduction to Computer Science\nSpring 2024\n\nInstructor: Prof. [Name]\nOffice Hours: Mon/Wed 2-4 PM\n\nCourse Description:\nThis course introduces fundamental concepts...\n"
        }
      }
    ]
  }'

# 3. Format title
gws docs documents batchUpdate \
  --document-id "$DOC_ID" \
  --json '{
    "requests":[
      {
        "updateTextStyle":{
          "range":{"startIndex":1,"endIndex":50},
          "textStyle":{"bold":true,"fontSize":{"magnitude":16,"unit":"PT"}},
          "fields":"bold,fontSize"
        }
      }
    ]
  }'

# 4. Export to PDF
gws drive files export \
  --file-id "$DOC_ID" \
  --mime-type "application/pdf" \
  > syllabus.pdf

# 5. Share with students
gws drive permissions create \
  --file-id "$DOC_ID" \
  --json '{"type":"user","role":"reader","emailAddress":"class-2024@university.edu"}'

echo "Document URL: https://docs.google.com/document/d/$DOC_ID"
```

**Output:** Formatted document shared with class

**Example:**
```
User: "Create and share course syllabus with my students"

Process:
1. Create new Google Doc
2. Add syllabus content
3. Format title and headers
4. Export PDF copy
5. Share with class email

Result: Syllabus accessible to all students
```

## Advanced Use Cases

### Use Case 1: Automated Attendance Tracking

```bash
# Create attendance spreadsheet
SHEET_ID=$(gws sheets spreadsheets create \
  --json '{"properties":{"title":"Attendance-Spring-2024"}}' \
  | jq -r '.spreadsheetId')

# Add student list and dates
gws sheets spreadsheets values update \
  --spreadsheet-id "$SHEET_ID" \
  --range "Sheet1!A1:Z1" \
  --json '{
    "values":[["Student Name","Week 1","Week 2","Week 3","..."]]
  }'

# Import student names
gws sheets spreadsheets values append \
  --spreadsheet-id "$SHEET_ID" \
  --range "Sheet1!A2" \
  --json "{\"values\":$(cat students.txt | jq -R -s -c 'split(\"\n\") | map([.])')}"

# Add conditional formatting (red for absent)
gws sheets spreadsheets batchUpdate \
  --spreadsheet-id "$SHEET_ID" \
  --json '{
    "requests":[{
      "addConditionalFormatRule":{
        "rule":{
          "ranges":[{"sheetId":0,"startRowIndex":1,"startColumnIndex":1}],
          "booleanRule":{
            "condition":{"type":"TEXT_EQ","values":[{"userEnteredValue":"Absent"}]},
            "format":{"backgroundColor":{"red":1,"green":0.8,"blue":0.8}}
          }
        }
      }
    }]
  }'
```

### Use Case 2: Batch Convert Documents

```bash
# Find all DOCX files
FILES=$(gws drive files list \
  --params '{"q":"mimeType=\"application/vnd.openxmlformats-officedocument.wordprocessingml.document\""}' \
  | jq -r '.files[] | .id')

# Convert each to PDF
for FILE_ID in $FILES; do
  FILENAME=$(gws drive files get --file-id "$FILE_ID" | jq -r '.name')
  gws drive files export \
    --file-id "$FILE_ID" \
    --mime-type "application/pdf" \
    > "${FILENAME%.docx}.pdf"
  echo "Converted: $FILENAME"
done
```

### Use Case 3: Email Triage & Auto-Response

```bash
# Find unread emails from students
UNREAD=$(gws gmail messages list \
  --params '{"q":"is:unread from:@university.edu","maxResults":50}' \
  | jq -r '.messages[] | .id')

# Auto-reply with acknowledgment
for MSG_ID in $UNREAD; do
  # Get sender
  SENDER=$(gws gmail messages get --id "$MSG_ID" \
    | jq -r '.payload.headers[] | select(.name=="From") | .value')

  # Send auto-reply
  gws gmail messages send --json "{
    \"to\":\"$SENDER\",
    \"subject\":\"Re: Your Email\",
    \"body\":\"Thank you for your email. I will respond within 24 hours.\"
  }"

  # Mark as read
  gws gmail messages modify \
    --id "$MSG_ID" \
    --json '{"removeLabelIds":["UNREAD"]}'
done
```

### Use Case 4: Backup Google Drive

```bash
# Create backup directory
mkdir -p drive-backup

# List all files
gws drive files list --page-all \
  | jq -r '.files[] | "\(.id)|\(.name)|\(.mimeType)"' \
  > file-list.txt

# Download each file
while IFS='|' read -r FILE_ID FILENAME MIMETYPE; do
  if [[ "$MIMETYPE" != *"google-apps"* ]]; then
    # Regular file - download directly
    gws drive files get --file-id "$FILE_ID" --alt media > "drive-backup/$FILENAME"
  else
    # Google Workspace file - export as PDF
    gws drive files export --file-id "$FILE_ID" --mime-type "application/pdf" \
      > "drive-backup/${FILENAME}.pdf"
  fi
  echo "Backed up: $FILENAME"
done < file-list.txt
```

## Best Practices

### ✅ DO

**1. Use Dry Run for Testing**
```bash
# Preview request before executing
gws gmail messages send \
  --json '{"to":"test@example.com","subject":"Test"}' \
  --dry-run

# Output shows exact API request
```

**2. Handle Pagination Properly**
```bash
# Stream all results as NDJSON
gws drive files list --page-all | jq -r '.files[].name'

# Or manually paginate
gws drive files list --params '{"pageSize":100,"pageToken":"..."}'
```

**3. Use Schema Introspection**
```bash
# Understand request/response structure
gws schema drive.files.create
gws schema gmail.messages.send

# Shows required fields and types
```

**4. Store Credentials Securely**
```bash
# Use OS keyring (default)
gws auth login

# Or encrypted file
export GOOGLE_WORKSPACE_CLI_KEYRING_BACKEND=file
gws auth login

# Never commit credentials to git
echo "credentials.json" >> .gitignore
```

**5. Batch Operations Efficiently**
```bash
# Use batchUpdate for multiple changes
gws sheets spreadsheets batchUpdate \
  --spreadsheet-id "$SHEET_ID" \
  --json '{
    "requests":[
      {"updateCells":{...}},
      {"mergeCells":{...}},
      {"autoResizeDimensions":{...}}
    ]
  }'
```

### ❌ DON'T

**1. Don't Hardcode Credentials**
```bash
# BAD
export GOOGLE_WORKSPACE_CLI_TOKEN="ya29.a0..."

# GOOD
gws auth login  # Stores encrypted
```

**2. Don't Ignore Rate Limits**
```bash
# BAD - rapid fire requests
for i in {1..1000}; do
  gws gmail messages send ...
done

# GOOD - add delays
for i in {1..1000}; do
  gws gmail messages send ...
  sleep 1  # Respect rate limits
done
```

**3. Don't Skip Error Handling**
```bash
# BAD
gws drive files create --json '...'

# GOOD
if gws drive files create --json '...'; then
  echo "Success"
else
  echo "Failed with exit code: $?"
  # Handle error
fi
```

**4. Don't Use Unverified Apps in Production**
```bash
# For production, verify your OAuth app:
# 1. Go to Google Cloud Console
# 2. OAuth consent screen
# 3. Submit for verification
# 4. Wait for approval (1-2 weeks)
```

## Teaching Integration

### Course Module: Google Workspace Automation

**Learning Objectives:**
- Understand REST API concepts
- Learn OAuth authentication flow
- Practice CLI automation
- Develop scripting skills

**Week 1: Introduction & Setup**
```
Lecture (2 hours):
- What is Google Workspace API?
- CLI vs GUI vs API
- Demo: gws basics

Lab (2 hours):
- Install gws CLI
- Setup OAuth authentication
- First API call (list files)

Assignment:
- Create personal Drive folder structure
- Document setup process
- Submit screenshot of successful auth
```

**Week 2: Drive Automation**
```
Lecture (2 hours):
- File management APIs
- Folder organization
- Sharing & permissions

Lab (2 hours):
- Create folder hierarchy
- Upload files programmatically
- Share with specific users

Assignment:
- Build script to organize files by type
- Implement backup workflow
- Share folder with instructor
```

**Week 3: Email Automation**
```
Lecture (2 hours):
- Gmail API overview
- Email composition
- Filtering & labeling

Lab (2 hours):
- Send automated emails
- Create filters
- Implement auto-responder

Assignment:
- Build email notification system
- Implement triage workflow
- Document use cases
```

**Week 4: Calendar & Sheets**
```
Lecture (2 hours):
- Calendar event management
- Spreadsheet manipulation
- Data import/export

Lab (2 hours):
- Create recurring events
- Generate reports in Sheets
- Export data to CSV

Assignment:
- Build personal task tracker
- Integrate calendar with Sheets
- Create dashboard
```

**Final Project:**
Students build complete automation system:
- Email notifications
- Calendar scheduling
- Grade tracking in Sheets
- Document generation
- Drive organization

**Grading Rubric:**
- Setup & Authentication (10%)
- Code Quality (20%)
- Functionality (30%)
- Documentation (20%)
- Presentation (20%)

## Troubleshooting

### Issue: Authentication Fails

**Symptoms:**
- "Access blocked" error
- "App not verified" warning
- Scope consent fails

**Diagnosis:**
```bash
# Check if you're added as test user
# Go to: https://console.cloud.google.com/apis/credentials/consent
# Verify your email is under "Test users"

# Check scope limits (unverified apps max 25 scopes)
gws auth login -s drive,gmail  # Limit to specific services
```

**Solution:**
```bash
# 1. Add yourself as test user in GCP Console
# 2. Use limited scopes for unverified apps
gws auth login -s drive,gmail,sheets,calendar

# 3. Or verify your app (production)
# Submit for verification in OAuth consent screen
```

### Issue: Rate Limit Exceeded

**Symptoms:**
- "429 Too Many Requests" error
- API calls failing intermittently

**Diagnosis:**
```bash
# Check quota usage
# Go to: https://console.cloud.google.com/apis/dashboard

# View rate limits per API
```

**Solution:**
```bash
# Add exponential backoff
retry_with_backoff() {
  local max_attempts=5
  local timeout=1
  local attempt=1

  while [ $attempt -le $max_attempts ]; do
    if "$@"; then
      return 0
    fi

    echo "Attempt $attempt failed. Retrying in ${timeout}s..."
    sleep $timeout
    timeout=$((timeout * 2))
    attempt=$((attempt + 1))
  done

  return 1
}

# Usage
retry_with_backoff gws gmail messages send --json '...'
```

### Issue: Large File Upload Fails

**Symptoms:**
- Upload timeout
- Connection reset
- Incomplete upload

**Diagnosis:**
```bash
# Check file size
ls -lh large-file.zip

# Check network stability
ping -c 10 www.google.com
```

**Solution:**
```bash
# Use resumable upload for files > 5MB
gws drive files create \
  --json '{"name":"large-file.zip"}' \
  --media large-file.zip \
  --resumable

# Or split into chunks
split -b 10M large-file.zip chunk_
for chunk in chunk_*; do
  gws drive files create --json "{\"name\":\"$chunk\"}" --media "$chunk"
done
```

### Issue: JSON Parsing Errors

**Symptoms:**
- "Invalid JSON" error
- Unexpected characters
- Syntax errors

**Diagnosis:**
```bash
# Validate JSON before sending
echo '{"test":"value"}' | jq .

# Check for special characters
cat data.json | grep -E '[^[:print:]]'
```

**Solution:**
```bash
# Use jq to format JSON properly
jq -n '{
  "to": "user@example.com",
  "subject": "Test",
  "body": "Message"
}' | gws gmail messages send --json @-

# Or use heredoc
gws gmail messages send --json "$(cat <<EOF
{
  "to": "user@example.com",
  "subject": "Test",
  "body": "Message"
}
EOF
)"
```

## Advanced Features

### Feature 1: Workflow Helpers

```bash
# Built-in workflow commands (prefixed with +)
gws workflow +standup-report    # Today's meetings + tasks
gws workflow +meeting-prep      # Next meeting context
gws gmail +triage              # Unread inbox summary
gws calendar +today            # Today's schedule
gws drive +recent              # Recently modified files
```

### Feature 2: AI Agent Integration

```bash
# Structured JSON output for LLM consumption
gws drive files list --format json | llm process

# Use with Claude Code
# Skills available in: .agent/ directory

# Use with Gemini CLI
# Extensions available in: .gemini/ directory
```

### Feature 3: Custom Scripts

```bash
# Create reusable automation scripts
cat > grade-distribution.sh <<'EOF'
#!/bin/bash
SHEET_ID="$1"
GRADES_CSV="$2"

# Import grades
gws sheets spreadsheets values update \
  --spreadsheet-id "$SHEET_ID" \
  --range "Sheet1!A2" \
  --json "{\"values\":$(cat "$GRADES_CSV" | jq -R -s -c 'split(\"\n\") | map(split(\",\"))')}"

# Calculate statistics
gws sheets spreadsheets batchUpdate \
  --spreadsheet-id "$SHEET_ID" \
  --json '{
    "requests":[{
      "updateCells":{
        "range":{"sheetId":0,"startRowIndex":0,"startColumnIndex":6,"endColumnIndex":7},
        "rows":[
          {"values":[{"userEnteredValue":{"formulaValue":"=AVERAGE(C:C)"}}]},
          {"values":[{"userEnteredValue":{"formulaValue":"=MEDIAN(C:C)"}}]},
          {"values":[{"userEnteredValue":{"formulaValue":"=STDEV(C:C)"}}]}
        ],
        "fields":"userEnteredValue"
      }
    }]
  }'

echo "Grades imported and statistics calculated"
EOF

chmod +x grade-distribution.sh
./grade-distribution.sh "SHEET_ID" "grades.csv"
```

### Feature 4: CI/CD Integration

```bash
# GitHub Actions example
name: Backup Drive
on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - name: Install gws
        run: npm install -g @googleworkspace/cli

      - name: Authenticate
        env:
          GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE: ${{ secrets.GWS_CREDENTIALS }}
        run: |
          echo "$GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE" > /tmp/creds.json
          export GOOGLE_WORKSPACE_CLI_CREDENTIALS_FILE=/tmp/creds.json

      - name: Backup files
        run: |
          gws drive files list --page-all > backup-$(date +%Y%m%d).json

      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: drive-backup
          path: backup-*.json
```

## Resources

### Official Documentation
- Repository: https://github.com/googleworkspace/cli
- Issues: https://github.com/googleworkspace/cli/issues
- Releases: https://github.com/googleworkspace/cli/releases

### Google Workspace APIs
- Drive API: https://developers.google.com/drive/api
- Gmail API: https://developers.google.com/gmail/api
- Calendar API: https://developers.google.com/calendar/api
- Sheets API: https://developers.google.com/sheets/api
- Docs API: https://developers.google.com/docs/api

### Community Resources
- Stack Overflow: [google-workspace-cli] tag
- Reddit: r/googleworkspace
- Discord: Google Workspace Developers

### Related Tools
- **gcloud CLI**: Google Cloud Platform management
- **gsutil**: Google Cloud Storage CLI
- **clasp**: Google Apps Script CLI
- **gdrive**: Alternative Drive CLI

## Security Considerations

### Data Privacy
- Never share OAuth credentials
- Use service accounts for automation
- Implement least-privilege access
- Audit API usage regularly

### Access Control
```bash
# Review granted permissions
gws auth info

# Revoke access
gws auth logout

# Rotate credentials periodically
gws auth login --force
```

### Compliance
- FERPA (student data): Encrypt at rest, limit access
- GDPR: Document data processing, enable deletion
- HIPAA: Use service accounts, audit logs

## Performance Optimization

### Batch Operations
```bash
# Instead of multiple single requests
for id in $FILE_IDS; do
  gws drive files delete --file-id "$id"
done

# Use batch delete
gws drive files batchDelete --json "{\"ids\":$(echo $FILE_IDS | jq -R -s -c 'split(\" \")')}"
```

### Caching
```bash
# Cache frequently accessed data
CACHE_FILE="/tmp/drive-files-cache.json"
CACHE_TTL=3600  # 1 hour

if [ ! -f "$CACHE_FILE" ] || [ $(($(date +%s) - $(stat -f %m "$CACHE_FILE"))) -gt $CACHE_TTL ]; then
  gws drive files list --page-all > "$CACHE_FILE"
fi

cat "$CACHE_FILE" | jq '.files[] | select(.name | contains("Assignment"))'
```

### Parallel Processing
```bash
# Process files in parallel
FILE_IDS=$(gws drive files list | jq -r '.files[] | .id')

echo "$FILE_IDS" | xargs -P 4 -I {} bash -c '
  gws drive files export --file-id {} --mime-type "application/pdf" > {}.pdf
'
```

## Success Metrics

### For Teaching
- Time saved on administrative tasks
- Student engagement with automation
- Number of automated workflows created
- Reduction in manual errors

### For Research
- Data collection efficiency
- Collaboration effectiveness
- Reproducibility of workflows
- Documentation quality

## Conclusion

Google Workspace CLI (`gws`) is a powerful tool for automating Google Workspace tasks. When used effectively, it significantly reduces manual work, improves consistency, and enables advanced workflows that would be impractical through the web interface.

**Key Takeaways:**
- Start with simple tasks (list files, send email)
- Build up to complex workflows (grade distribution, calendar management)
- Use dry-run to test before executing
- Implement error handling and retries
- Document your automation scripts

**Remember:** `gws` is a tool to amplify your productivity, not replace critical thinking. Always review automated actions, especially those affecting student data or grades.

---

**Skill Version:** 1.0
**Last Updated:** 2026-03-22
**Repository:** https://github.com/googleworkspace/cli
**Maintained by:** Zahra Maurita
