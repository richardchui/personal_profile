# Personal Profile Application - User Requirements Specification

**Document Version:** 2.0
**Date:** 2025-12-29
**Project Type:** Flutter Web/Mobile Application with Firebase Backend
**Target Audience:** AI Development Tool

---

## 1. Executive Summary

Build a Flutter-based personal profile management application that allows users to create, view, and edit detailed personal profiles with password protection. The application must support third-party contributions from teachers, therapists, and other professionals through a token-based system. Deploy the web version on Firebase Hosting and support iOS mobile platforms.

### 1.1 Key Objectives
- Enable users to create and manage personal profiles with multiple information sections
- Provide password-protected editing with open viewing access
- Allow third-party professionals to contribute reports without accessing existing profile data
- Provide API access for external applications with API key authentication
- Support 3 languages: English, Traditional Chinese (繁體中文), Simplified Chinese (简体中文)
- Deploy web app on Firebase Hosting with global CDN
- Support iOS mobile platform
- Implement caregiver-friendly features for ease of use

---

## 2. System Architecture

### 2.1 Technology Constraints

The following technologies are **mandatory** for this project:

**Frontend Framework:**
- Flutter SDK 3.0 or higher
- Dart programming language

**Backend Platform:**
- Firebase (Firestore database, Hosting, Cloud Functions or Cloud Run)

**Platform Support:**
- Primary: Web browser (desktop and mobile)
- Secondary: iOS native app

**Internationalization:**
- Must support English, Traditional Chinese, Simplified Chinese
- Use ARB format for localization files

### 2.2 Recommended Technologies

The following are **suggested** but can be replaced with alternatives:

**State Management:**
- Provider package (alternatives: Riverpod, Bloc, GetX acceptable)

**Navigation:**
- go_router package (alternatives: Navigator 2.0, auto_route acceptable)

**API Implementation:**
- FastAPI with Python (alternatives: Express.js, Cloud Functions acceptable)

### 2.3 Architecture Pattern

The application should follow a layered architecture separating:
- **Presentation Layer** - UI screens and widgets
- **State Management Layer** - Application state and business logic
- **Service Layer** - Backend communication and data operations
- **Backend Layer** - Firebase services (Firestore, Authentication, Hosting)

---

## 3. Functional Requirements

### 3.1 User Profile Management

#### 3.1.1 Create Profile

**User Story:**
As a user, I want to create a new profile with a unique ID and password so that I can manage my personal information securely.

**Acceptance Criteria:**
- [ ] System displays privacy warning about profile ID before user enters it
- [ ] User can enter a profile ID (5-15 alphanumeric characters)
- [ ] User can enter a password (5-15 characters, any character type)
- [ ] User must confirm password (confirmation must match)
- [ ] System validates profile ID is unique
- [ ] System creates profile in database after validation
- [ ] System automatically navigates to edit mode after successful creation
- [ ] All profile sections are initially empty
- [ ] Clear error messages displayed for validation failures

**Privacy Warning:**
Display prominent warning message to user before or during profile ID entry:
- "Privacy Notice: Choose a profile ID that does not reveal your real identity. Avoid using your name, birthdate, email, phone number, or other personally identifiable information. This ID will be visible when sharing your profile."
- Warning should be clearly visible (highlighted or in distinct color)
- Consider using an icon (⚠️ or 🔒) to draw attention

**Profile ID Strength Indicator:**

The system should provide real-time feedback on the privacy risk level of the profile ID as the user types.

*Risk Levels:*
- **Low Risk (Green)** - Profile ID appears privacy-safe
- **Medium Risk (Yellow)** - Profile ID may contain identifying patterns
- **High Risk (Red)** - Profile ID likely contains personal information

*Heuristic Analysis:*

The system should analyze the profile ID for the following patterns:

1. **Common Name Patterns**
   - Common first names (john, mary, mike, etc.)
   - Common last names (smith, johnson, brown, etc.)
   - Name-like patterns (consecutive capitalization)

2. **Birthdate Patterns**
   - 4-digit years (1980-2025)
   - Date sequences (mmddyyyy, ddmmyyyy, yyyymmdd)
   - Consecutive digits that could be dates (19900115, 010190)

3. **Phone Number Patterns**
   - 7-10 consecutive digits
   - Digit sequences with dashes or dots (555-1234)
   - Country code patterns (+1, 001)

4. **Email Patterns**
   - Contains @ symbol
   - Contains common email domains (gmail, yahoo, hotmail)
   - Patterns like "name@" or "@domain"

5. **Randomness Assessment**
   - Mix of letters and numbers increases safety
   - No dictionary words increases safety
   - No obvious patterns increases safety

*Risk Level Determination:*

- **High Risk**: Contains 2 or more high-risk patterns (name + birthdate, phone pattern, email pattern)
- **Medium Risk**: Contains 1 high-risk pattern OR 2+ medium-risk patterns (single name, year only, common word)
- **Low Risk**: Random-looking combination with good mix of characters and no obvious patterns

*UI Requirements:*
- Display strength indicator below profile ID input field
- Use color-coded visual indicator (bar, badge, or text)
- Update indicator in real-time as user types
- Show risk level label (e.g., "Privacy Risk: Low", "Privacy Risk: Medium", "Privacy Risk: High")
- Optionally show brief explanation of risk (e.g., "Contains year pattern")
- Indicator is **informational only** - does not block profile creation
- User can still create profile even with "High Risk" indicator

*Example Risk Messages:*
- Low Risk: "Good choice! This ID looks privacy-safe."
- Medium Risk: "This ID may contain identifying patterns. Consider using a more random combination."
- High Risk: "Warning: This ID appears to contain personal information. Choose a more private ID to protect your identity."

**Validation Requirements:**
- Profile ID: 5-15 characters, alphanumeric only
- Password: 5-15 characters, any characters allowed
- Password confirmation must exactly match password
- Profile ID must be unique across all profiles

**Profile ID Privacy Guidelines:**

*Good Examples (Privacy-Safe):*
- `user7k9m2` - Random alphanumeric
- `skyblue42` - Non-identifying words + numbers
- `music2025` - Generic interest + year
- `helper88` - Common word + numbers
- `abc123xyz` - Random combination

*Bad Examples (Privacy Risk):*
- ❌ `johnsmith` - Real name
- ❌ `jsmith1990` - Name + birthdate
- ❌ `js19900115` - Initials + birthdate
- ❌ `555-1234` - Phone number pattern
- ❌ `john@email` - Email pattern

**Error Messages:**
- "ID must be between 5 and 15 characters"
- "Password must be between 5 and 15 characters"
- "Passwords do not match"
- "Profile ID already exists"
- "Failed to create profile. Please try again."

#### 3.1.2 View Profile

**User Story:**
As a user, I want to view any profile by entering its ID without authentication so that I can easily share profile information with others.

**Acceptance Criteria:**
- [ ] User can enter any profile ID to view
- [ ] No password required for viewing
- [ ] System displays all profile sections in read-only mode
- [ ] User can navigate between all sections
- [ ] Content cannot be edited in view mode
- [ ] Contributed reports are visible with contributor attribution
- [ ] System shows error if profile does not exist

**Error Messages:**
- "Profile not found"
- "Please enter a profile ID"

#### 3.1.3 Edit Profile

**User Story:**
As a profile owner, I want to edit my profile after authenticating with ID and password so that I can update my information.

**Acceptance Criteria:**
- [ ] User provides profile ID and password to authenticate
- [ ] System validates credentials before granting access
- [ ] System displays all profile sections in editable mode
- [ ] User can modify any section content
- [ ] User can navigate between sections while editing
- [ ] User must explicitly save changes (manual save action)
- [ ] System persists changes to database when saved
- [ ] System displays confirmation message after successful save
- [ ] System shows error if credentials are invalid

**Error Messages:**
- "Invalid ID or password"
- "Failed to update profile. Please try again."

#### 3.1.4 Delete Profile

**User Story:**
As a profile owner, I want to permanently delete my profile so that I can remove all my data from the system.

**Acceptance Criteria:**
- [ ] Delete option only available when user is authenticated (edit mode)
- [ ] System displays confirmation dialog before deletion
- [ ] Confirmation dialog clearly states action is irreversible
- [ ] User can cancel deletion
- [ ] System permanently removes all profile data from database
- [ ] System removes all associated contributor tokens
- [ ] System removes all contributions linked to profile
- [ ] System navigates to home screen after deletion
- [ ] System displays confirmation message

**Confirmation Message:**
- "Are you sure you want to delete this profile? This action cannot be undone."

#### 3.1.5 Duplicate Profile

**User Story:**
As a profile owner, I want to duplicate an existing profile so that I can create a new profile based on existing content without re-entering all information.

**Acceptance Criteria:**
- [ ] Duplicate option only available when user is authenticated (edit mode)
- [ ] User clicks duplicate button to initiate duplication process
- [ ] System prompts user to enter new profile ID (5-15 alphanumeric characters)
- [ ] System prompts user to enter new password (5-15 characters, any character type)
- [ ] System prompts user to confirm new password
- [ ] System validates new profile ID is unique
- [ ] System validates new password meets requirements
- [ ] System validates password confirmation matches
- [ ] System creates new profile with new ID and password
- [ ] System copies all section content from original profile to new profile
- [ ] System does NOT copy contributor tokens (new profile starts with no tokens)
- [ ] System does NOT copy third-party contributions (new profile has no contributions)
- [ ] System displays confirmation message after successful duplication
- [ ] System offers to navigate to new profile's edit mode
- [ ] User can cancel duplication process at any time before creation

**Duplication Scope:**
- **Copied:** All section content (text data in each section)
- **Not Copied:** Contributor tokens, third-party contributions, contributor token history
- **New Data:** Profile ID, password, created timestamp, last modified timestamp

**Validation Requirements:**
- New profile ID: 5-15 characters, alphanumeric only
- New password: 5-15 characters, any characters allowed
- New password confirmation must exactly match new password
- New profile ID must be unique (different from all existing profiles)
- New profile ID must be different from original profile ID

**Error Messages:**
- "ID must be between 5 and 15 characters"
- "Password must be between 5 and 15 characters"
- "Passwords do not match"
- "Profile ID already exists"
- "Failed to duplicate profile. Please try again."
- "New profile ID cannot be the same as the original profile ID"

**UI/UX Considerations:**
- Duplicate button should be clearly distinct from Delete button
- Consider placing duplicate button in edit mode toolbar or settings
- Confirmation dialog should clearly explain what will be copied and what won't
- User should understand that contributor tokens must be regenerated for new profile

### 3.2 Profile Sections

#### 3.2.1 Section Configuration

**User Story:**
As a system administrator, I want sections to be configurable through a JSON file so that I can easily add, remove, or reorder sections without code changes.

**Acceptance Criteria:**
- [ ] Sections are defined in a JSON configuration file
- [ ] Each section has: unique ID, localization key, display order
- [ ] Sections are loaded at application startup
- [ ] Sections display in order specified by configuration
- [ ] Section titles use localized strings based on user language
- [ ] Each section stores free-form text content
- [ ] Adding new sections only requires JSON file update and localization

**Required Section Data Structure (JSON):**
```json
{
  "sections": [
    {
      "id": "unique_section_id",
      "titleKey": "localization.key",
      "order": 1
    }
  ]
}
```

**Default Sections to Include:**
1. Personal Traits (order: 1) - Intelligence, strengths/weaknesses, values, psychological profile (e.g., MBTI), and specific "things they like to hear" or "absolutely cannot say"
2. Health Condition (order: 2) - Medical conditions, allergies, dietary restrictions, diagnosis, and physical capabilities
3. Family & Social (order: 3) - Detailed breakdowns of family members, commitments, and relationships
4. Daily Life (order: 4) - Routines, time availability, and living conditions (location)
5. School & Education (order: 5) - Academic performance, learning style, educational goals, and school-related commitments
6. Important Events (order: 6) - Critical updates like job changes or recent losses

**Note:** AI tool may add additional relevant sections based on typical profile use cases.

#### 3.2.2 Section Navigation

**User Story:**
As a user, I want multiple ways to navigate between sections so that I can quickly access the information I need.

**Acceptance Criteria:**
- [ ] Dropdown/selector shows all available sections
- [ ] User can jump to any section from dropdown
- [ ] Previous button navigates to previous section
- [ ] Next button navigates to next section
- [ ] Previous button is disabled on first section
- [ ] Next button is disabled on last section
- [ ] Progress indicator shows current position (e.g., "2/17")
- [ ] Navigation preserves unsaved changes (with warning if applicable)
- [ ] Section order matches configuration file order

#### 3.2.3 Section Content Editing

**User Story:**
As a user, I want a simple text editor for each section so that I can easily enter and format my information.

**Acceptance Criteria:**
- [ ] Each section provides a multi-line text input field
- [ ] Text field supports line breaks and paragraphs
- [ ] Text field displays section title/header
- [ ] In view mode, text field is read-only (disabled)
- [ ] In edit mode, text field is fully editable
- [ ] Text field displays existing content on load
- [ ] Changes are not saved automatically
- [ ] User must explicitly save changes

**Design Notes:**
- Free-form text input preferred over structured forms
- Keep UI simple for caregivers with limited computer knowledge
- Support for rich text formatting is optional (plain text acceptable)

### 3.3 Third-Party Contributions System

#### 3.3.1 Generate Contributor Token

**User Story:**
As a profile owner, I want to generate access tokens for teachers, therapists, and other professionals so they can submit reports without seeing my existing profile data.

**Acceptance Criteria:**
- [ ] Token generation only available in edit mode (authenticated)
- [ ] User can generate multiple tokens with different permissions
- [ ] User specifies contributor name (required)
- [ ] User selects contributor role from predefined list
- [ ] User selects which sections contributor can write to (multi-select)
- [ ] User can optionally set expiration date
- [ ] System generates unique token (8-12 characters)
- [ ] Token format is human-readable (e.g., "TEACH-X7K9-2M4P")
- [ ] System displays generated token with copy-to-clipboard option
- [ ] System stores token metadata in database
- [ ] User can share token via external means (email, messaging, etc.)

**Contributor Roles:**
- Teacher
- Speech Therapist (ST)
- Occupational Therapist (OT)
- Doctor
- Tutor
- Other

**Token Metadata to Store:**
- Contributor name
- Contributor role
- Allowed sections (array of section IDs)
- Created timestamp
- Expiration timestamp (nullable)
- Active status (boolean)
- Usage count (number of submissions)

**Token Format Requirements:**
- 8-12 characters long
- Combination of uppercase letters and numbers
- Include hyphens for readability
- Must be unique across entire system

#### 3.3.2 Submit Contribution (Contributor Interface)

**User Story:**
As a contributor (teacher/therapist), I want to submit reports using my token without seeing the profile owner's existing data so that I can provide input while respecting privacy. I also want to view my own previous contributions so I can maintain consistency and avoid duplication.

**Acceptance Criteria:**

**Initial Access:**
- [ ] Contributor accesses special URL with token (e.g., `/contribute/:token`)
- [ ] System validates token before showing interface
- [ ] If token invalid/expired/revoked, show error message
- [ ] If token valid, display contributor interface with two sections

**Submission Form:**
- [ ] Form shows profile owner identifier (not full profile)
- [ ] Form shows contributor role (read-only)
- [ ] Form provides dropdown of allowed sections only
- [ ] Form provides multi-line text area for report content
- [ ] System creates contribution entry in database when submitted
- [ ] System increments token usage count
- [ ] System displays success confirmation
- [ ] Contributor can submit multiple reports using same token

**View Own Previous Contributions:**
- [ ] "My Previous Contributions" section visible on contributor interface
- [ ] Shows list of all contributions made using this token
- [ ] Each contribution displays: section name, submission date, content preview
- [ ] Clicking on a contribution shows full content in read-only view
- [ ] Contributions sorted by date (newest first)
- [ ] Clear visual indication that these are read-only (cannot edit past submissions)
- [ ] Empty state message if no previous contributions: "You haven't submitted any reports yet"

**Privacy Boundaries:**
- [ ] Contributor can ONLY view their own contributions (made with this token)
- [ ] Contributor CANNOT view profile owner's content
- [ ] Contributor CANNOT view other contributors' reports
- [ ] Contributor CANNOT edit or delete previous contributions
- [ ] Contributor CANNOT view profile metadata beyond what's necessary

**UI Design:**
- Split view or tabbed interface:
  - Tab 1: "Submit New Report" (submission form)
  - Tab 2: "My Previous Reports" (read-only history)
- Clear distinction between new submission area and history view
- Contribution count badge (e.g., "My Reports (5)")

**Error Messages:**
- "Invalid or expired token"
- "This token has been revoked"
- "Please select a section"
- "Please enter your report"
- "Failed to submit report. Please try again."
- "Failed to load previous contributions. Please try again."

#### 3.3.3 View Contributions (Profile Owner)

**User Story:**
As a profile owner, I want to see all contributions from third parties within their respective sections so that I can review professional input about my profile.

**Acceptance Criteria:**
- [ ] Contributions appear within their assigned sections
- [ ] Each contribution displays: contributor name, role, timestamp, content
- [ ] Contributor role displayed as badge or tag
- [ ] Timestamp formatted in readable format (e.g., "Dec 28, 2025 2:30 PM")
- [ ] Contributions sorted by timestamp (newest first)
- [ ] Contributions visually distinguished from owner's content
- [ ] Contributions visible in both view and edit modes
- [ ] Owner can see all contributions (not filtered by token permissions)

**UI Requirements:**
- Clear visual separation between owner content and contributions
- Contributor attribution prominent and clear
- Timestamp easily readable
- Content clearly displayed

#### 3.3.4 Manage Contributor Tokens

**User Story:**
As a profile owner, I want to view and manage all contributor tokens so that I can control who has access to submit reports.

**Acceptance Criteria:**
- [ ] Token management only available in edit mode
- [ ] System displays list of all tokens ever created
- [ ] Each token shows: partial token code, contributor name, role, created date, expiration, status, usage count
- [ ] Token code partially masked for security (e.g., "TEACH-****-****")
- [ ] User can click to reveal full token
- [ ] User can copy full token to clipboard
- [ ] User can revoke active tokens
- [ ] Revoked tokens cannot be used for new submissions
- [ ] Revoked tokens show "Revoked" status
- [ ] Expired tokens automatically show "Expired" status
- [ ] User can delete tokens (with confirmation)
- [ ] System updates token status in database

**Token Status Types:**
- Active
- Revoked (manually deactivated)
- Expired (past expiration date)

#### 3.3.5 Archive/Delete Contributions

**User Story:**
As a profile owner, I want to archive or delete individual contributions so that I can manage outdated or irrelevant reports.

**Acceptance Criteria:**
- [ ] Each contribution has "Archive" and "Delete" action buttons
- [ ] Actions only visible to profile owner in edit mode
- [ ] Archive sets contribution as hidden (not deleted)
- [ ] Delete permanently removes contribution from database
- [ ] Delete requires confirmation dialog
- [ ] Archived contributions not shown by default
- [ ] User can toggle "Show Archived" to view archived items
- [ ] Archived contributions can be unarchived
- [ ] System updates contribution status in database

### 3.4 API Access for External Applications

#### 3.4.1 Overview

**User Story:**
As a system administrator, I want to issue read-only API keys to external applications so that they can retrieve profile data for integration purposes.

**Use Cases:**
- School management systems retrieving student profiles
- Healthcare portals accessing patient information
- HR systems pulling employee profiles
- Third-party analytics platforms
- Mobile applications built by other developers
- AI systems requiring user context

**Access Model:**
- **System-level API keys**: Managed by administrators, not profile owners
- **Application-based**: Each external application receives its own API key
- **Read-only access**: API keys can only retrieve data, never modify
- **Cross-profile access**: Single API key can access multiple profiles (not scoped to individual profiles)

**Security Requirements:**
- System administrators issue and manage API keys
- **All API keys are read-only** (cannot modify, create, or delete data)
- API keys can optionally be limited to specific sections
- API keys can be revoked at any time by administrators
- All API requests must be logged for audit
- Rate limiting must be enforced to prevent abuse

#### 3.4.2 Generate API Key (Administrator Function)

**User Story:**
As a system administrator, I want to generate read-only API keys for authorized external applications so that they can integrate with our profile system.

**Acceptance Criteria:**
- [ ] API key generation only available to system administrators
- [ ] Administrator specifies application name (required)
- [ ] Administrator can add description/purpose (optional)
- [ ] Administrator can optionally limit access to specific sections
- [ ] Administrator can set optional expiration date
- [ ] System generates unique 32-character API key
- [ ] API key uses recognizable prefix (e.g., `pk_live_`)
- [ ] System displays API key with copy-to-clipboard option
- [ ] System shows security warning about keeping key safe
- [ ] Administrator shares key securely with application owner
- [ ] System stores API key metadata in database

**API Key Format Requirements:**
- 32 characters long
- Alphanumeric (uppercase, lowercase, numbers)
- Prefix: `pk_live_` for production keys
- Example: `pk_live_a7B9c2D4e5F6g8H9j1K2m3N4p5Q6r7S8`
- Must be unique across entire system

**API Key Metadata to Store:**
- Application name
- Description/purpose
- Allowed sections (array of section IDs, empty = all sections)
- Created timestamp
- Created by (administrator identifier)
- Expiration timestamp (nullable)
- Active status (boolean)
- Last used timestamp (nullable)
- Total usage count
- Request log (last 100 requests for audit)

**Security Note:**
All API keys are **read-only** and **system-wide**. External applications can retrieve any profile data (subject to section restrictions) but cannot create, update, or delete any information.

#### 3.4.3 API Endpoints

**All API endpoints are READ-ONLY.** External applications cannot modify, create, or delete data.

**Required Endpoints:**

**1. GET /api/profiles/:profileId**
- Retrieve complete profile with all sections
- Returns: Profile data with all allowed sections and metadata
- Password hash excluded from response

**2. GET /api/profiles/:profileId/sections/:sectionId**
- Retrieve specific section content
- Section must be in allowed sections list
- Returns: Section content only

**3. GET /api/profiles/:profileId/contributions**
- Retrieve all contributions for a profile
- Returns: Array of contribution objects with metadata
- Filtered by allowed sections

**4. GET /api/keys/validate**
- Validate an API key
- Returns: Key metadata and permissions (without sensitive data)

**Authentication:**
- All requests must include API key in Authorization header
- Format: `Authorization: Bearer {api_key}`
- Invalid/expired keys return 401 Unauthorized
- Missing keys return 401 Unauthorized

**Rate Limiting:**
- 100 requests per minute per API key
- 1,000 requests per hour per API key
- 10,000 requests per day per API key
- Exceeded limits return 429 Too Many Requests

**Error Responses:**
- 401 Unauthorized - Invalid/expired/missing API key
- 403 Forbidden - Valid key but insufficient permissions
- 404 Not Found - Profile or section doesn't exist
- 429 Too Many Requests - Rate limit exceeded
- 500 Internal Server Error - Server error

**Success Response Format:**
```json
{
  "success": true,
  "data": { ... },
  "timestamp": "2025-12-29T10:30:00Z"
}
```

**Error Response Format:**
```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Invalid API key"
  },
  "timestamp": "2025-12-29T10:30:00Z"
}
```

#### 3.4.4 Manage API Keys (Administrator Function)

**User Story:**
As a system administrator, I want to view and manage all API keys so that I can control which external applications have access to the system.

**Acceptance Criteria:**
- [ ] API key management only available to system administrators
- [ ] System displays list of all issued API keys
- [ ] Each key shows: partial key, application name, description, allowed sections, created date, created by, expiration, status, usage count
- [ ] API key partially masked for security (e.g., `pk_live_a7B9****`)
- [ ] Administrator can click to reveal full key
- [ ] Administrator can copy full key to clipboard
- [ ] Administrator can revoke active keys
- [ ] Revoked keys cannot be used for new requests
- [ ] Administrator can delete keys (with confirmation)
- [ ] Administrator can view request log for each key (last 100 requests)
- [ ] Request log shows: timestamp, profile ID accessed, endpoint, status code, IP address
- [ ] System updates key status in database

**API Key Status Types:**
- Active
- Revoked
- Expired

**Important:**
- All API keys provide read-only access only
- API keys are system-wide and can access any profile (subject to section restrictions)

### 3.5 Profile Pruning and Cleanup

#### 3.5.1 Inactive Profile Management

**User Story:**
As a system administrator, I want to identify and remove inactive profiles so that the database stays clean and storage costs are minimized.

**Acceptance Criteria:**
- [ ] System tracks profile activity via timestamps
- [ ] Administrator can query profiles by last activity date
- [ ] Administrator can view list of inactive profiles
- [ ] List shows: profile ID, created date, last viewed, last edited, last updated
- [ ] Administrator can filter by inactivity period (e.g., 30, 90, 180, 365 days)
- [ ] Administrator can select profiles for bulk deletion
- [ ] System shows confirmation dialog before deletion
- [ ] Deleted profiles are permanently removed from database
- [ ] System displays count of profiles deleted

**Activity Tracking Requirements:**
- Track when profile is created (`createdAt`)
- Track when profile content is modified (`updatedAt`)
- Track when profile is viewed by any user (`lastViewedAt`)
- Track when owner authenticates to edit (`lastEditedAt`)
- Track when profile is accessed via API (`lastApiAccessAt`)

**Pruning Strategy:**
Profiles are considered inactive when:
- `lastViewedAt` is older than threshold (indicates no one is viewing)
- `lastEditedAt` is older than threshold (indicates owner hasn't logged in)
- `updatedAt` is older than threshold (indicates no content changes)

**Recommended Thresholds:**
- Warning threshold: 180 days of inactivity
- Deletion threshold: 365 days of complete inactivity
- Grace period: 30 days notification before deletion

**Safety Considerations:**
- Never delete profiles with recent API access (active integrations)
- Never delete profiles with active contributor tokens
- Consider archiving instead of deletion for audit trail
- Implement soft delete with recovery period

**Optional Features:**
- Email notification to profile owners before deletion
- Automatic archival to cold storage instead of deletion
- Export inactive profile data before deletion
- Restore deleted profiles within grace period

---

## 4. Data Model and Storage

### 4.1 Firestore Database Schema

The following database schema is **mandatory** and must be implemented exactly as specified. This ensures consistency across profile data, security rules, and API access.

#### 4.1.1 Profile Document

**Collection:** `profiles`
**Document ID:** `{profileId}` (user-chosen, 5-15 alphanumeric characters)

```javascript
{
  // Authentication
  passwordHash: string,          // Hashed password (use bcrypt or similar)

  // Metadata
  createdAt: Timestamp,          // When profile was created
  updatedAt: Timestamp,          // Last time profile content was modified
  lastViewedAt: Timestamp,       // Last time profile was viewed (any user)
  lastEditedAt: Timestamp,       // Last time owner authenticated to edit
  lastApiAccessAt: Timestamp,    // Last time accessed via API (optional)

  // Section content (key-value pairs)
  sections: {
    basic_info: string,
    financial_situation: string,
    mental_conditions: string,
    health_conditions: string,
    // ... additional sections as configured
  },

  // Contributor tokens subcollection reference
  // See 4.1.2 for structure

  // Contributions subcollection reference
  // See 4.1.3 for structure
}
```

**Notes:**
- `passwordHash` must never be returned in API responses
- `sections` object keys must match section IDs from configuration file
- Empty sections should store empty string, not null
- All timestamps use Firestore Timestamp type

**Timestamp Update Rules:**
- `createdAt`: Set once on profile creation, never modified
- `updatedAt`: Updated whenever profile sections are modified (save operation)
- `lastViewedAt`: Updated whenever profile is viewed (any user accessing view screen)
- `lastEditedAt`: Updated whenever owner successfully authenticates to edit mode
- `lastApiAccessAt`: Updated whenever profile is accessed via API endpoint

**Activity Tracking for Pruning:**
To identify inactive profiles for cleanup, query profiles where:
- `lastViewedAt` is older than X days/months (indicates no one is viewing it)
- `lastEditedAt` is older than X days/months (indicates owner hasn't maintained it)
- `updatedAt` is older than X days/months (indicates no content changes)

Recommended pruning strategy: Archive/delete profiles where ALL activity timestamps are older than threshold (e.g., 365 days of complete inactivity).

#### 4.1.2 Contributor Tokens Subcollection

**Subcollection Path:** `profiles/{profileId}/contributorTokens`
**Document ID:** Auto-generated or use token as ID

```javascript
{
  token: string,                 // Unique 8-12 character token
  contributorName: string,
  contributorRole: string,       // Teacher, ST, OT, Doctor, Tutor, Other
  allowedSections: array<string>, // Array of section IDs
  createdAt: Timestamp,
  expiresAt: Timestamp | null,   // null = never expires
  isActive: boolean,             // false when revoked
  usageCount: number             // Incremented on each submission
}
```

**Indexes Required:**
- `token` (for quick lookup)
- `isActive` (for filtering)

#### 4.1.3 Contributions Subcollection

**Subcollection Path:** `profiles/{profileId}/contributions`
**Document ID:** Auto-generated

```javascript
{
  contributorName: string,
  contributorRole: string,
  sectionId: string,             // Which section this belongs to
  content: string,               // The contributed report text
  submittedAt: Timestamp,
  tokenUsed: string,             // Reference to token used
  isArchived: boolean,           // For archive functionality
  metadata: {
    ipAddress: string,           // Optional: for audit
    userAgent: string            // Optional: for audit
  }
}
```

**Indexes Required:**
- `sectionId` (for filtering by section)
- `submittedAt` (for sorting)
- `isArchived` (for filtering)

#### 4.1.4 System API Keys Collection

**Collection:** `apiKeys` (top-level collection, not profile-specific)
**Document ID:** Auto-generated or use API key as ID

```javascript
{
  apiKey: string,                     // Unique 32-character key
  applicationName: string,
  description: string,
  allowedSections: array<string>,     // Empty array = all sections
  createdAt: Timestamp,
  createdBy: string,                  // Administrator identifier
  expiresAt: Timestamp | null,        // null = never expires
  isActive: boolean,                  // false when revoked
  lastUsedAt: Timestamp | null,
  usageCount: number,
  requestLog: array<{                 // Last 100 requests
    timestamp: Timestamp,
    profileId: string,                // Which profile was accessed
    endpoint: string,
    statusCode: number,
    ipAddress: string
  }>
}
```

**Notes:**
- All API keys provide **read-only** access across the entire system
- API keys are **not scoped to individual profiles** - they can access any profile
- Section restrictions apply globally (e.g., if limited to "basic_info", can only read that section from any profile)
- Administrators manage all keys through a separate admin interface

**Indexes Required:**
- `apiKey` (for quick lookup)
- `isActive` (for filtering)
- `createdBy` (for audit)

### 4.2 Security Rules

**Critical Security Requirements:**

1. **Profile Creation:**
   - Anyone can create a new profile
   - Profile ID must be unique
   - Password must be hashed before storage

2. **Profile Reading:**
   - Anyone can read profile data (public viewing)
   - Password hash must never be exposed in reads
   - Update `lastViewedAt` timestamp on every profile view

3. **Profile Writing:**
   - Only authenticated users (valid ID + password) can update
   - Authentication must verify password hash match
   - Users can only update their own profiles
   - Update `updatedAt` timestamp on every save operation
   - Update `lastEditedAt` timestamp when owner authenticates to edit mode

4. **Profile Deletion:**
   - Only authenticated users can delete profiles
   - Must delete all subcollections (tokens, keys, contributions)

5. **Contributor Token Usage:**
   - Token must be active and not expired
   - Can only write to allowed sections
   - Cannot read existing profile data
   - Must increment usage count

6. **API Key Usage:**
   - API key must be active and not expired
   - **Read-only access**: can only read allowed sections
   - Cannot write, update, create, or delete any data
   - Cannot modify password or metadata
   - Must log all requests
   - Update `lastApiAccessAt` timestamp on every API access

### 4.3 Data Validation Rules

**Profile ID:**
- Length: 5-15 characters
- Characters: Alphanumeric only (a-z, A-Z, 0-9)
- Case-sensitive
- Must be unique

**Password:**
- Length: 5-15 characters
- Characters: Any printable characters
- Must be hashed (bcrypt, argon2, or similar)
- Hash rounds: minimum 10 (recommended 12)

**Section Content:**
- Type: String
- Max length: 10,000 characters per section (recommended limit)
- Allow line breaks and special characters
- UTF-8 encoding

**Contributor Token:**
- Length: 8-12 characters
- Format: Letters and numbers with hyphens
- Example: TEACH-X7K9-2M4P
- Must be unique across all profiles

**API Key:**
- Length: 32 characters after prefix
- Prefix: pk_live_
- Characters: Alphanumeric (a-z, A-Z, 0-9)
- Must be unique across all profiles

---

## 5. Backend Services

### 5.1 Firebase Service Layer

**Required Operations:**

The application must provide a service layer that handles all Firebase operations. This service should abstract Firebase SDK calls from the UI layer.

**Profile Operations:**
- `createProfile(profileId, password, initialSections)` - Create new profile
- `getProfile(profileId)` - Retrieve profile data (without password hash)
- `updateProfile(profileId, password, sections)` - Update profile after auth
- `deleteProfile(profileId, password)` - Delete profile after auth
- `duplicateProfile(sourceProfileId, sourcePassword, newProfileId, newPassword)` - Duplicate profile after auth
- `authenticateProfile(profileId, password)` - Verify credentials

**Contributor Token Operations:**
- `generateContributorToken(profileId, tokenData)` - Create new token
- `validateContributorToken(token)` - Check token validity
- `getContributorTokens(profileId)` - List all tokens
- `revokeContributorToken(profileId, tokenId)` - Deactivate token
- `deleteContributorToken(profileId, tokenId)` - Remove token

**Contribution Operations:**
- `submitContribution(token, sectionId, content)` - Add contribution
- `getContributions(profileId, sectionId)` - Get contributions for section (profile owner view)
- `getContributionsByToken(token)` - Get all contributions made with specific token (contributor view)
- `archiveContribution(profileId, contributionId)` - Archive contribution
- `deleteContribution(profileId, contributionId)` - Delete contribution

**API Key Operations:**
- `generateApiKey(profileId, keyData)` - Create new API key
- `validateApiKey(apiKey)` - Check key validity and return permissions
- `getApiKeys(profileId)` - List all API keys
- `revokeApiKey(profileId, keyId)` - Deactivate API key
- `deleteApiKey(profileId, keyId)` - Remove API key
- `logApiRequest(apiKey, endpoint, statusCode, ipAddress)` - Log request

**Profile Pruning Operations (Administrator Only):**
- `getInactiveProfiles(thresholdDays)` - Query profiles inactive beyond threshold
- `getProfileActivitySummary(profileId)` - Get all activity timestamps for a profile
- `bulkDeleteProfiles(profileIds, adminPassword)` - Delete multiple profiles at once
- `archiveProfile(profileId)` - Move profile to archive storage
- `getProfileStats()` - Get database statistics (total profiles, inactive count, etc.)

**Timestamp Update Operations:**
These should be automatically handled within other operations:
- `updateLastViewedAt(profileId)` - Called when profile is viewed
- `updateLastEditedAt(profileId)` - Called when owner authenticates to edit
- `updateLastApiAccessAt(profileId)` - Called on API access
- `updatedAt` - Automatically updated by Firestore on document updates

**Implementation Notes:**
- Password hashing must use industry-standard algorithm (bcrypt/argon2)
- All timestamps must use Firestore server timestamp
- Error handling must provide clear, user-friendly messages
- Logging should include operation type, timestamp, and success/failure

### 5.2 API Backend Implementation

**Deployment Platform:**
- Must be hosted on Google Cloud Platform
- Options: Cloud Functions, Cloud Run, App Engine
- Must integrate with Firebase Firestore
- Must support HTTPS only

**Required Features:**
- RESTful API endpoints (defined in 3.4.3)
- API key authentication middleware
- Rate limiting middleware
- Request logging
- CORS configuration (allow specified origins)
- Error handling with standardized responses

**Performance Requirements:**
- API response time: < 500ms for simple queries
- API response time: < 2000ms for complex queries
- Support minimum 100 concurrent requests
- Rate limiting per API key (100/min, 1000/hour, 10000/day)

**Security Requirements:**
- Validate all API keys before processing requests
- Check allowed sections for each request
- **Enforce read-only access** (reject any write/update/delete attempts)
- Log all API requests for audit trail
- Never expose password hashes
- Sanitize all input data
- Prevent SQL/NoSQL injection
- Implement request size limits

**Monitoring and Logging:**
- Log all API requests (timestamp, endpoint, key, IP, status)
- Track API key usage counts
- Monitor rate limit violations
- Alert on suspicious activity patterns

---

## 6. Frontend Implementation

### 6.1 Screens and Navigation

**Required Screens:**

1. **Home Screen** (`/`)
   - Three main action buttons: Create Profile, View Profile, Edit Profile
   - Application title and brief description
   - Language selector in app bar
   - Simple, clean design

2. **Create Profile Screen** (`/create`)
   - Privacy warning banner/notice (prominent, above input fields)
   - Profile ID input field
   - Profile ID strength indicator (below Profile ID field)
   - Password input field (obscured)
   - Confirm password input field (obscured)
   - Create button
   - Cancel button
   - Validation messages
   - Navigate to Edit screen on success
   - **Privacy Warning Design**:
     - Display warning in highlighted box or card
     - Use warning color (amber/yellow) or info color (blue)
     - Include icon (⚠️ warning icon or 🔒 lock icon)
     - Text should be clearly readable (not too small)
     - Position: Above profile ID field or at top of form
   - **Profile ID Strength Indicator Design**:
     - Display below Profile ID input field
     - Use color-coded visual indicator:
       - Green for Low Risk
       - Yellow/Amber for Medium Risk
       - Red for High Risk
     - Show risk level label (e.g., "Privacy Risk: Low")
     - Show explanatory message based on risk level
     - Update in real-time as user types
     - Visual style: Can be progress bar, badge, or colored text with icon
     - Should be clearly visible but not intrusive
     - Does not prevent profile creation (informational only)

3. **View Profile Screen** (`/view/:profileId`)
   - Section navigation (dropdown, prev/next buttons)
   - Section content display (read-only)
   - Contributions display for each section
   - Exit/Back button
   - Share button (optional)

4. **Edit Profile Screen** (`/edit/:profileId`)
   - Section navigation (dropdown, prev/next buttons)
   - Section content editor (editable text area)
   - Save button
   - Duplicate Profile button
   - Delete Profile button
   - Manage Contributors button
   - Contributions display (with archive/delete options)
   - Exit/Logout button

5. **Contributor Submission Screen** (`/contribute/:token`)
   - **Tab 1: Submit New Report**
     - Profile owner identifier display
     - Contributor role display (read-only)
     - Section selector (allowed sections only)
     - Report text area
     - Submit button
     - Success/error messages
   - **Tab 2: My Previous Reports**
     - List of contributor's own previous contributions
     - Each entry shows: section, date, content preview
     - Click to view full contribution in read-only mode
     - Contribution count badge
   - **Privacy**: No access to profile owner's content or other contributors' reports

6. **Manage Contributors Screen** (`/edit/:profileId/contributors`)
   - List of all tokens
   - Generate New Token button
   - Token details display (name, role, sections, status, usage)
   - Revoke/Delete/Copy actions per token
   - Back button

7. **Admin Dashboard Screen** (`/admin`) - **Administrator Only**
   - **System Statistics Section**:
     - Total profiles count
     - Total API requests count
     - Inactive profiles count (by threshold)
     - Database storage usage
   - **API Key Management Section**:
     - List of all issued API keys
     - Generate New API Key button
     - Key details display (app name, description, sections, created by, status, usage)
     - Revoke/Delete/Copy actions per key
     - Request log display (with profile IDs accessed)
   - **Profile Pruning Section**:
     - Inactivity threshold selector (30, 90, 180, 365 days)
     - List of inactive profiles with activity details
     - Profile details (ID, created date, last viewed, last edited, last updated, last API access)
     - Select/deselect profiles for deletion
     - Bulk delete button
     - Export inactive profiles list
     - Confirmation dialog before deletion

**Navigation Requirements:**
- Use route-based navigation (URLs should be bookmarkable)
- Browser back button should work correctly
- Deep linking should work for View Profile and Contribute screens
- Authentication required for Edit and Manage Contributors screens
- **Administrator authentication required for Admin Dashboard**
- Unauthenticated users redirected to appropriate auth flow

### 6.2 UI/UX Requirements

**General Design Principles:**
- Clean, minimalist interface
- Easy to use for people with limited computer knowledge
- Large, clear buttons and text
- Adequate spacing between interactive elements
- Consistent design across all screens
- Mobile-responsive (works on phone, tablet, desktop)

**Accessibility:**
- Sufficient color contrast (WCAG AA minimum)
- Keyboard navigation support
- Screen reader compatible
- Clear focus indicators
- Descriptive labels for all inputs
- Error messages associated with fields

**Forms and Inputs:**
- Clear labels for all input fields
- Placeholder text for guidance
- Inline validation where appropriate
- Error messages displayed near relevant fields
- Password fields with show/hide toggle option
- Multi-line text areas auto-resize or have adequate height

**Feedback and Messaging:**
- Loading indicators for async operations
- Success messages for completed actions
- Clear error messages with actionable guidance
- Confirmation dialogs for destructive actions
- Toast/snackbar notifications for quick feedback

**Language Switching:**
- Language selector always visible (in app bar)
- Immediate UI update when language changes
- Persist language preference
- Support: English, Traditional Chinese, Simplified Chinese

### 6.3 State Management

**Required State:**

1. **Authentication State:**
   - Current profile ID (when authenticated)
   - Is authenticated (boolean)
   - Authentication session timeout (optional)

2. **Profile State:**
   - Current profile data (all sections)
   - Profile metadata (createdAt, updatedAt)
   - Unsaved changes indicator
   - Save operation status (idle, saving, success, error)

3. **Contribution State:**
   - Contributions for current profile
   - Filtered by section
   - Show archived toggle state

4. **Contributor Token State:**
   - List of all tokens
   - Selected token details
   - Token generation form data

5. **API Key State:**
   - List of all API keys
   - Selected key details
   - Key generation form data
   - Request logs

6. **UI State:**
   - Current section index
   - Current language
   - Loading states
   - Error messages
   - Success messages

**State Management Requirements:**
- Reactive updates (UI reflects state changes immediately)
- Predictable state changes
- Clear separation between UI state and business state
- State persistence where appropriate (language preference)
- Proper cleanup on logout/exit

---

## 7. Internationalization (i18n)

### 7.1 Supported Languages

**Required Languages:**
1. English (en)
2. Traditional Chinese (zh_TW)
3. Simplified Chinese (zh_CN)

**Default Language:** English

### 7.2 Localization Files

**Format:** ARB (Application Resource Bundle)

**File Location:** `lib/l10n/` directory

**File Names:**
- `app_en.arb` - English translations
- `app_zh_TW.arb` - Traditional Chinese translations
- `app_zh_CN.arb` - Simplified Chinese translations

**Required Localization Keys:**

All UI text must be localized, including but not limited to:
- Screen titles
- Button labels
- Input field labels and placeholders
- Error messages
- Success messages
- Validation messages
- Section titles
- Contributor roles
- Confirmation dialogs
- Help text

**Dynamic Text:**
- Support for parameterized strings (e.g., "Welcome, {name}")
- Plural forms where applicable
- Date/time formatting per locale

### 7.3 Language Switching

**User Story:**
As a user, I want to switch between English and Chinese so that I can use the app in my preferred language.

**Acceptance Criteria:**
- [ ] Language selector visible in app bar on all screens
- [ ] Shows current language
- [ ] Dropdown or menu to select different language
- [ ] UI updates immediately when language changes
- [ ] All text elements update (screens, buttons, messages)
- [ ] Section titles update to selected language
- [ ] Language preference persists across sessions
- [ ] User-generated content (sections, contributions) not translated

---

## 8. Authentication and Security

### 8.1 Profile Authentication

**Mechanism:**
- ID + password authentication (not Firebase Authentication)
- Custom authentication logic
- Password verified against hash in Firestore
- No user accounts (each profile is independent)

**Session Management:**
- Maintain authentication state during app session
- Optional: Session timeout after inactivity
- Clear authentication on logout
- Re-authenticate required for sensitive operations

**Password Security:**
- Passwords must be hashed before storage
- Use bcrypt (recommended) or argon2
- Minimum hash rounds: 10 (recommended: 12)
- Never store or log plain-text passwords
- Never transmit password in URLs or headers (only in request body)

### 8.2 API Authentication

**Mechanism:**
- Bearer token authentication
- API key passed in Authorization header
- Format: `Authorization: Bearer {apiKey}`

**Validation:**
- Check key exists in database
- Check key is active (not revoked)
- Check key not expired
- Check requested section in allowed sections
- **Verify request is read-only** (GET requests only)
- Log request details

**Rate Limiting:**
- Track requests per API key
- Enforce limits: 100/min, 1000/hour, 10000/day
- Return 429 status when exceeded
- Include rate limit headers in responses

### 8.3 Contributor Token Authentication

**Mechanism:**
- Token-based access
- Token passed as URL parameter
- Validate token before showing submission form

**Validation:**
- Check token exists in database
- Check token is active (not revoked)
- Check token not expired
- Check selected section in allowed sections
- Increment usage count on submission

**Privacy Protection:**
- Contributors cannot read existing profile data
- Contributors cannot read other contributions
- Token only grants write access to specific sections
- No profile metadata exposed to contributors

### 8.4 Security Best Practices

**Data Protection:**
- Never expose password hashes in API responses or UI
- Sanitize all user inputs
- Prevent injection attacks (NoSQL injection)
- Validate all data before database writes
- Implement request size limits

**Access Control:**
- Verify authentication before all write operations
- Check ownership before allowing updates
- Validate token/key permissions before operations
- Implement proper Firestore security rules

**Audit and Monitoring:**
- Log all authentication attempts
- Log all API key usage
- Log all contributor token usage
- Monitor for suspicious patterns
- Track failed authentication attempts

---

## 9. Phase 1: Caregiver-Friendly Features

### 9.1 Overview

**Goal:**
Make the profile editing experience easier for caregivers who may have limited computer knowledge or time.

**Phase 1 Features:**
1. AI-Guided Mode
2. Voice-to-Text Input
3. Auto-Save
4. Progressive Disclosure
5. Offline Mode

### 9.2 AI-Guided Mode

**User Story:**
As a caregiver filling out a profile section, I want the AI to ask me a series of questions so that I can easily recall and enter all relevant information without having to think about what to include.

**Overview:**
This feature uses **pre-configured question sets** for each section. The AI's role is to:
1. Present the pre-configured questions in a conversational, empathetic manner
2. Validate and acknowledge user responses
3. Compile the answers into coherent, well-formatted text
4. Insert the compiled content into the section

**Acceptance Criteria:**
- [ ] "Guided Mode" toggle/button available in each section's edit view
- [ ] Button clearly indicates it's for AI-assisted input (e.g., lightbulb or assistant icon)
- [ ] Pre-configured question sets defined in configuration files (one set per section)
- [ ] Questions stored in localization files (ARB) for multi-language support
- [ ] When activated, AI presents the pre-configured questions for the current section
- [ ] AI presents questions in a conversational, friendly tone
- [ ] User can answer questions via text input or voice-to-text
- [ ] AI validates responses and provides acknowledgment (e.g., "Thank you, that's helpful!")
- [ ] AI compiles answers into coherent paragraph(s) or structured notes
- [ ] Compiled content is inserted into the section text field (appending to existing content)
- [ ] User can edit the AI-generated content before saving
- [ ] User can skip questions or exit guided mode at any time
- [ ] Progress indicator shows which question user is on (e.g., "3 of 8")
- [ ] User can go back to previous questions to modify answers
- [ ] Guided mode supports all 3 languages (English, Traditional Chinese, Simplified Chinese)
- [ ] Clear option to restart guided mode or continue where left off

**Question Configuration Structure:**

Questions should be defined in a configuration file with this structure:
```json
{
  "sections": {
    "personal_traits": {
      "questions": [
        {
          "id": "intelligence_learning",
          "textKey": "guided.personal_traits.question_1",
          "order": 1,
          "required": false
        },
        {
          "id": "strengths",
          "textKey": "guided.personal_traits.question_2",
          "order": 2,
          "required": false
        }
        // ... more questions
      ]
    }
    // ... more sections
  }
}
```

The actual question text is stored in ARB localization files for multi-language support.

**Section-Specific Question Examples:**

The following questions should be pre-configured for each section:

**Personal Traits:**
1. "How would you describe their general intelligence level and learning style?"
2. "What are their top 3 strengths?"
3. "What are their main weaknesses or areas for improvement?"
4. "What are their core values or what matters most to them?"
5. "Do they have a known psychological profile (e.g., MBTI, personality type)?"
6. "What specific phrases do they like to hear or find encouraging?"
7. "What should absolutely NOT be said to them? Any sensitive topics?"

**Health Condition:**
1. "What medical conditions or diagnoses do they have?"
2. "Do they have any allergies (food, medication, environmental)?"
3. "Are there any dietary restrictions or special dietary needs?"
4. "What are their physical capabilities? Any mobility limitations?"
5. "What medications are they currently taking?"
6. "Are there any recent health changes or concerns?"

**Family & Social:**
1. "Who are the immediate family members and their relationships?"
2. "Are there any extended family members who are important in their life?"
3. "What is their current living situation? Who do they live with?"
4. "What are their key social relationships outside of family?"
5. "Are there any family commitments or responsibilities to note?"
6. "What is the family dynamics like? Any important context?"

**Daily Life:**
1. "What does their typical daily routine look like?"
2. "What time do they usually wake up and go to bed?"
3. "What are their regular activities throughout the day?"
4. "How much free time do they have each day/week?"
5. "Where do they live (city, neighborhood)? Describe their living environment."
6. "Are there any regular commitments (appointments, activities, etc.)?"

**School & Education:**
1. "What grade level or educational stage are they in?"
2. "How would you describe their academic performance overall?"
3. "What is their learning style? How do they learn best?"
4. "What are their favorite and least favorite subjects?"
5. "What are their educational goals or aspirations?"
6. "Are there any school-related commitments (extracurriculars, tutoring, etc.)?"
7. "Are there any learning challenges or special educational needs?"

**Important Events:**
1. "Have there been any recent significant life changes?"
2. "Are there any upcoming important events or milestones?"
3. "Have there been any recent losses (people, pets, situations)?"
4. "Any major transitions happening or planned (school change, moving, etc.)?"
5. "Is there anything else happening that significantly impacts their life right now?"

**Question Configuration:**
- Questions are pre-defined in configuration files (JSON or similar)
- Each section has its own question set (see examples below)
- Questions are stored in localization files (ARB) for multi-language support
- Question order is configurable
- Questions can be marked as optional or required

**AI Behavior:**
The AI's role is **limited and focused**:
- Present pre-configured questions in a conversational, empathetic tone
- Acknowledge and validate user responses (e.g., "Thank you for sharing that!")
- Ask simple clarification if response is unclear (e.g., "Could you tell me a bit more about that?")
- Compile all answers into coherent, well-formatted text
- Organize information logically within the section

The AI does NOT:
- Generate its own questions (all questions are pre-configured)
- Make complex decisions about which questions to ask (follows the configured sequence)
- Store or learn from user data beyond the current session

**Output Format Options:**
User can choose how AI formats the compiled content:
1. **Paragraph format** - Narrative style, flowing text
2. **Bullet points** - Organized list format
3. **Structured sections** - Information grouped by topic with headers
4. Default format can be configured per section type

**Error Handling:**
- "AI assistant is temporarily unavailable. Please try again later."
- "Unable to process your response. Please rephrase or try again."
- If network issue: "Guided mode requires an internet connection."
- Graceful fallback to manual entry if AI service fails

**Design Notes:**
- Keep question flow natural and conversational
- Don't overwhelm user with too many questions (5-8 per section ideal)
- Allow flexibility - user doesn't have to answer everything
- Make it clear that AI-generated content can be edited
- Save answers locally so they're not lost if session interrupted
- Consider adding "Quick Start" templates as alternative to full guided mode

**Privacy Considerations:**
- Clearly indicate that responses may be processed by AI service
- Provide opt-out for users who don't want AI assistance
- Don't send any existing profile data to AI (only current section being worked on)
- Allow users to review and edit before final save

### 9.3 Voice-to-Text Input

**User Story:**
As a caregiver with limited typing skills, I want to dictate profile content by voice so that I can complete sections faster while multitasking.

**Acceptance Criteria:**
- [ ] Voice input button visible in all editable text fields
- [ ] Button clearly indicates it's for voice input (microphone icon)
- [ ] Tapping button requests microphone permission (first time only)
- [ ] Voice recognition starts after permission granted
- [ ] Visual indicator shows when actively listening
- [ ] User can tap again to stop listening
- [ ] Recognized text appends to existing field content
- [ ] Supports English, Traditional Chinese, Simplified Chinese
- [ ] Works on both web and iOS platforms
- [ ] Graceful error handling if feature unavailable
- [ ] Clear error message if microphone access denied

**Platform Support:**
- Web: Use Web Speech API or similar
- iOS: Use platform speech recognition

**Error Handling:**
- "Microphone access denied. Please enable in settings."
- "Voice input not available on this device."
- "Could not recognize speech. Please try again."
- "Speech recognition service unavailable."

**Design Notes:**
- Keep voice button prominent but not intrusive
- Provide visual feedback during recognition
- Allow users to edit recognized text
- Don't automatically save after voice input

### 9.4 Auto-Save

**User Story:**
As a caregiver who might be frequently interrupted, I want my changes to save automatically so that I don't lose my work if I navigate away or close the app.

**Acceptance Criteria:**
- [ ] Changes automatically saved after user stops typing
- [ ] Debounce period: 2 seconds after last keystroke
- [ ] Visual indicator shows save status: Idle, Saving, Saved, Error
- [ ] User can still manually save at any time
- [ ] Auto-save works for all section content
- [ ] Auto-save respects offline mode (saves when back online)
- [ ] Save failures show error message
- [ ] Error message allows manual retry

**Save Status Indicators:**
- Idle: No indicator or "Not saved"
- Saving: Spinner icon + "Saving..."
- Saved: Checkmark icon + "Saved" (disappears after 2 seconds)
- Error: Error icon + "Save failed. Retry?"

**Error Handling:**
- "Failed to save changes. Please check your connection."
- Retry button available on error
- Preserve unsaved changes if save fails
- Warn user if navigating away with unsaved changes (as backup)

**Design Notes:**
- Auto-save should feel invisible most of the time
- Status indicator should be subtle but noticeable
- Don't interrupt user's typing flow
- Always allow manual save option

### 9.5 Progressive Disclosure

**User Story:**
As a caregiver overwhelmed by many sections, I want related sections grouped and collapsible so that I can focus on relevant information.

**Acceptance Criteria:**
- [ ] Sections organized into logical groups
- [ ] Each group can be expanded or collapsed
- [ ] Essential groups expanded by default
- [ ] Other groups collapsed by default
- [ ] User can expand/collapse any group
- [ ] Expansion state persists during session
- [ ] Group headers show: name, icon, section count
- [ ] Clear visual distinction between groups
- [ ] All sections still accessible (just organized)

**Suggested Section Groups:**

1. **Essential Information** (default expanded)
   - Personal Traits (order: 1)
   - Health Condition (order: 2)
   - Family & Social (order: 3)
   - Daily Life (order: 4)
   - School & Education (order: 5)
   - Important Events (order: 6)

2. **Professional Development**
   - Work Experience
   - Education
   - Skills
   - Certifications

3. **Projects and Achievements**
   - Projects
   - Awards
   - Publications
   - Patents

4. **Personal and Social**
   - Personal Interests
   - Volunteer Work
   - Languages
   - Social Media
   - Social Relationships

5. **Personal Situation**
   - Family Situation
   - Financial Situation
   - Strengths
   - Weaknesses
   - Likes
   - Dislikes

6. **Goals and Aspirations**
   - Short-term Goals
   - Long-term Goals
   - Favorite Pastimes

7. **References**
   - References

**Group Configuration:**
- Define groups in JSON configuration file
- Each group: id, titleKey, icon, defaultExpanded, sections[]
- Sections can only belong to one group
- Allow AI tool to refine groupings

**Design Notes:**
- Use clear expand/collapse icons
- Smooth expand/collapse animation
- Keep navigation intuitive
- Don't hide critical information by default

### 9.6 Offline Mode

**User Story:**
As a caregiver who might lose internet connection, I want the app to work offline so that I can continue editing without interruption.

**Acceptance Criteria:**
- [ ] App detects online/offline status
- [ ] Visual indicator shows current connection status
- [ ] Profile data cached locally when accessed
- [ ] User can view cached profiles offline
- [ ] User can edit cached profiles offline
- [ ] Changes saved locally when offline
- [ ] Changes sync to server when back online
- [ ] Sync happens automatically on reconnection
- [ ] User notified of sync status
- [ ] Conflicts handled gracefully (last write wins or user choice)

**Connection Status Indicator:**
- Online: No indicator or green dot
- Offline: Banner at top: "You're offline. Changes will sync when online."
- Syncing: Banner: "Syncing changes..."
- Sync complete: Banner: "All changes synced" (disappears after 2 seconds)

**Offline Capabilities:**
- View previously loaded profiles
- Edit section content
- Navigate between sections
- Create new contributions (queued for sync)

**Offline Limitations:**
- Cannot create new profiles
- Cannot load profiles not previously cached
- Cannot generate tokens or API keys
- Cannot delete profiles
- External API not available

**Sync Behavior:**
- Auto-sync when connection restored
- Retry failed syncs
- Queue multiple changes
- Show sync progress for large changes
- Handle sync errors gracefully

**Error Handling:**
- "Unable to load profile. Please check your connection."
- "Changes saved locally. Will sync when online."
- "Sync failed. Will retry automatically."

**Design Notes:**
- Use Firestore offline persistence (built-in feature)
- Clear communication of offline status
- Don't block user from working offline
- Ensure data integrity during sync

---

## 10. Deployment

### 10.1 Web Deployment (Firebase Hosting)

**Requirements:**
- Deploy web application to Firebase Hosting
- Configure custom domain (optional)
- Enable HTTPS (automatic with Firebase Hosting)
- Configure caching for static assets
- Set up CDN for global distribution

**Build Requirements:**
- Flutter web build optimized for production
- Minified JavaScript and assets
- Tree-shaking enabled
- Code splitting where beneficial

**Hosting Configuration:**
- Single Page Application (SPA) routing
- Redirect all routes to index.html
- Cache static assets (30 days)
- No cache for index.html

### 10.2 iOS Deployment

**Requirements:**
- Build for iOS 12.0 or higher
- App Store distribution (or TestFlight for testing)
- Proper app icons and launch screens
- Privacy policy and permissions explanations
- Microphone usage description (for voice-to-text)

**Build Requirements:**
- Release build with optimizations
- Proper signing certificates
- Version numbering
- Compliance with App Store guidelines

### 10.3 API Backend Deployment

**Requirements:**
- Deploy to Google Cloud Platform
- Use Cloud Run, Cloud Functions, or App Engine
- Configure environment variables
- Set up proper IAM roles
- Enable logging and monitoring

**Environment Variables:**
- Firebase project ID
- Firestore credentials
- CORS allowed origins
- Rate limit configurations

### 10.4 Monitoring and Analytics

**Optional but Recommended:**
- Firebase Analytics for usage tracking
- Error reporting (Crashlytics or Sentry)
- Performance monitoring
- API usage monitoring
- Server uptime monitoring

---

## 11. Testing Requirements

### 11.1 Unit Testing

**Required Test Coverage:**
- Service layer functions (Firebase operations)
- Authentication logic
- Token generation and validation
- API key generation and validation
- Password hashing and verification
- Input validation functions
- Data transformation logic

**Minimum Coverage:** 70% of service layer code

### 11.2 Integration Testing

**Required Tests:**
- Profile CRUD operations end-to-end
- Contributor token workflow
- API key workflow
- Authentication flow
- Multi-language switching
- Offline sync functionality

### 11.3 UI Testing

**Required Tests:**
- Navigation between screens
- Form validation
- Error message display
- Success message display
- Language switching
- Section navigation

### 11.4 API Testing

**Required Tests:**
- All API endpoints (happy path)
- Authentication failures
- Authorization failures
- Rate limiting
- Invalid inputs
- Error responses

### 11.5 Manual Testing Checklist

**Before Deployment:**
- [ ] Create profile flow works
- [ ] View profile flow works
- [ ] Edit profile flow works
- [ ] Delete profile flow works
- [ ] All sections load and save correctly
- [ ] Contributor token generation works
- [ ] Contributor submission works
- [ ] API key generation works
- [ ] All API endpoints work
- [ ] Language switching works for all 3 languages
- [ ] Voice-to-text works (where supported)
- [ ] Auto-save works
- [ ] Progressive disclosure works
- [ ] Offline mode works
- [ ] Web app works on Chrome, Safari, Firefox
- [ ] iOS app works on real device
- [ ] Responsive design works on mobile, tablet, desktop

---

## 12. Performance Requirements

### 12.1 Application Performance

- App initial load: < 3 seconds on 4G connection
- Screen navigation: < 500ms
- Profile load: < 2 seconds
- Profile save: < 1 second
- Section navigation: instant (< 100ms)
- Language switch: instant (< 100ms)

### 12.2 API Performance

- Simple GET requests: < 500ms
- Complex GET requests: < 2000ms
- PUT requests: < 1000ms
- Support 100 concurrent requests minimum
- Rate limiting enforced per API key

### 12.3 Offline Performance

- Cached profile loads: instant (< 100ms)
- Offline edits save locally: instant
- Sync on reconnect: < 5 seconds for typical changes

---

## 13. Future Enhancements (Out of Scope for Phase 1)

The following features are suggested for future development but not required for initial implementation:

1. **Photo and Document Attachments**
   - Upload profile photos
   - Attach documents to sections (PDFs, images)
   - Document storage in Firebase Storage

2. **Structured Data Entry**
   - Alternative to free-text for specific sections
   - Form-based input for dates, addresses, etc.
   - Data validation for structured fields

3. **AI Integration Helpers**
   - Section templates
   - Smart suggestions for content
   - Automated summaries

4. **Version History**
   - Track changes over time
   - Compare versions
   - Restore previous versions

5. **Export Functionality**
   - Export profile to PDF
   - Export to JSON
   - Print-friendly format

6. **Advanced Search**
   - Search within profile sections
   - Search across contributions
   - Filter and sort capabilities

7. **Notifications**
   - Email notifications for new contributions
   - Reminder to update profile
   - API key expiration alerts

8. **Multi-Profile Management**
   - Caregiver dashboard to manage multiple profiles
   - Quick switch between profiles
   - Bulk operations

---

## 14. Glossary

- **Profile Owner**: User who creates and maintains a profile
- **Caregiver**: Person managing a profile on behalf of someone else (child, patient, etc.)
- **Contributor**: Third party (teacher, therapist, etc.) who submits reports via token
- **Profile ID**: Unique identifier for a profile (5-15 alphanumeric characters)
- **Contributor Token**: Access code allowing third party to submit reports
- **API Key**: Authentication credential for external applications
- **Section**: Distinct category of profile information (e.g., Basic Info, Health)
- **ARB**: Application Resource Bundle (localization file format)
- **Firestore**: Firebase's NoSQL cloud database
- **Progressive Disclosure**: UI pattern that shows/hides complexity
- **Debounce**: Delaying action until user stops activity (e.g., typing)

---

## 15. Acceptance Criteria Summary

This project will be considered successfully implemented when:

- [ ] All functional requirements in Section 3 are met
- [ ] Database schema in Section 4.1 is implemented correctly
- [ ] All required screens in Section 6.1 are functional
- [ ] All 3 languages (English, Traditional Chinese, Simplified Chinese) work
- [ ] All API endpoints in Section 3.4.3 work correctly
- [ ] All Phase 1 caregiver features (voice, auto-save, progressive disclosure, offline) work
- [ ] Web app deployed to Firebase Hosting
- [ ] iOS app builds and runs without errors
- [ ] API backend deployed and accessible
- [ ] All security requirements in Section 8 are implemented
- [ ] Testing requirements in Section 11 are met
- [ ] Performance requirements in Section 12 are met

---

## 16. Development Guidelines for AI Tool

**Flexibility:**
- Choose appropriate packages for state management, navigation, UI components
- Determine optimal file structure and code organization
- Select implementation patterns that best fit the requirements
- Make architectural decisions for scalability and maintainability

**Exactness Required:**
- Database schema must match Section 4.1 exactly
- API endpoint contracts must match Section 3.4.3 exactly
- Security rules must implement requirements in Section 4.2
- Validation rules must match specifications
- Supported languages must be exactly: English, Traditional Chinese, Simplified Chinese

**Best Practices:**
- Follow Flutter and Dart best practices
- Write clean, maintainable code
- Use meaningful variable and function names
- Comment complex logic
- Handle errors gracefully
- Provide clear user feedback
- Optimize for performance
- Consider mobile-first responsive design

**AI Tool Recommendations:**
- Add helpful sections beyond the 4 defaults where appropriate
- Improve error messages for better UX
- Add helpful tooltips and hints
- Optimize UI layouts for better usability
- Suggest reasonable defaults for configurations
- Implement additional security measures if beneficial
- Add useful logging for debugging

---

**END OF USER REQUIREMENTS SPECIFICATION**
