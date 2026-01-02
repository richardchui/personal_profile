# Personal Profile App - Technical Specification

## Overview

The Personal Profile Application is a Flutter-based personal information management system that allows users to create, store, view, and edit detailed personal profiles. The application provides password-protected access for editing while allowing open access for viewing profiles. It supports multiple platforms (Web via Firebase Hosting and iOS) and multiple languages (English, Traditional Chinese, and Simplified Chinese).

### Core Purpose
Store and organize user information across multiple profile sections including basic information, financial situation, mental health conditions, and physical health conditions.

### Key Features
- **Create Profile**: Users can create a new profile with a unique 5-15 character ID and password
- **View Profile**: Anyone can view a profile by entering the profile ID (no authentication required)
- **Edit Profile**: Users must authenticate with both ID and password to modify their profile
- **Delete Profile**: Authenticated users can delete their profiles
- **Multi-Language Support**: Full internationalization in 3 languages
- **Responsive Design**: Works on web and iOS platforms

---

## Architecture

### System Design Pattern
The application follows a layered architecture:

```
Presentation Layer (Screens & Widgets)
         ↓
State Management Layer (Provider)
         ↓
Service Layer (FirebaseService)
         ↓
Backend (Firebase Firestore + Firebase Hosting)
```

### Technology Stack

**Frontend Framework**
- Flutter SDK 3.0+
- Material Design 3
- Dart programming language

**State Management**
- Provider package - Manages UI state and profile data

**Navigation**
- GoRouter - Declarative routing and navigation

**Backend & Data**
- Firebase Firestore - NoSQL cloud database
- Firebase Hosting - Web application hosting and deployment
- Firebase SDK for Flutter - Native integration

**Localization**
- intl package - Internationalization support
- ARB files for translation management

**Configuration**
- Firebase CLI - Project configuration and deployment
- google-services.json / GoogleService-Info.plist - Platform-specific Firebase config

### Key Architectural Patterns
- **MVVM-like Structure**: Separation of UI logic, state management, and data access
- **Service-Oriented Architecture**: Centralized Firebase service for all backend operations
- **Provider Pattern**: State management with Provider for reactive UI updates
- **Route Guards**: Authentication checks at navigation level (enter-id, edit-id routes)
- **Cloud-First Design**: Web app hosted on Firebase Hosting with global CDN delivery

---

## Core Features

### 1. Profile Management

#### Create Profile
**Function**: Create a new user profile in the system
- **Entry Point**: [lib/screens/create_profile_screen.dart](lib/screens/create_profile_screen.dart)
- **Validation Rules**:
  - Profile ID: 5-15 alphanumeric characters
  - Password: 5-15 characters
  - Password confirmation must match
- **Process**:
  1. User enters ID and password via form
  2. Validation occurs on form submission
  3. FirebaseService.createProfile() creates the document in Firestore
  4. App automatically navigates to edit mode for the new profile
  5. User can immediately fill in profile sections

#### View Profile
**Function**: Display a read-only view of any profile
- **Entry Point**: [lib/screens/enter_profile_id_screen.dart](lib/screens/enter_profile_id_screen.dart)
- **Process**:
  1. User enters a profile ID
  2. FirebaseService.profileExists() validates the ID in Firestore
  3. Navigation to [lib/screens/view_profile_screen.dart](lib/screens/view_profile_screen.dart)
  4. Profile data displayed read-only via SectionNavigator with isEditable=false

#### Edit Profile
**Function**: Modify an existing profile with authentication
- **Entry Points**:
  - [lib/screens/enter_edit_id_screen.dart](lib/screens/enter_edit_id_screen.dart) - Authentication screen
  - [lib/screens/edit_profile_screen.dart](lib/screens/edit_profile_screen.dart) - Editing interface
- **Process**:
  1. User enters ID and password
  2. FirebaseService.validateCredentials() verifies credentials in Firestore
  3. On success, navigate to edit screen
  4. User modifies profile sections
  5. Save button triggers FirebaseService.updateProfile() with password
  6. Success message and navigation back to view

#### Delete Profile
**Function**: Permanently remove a profile from the system
- **Service Method**: FirebaseService.deleteProfile(id, password)
- **Requirements**: Must provide correct ID and password
- **Location**: Available in edit flow (implementation ready in service layer)

#### Third-Party Contributions (Planned Feature)
**Function**: Allow external parties (teachers, therapists, doctors) to contribute reports/notes to a profile

**Design Overview:**
This feature enables profile owners to grant temporary, limited access to third parties who can append timestamped reports without viewing existing profile content.

**Access Control Model:**
- **Token-Based Authentication**: Profile owner generates unique access tokens
- **Append-Only Permission**: Contributors can only add new entries, not edit/delete existing content
- **No Read Access**: Contributors cannot view the profile; they only submit blind reports
- **Scoped Tokens**: Each token is restricted to specific section(s) and has an expiration date

**User Flows:**

1. **Profile Owner Generates Token**
   - Navigate to "Manage Contributors" in edit mode
   - Select section(s) for contribution (e.g., "Health Conditions", "School Reports")
   - Specify contributor metadata: name, role (e.g., "ST", "Teacher", "Doctor")
   - Set expiration date (optional)
   - System generates unique 8-12 character token (e.g., `TEACH-X7K9-2M4P`)
   - Owner shares token with contributor via secure channel

2. **Contributor Submits Report**
   - Access contributor portal: `/contribute/:token`
   - System validates token and displays submission form
   - Contributor enters their report/notes in text field
   - Submit creates timestamped entry with metadata
   - Confirmation message shown (no profile data revealed)

3. **Profile Owner Reviews Contributions**
   - View contributed reports in profile with clear attribution
   - See contributor name, role, timestamp for each entry
   - Option to revoke tokens at any time
   - Archive or delete individual contributions

**Data Structure:**

```javascript
// Firestore schema extension
profiles/{profileId} {
  password: string,
  sections: map { ... },
  createdAt: timestamp,

  // New: Contribution tokens
  contributorTokens: map {
    "TEACH-X7K9-2M4P": {
      contributorName: "Ms. Johnson",
      contributorRole: "Teacher",
      allowedSections: ["school_reports"],
      createdAt: timestamp,
      expiresAt: timestamp | null,
      isActive: boolean,
      usageCount: number
    }
  },

  // New: Timestamped contributions
  contributions: array [
    {
      id: "contrib_abc123",
      sectionId: "school_reports",
      content: "Student shows improvement in reading comprehension...",
      contributorName: "Ms. Johnson",
      contributorRole: "Teacher",
      contributorToken: "TEACH-X7K9-2M4P",
      submittedAt: timestamp,
      isArchived: boolean
    }
  ]
}
```

**Security Rules Extension:**

```javascript
// Firestore rules for contributor access
match /profiles/{profileId} {
  // Contributors can only add to contributions array with valid token
  allow update: if
    request.auth == null &&
    validateContributorToken(request.resource.data, resource.data) &&
    onlyAppendingToContributions(request.resource.data, resource.data);
}

function validateContributorToken(newData, existingData) {
  let token = request.resource.data.lastUsedToken;
  let tokenData = existingData.contributorTokens[token];

  return tokenData != null &&
         tokenData.isActive == true &&
         (tokenData.expiresAt == null || tokenData.expiresAt > request.time) &&
         contributionMatchesTokenScope(newData, tokenData);
}
```

**UI Components:**

1. **Manage Contributors Screen** (Owner only)
   - List of active tokens with details
   - "Generate New Token" button
   - Token revocation controls
   - View contribution history per token

2. **Contributor Portal** (Public with token)
   - Minimal UI: token input → submission form → confirmation
   - No navigation to other parts of the app
   - No display of profile data
   - Success/error messaging

3. **Contributions Display** (View/Edit Profile)
   - Separate subsection within each section showing contributions
   - Each entry displays: contributor badge, role, timestamp, content
   - Filter/sort by contributor or date
   - Archive/delete buttons for owner

**Service Layer Methods:**

```dart
// New FirebaseService methods
class FirebaseService {
  // Owner operations
  Future<String> generateContributorToken({
    required String profileId,
    required String password,
    required String contributorName,
    required String contributorRole,
    required List<String> allowedSections,
    DateTime? expiresAt,
  });

  Future<bool> revokeContributorToken(String profileId, String password, String token);

  Future<List<ContributorToken>> listContributorTokens(String profileId, String password);

  // Contributor operations (no password required, uses token)
  Future<bool> submitContribution({
    required String profileId,
    required String token,
    required String sectionId,
    required String content,
  });

  Future<TokenInfo?> validateToken(String profileId, String token);

  // Owner retrieval
  Future<List<Contribution>> getContributions(String profileId, String password, {String? sectionId});

  Future<bool> archiveContribution(String profileId, String password, String contributionId);
}
```

**Implementation Phases:**

**Phase 1: Basic Token System**
- Generate and store tokens
- Token validation service
- Contributor submission endpoint
- Display contributions in profile

**Phase 2: Management UI**
- Token management screen for owners
- Token listing and revocation
- Contribution moderation tools

**Phase 3: Enhanced Features**
- Token usage analytics
- Email notifications on new contributions
- Batch token generation
- Contributor categories/templates

**Benefits:**
- ✅ **Privacy-First**: Contributors can't see sensitive profile data
- ✅ **Secure**: Tokens can be revoked instantly if compromised
- ✅ **Traceable**: All contributions are attributed and timestamped
- ✅ **Flexible**: Different tokens for different contributors/purposes
- ✅ **Audit Trail**: Complete history of who contributed what and when

**Use Cases:**
- **Education**: Teachers submit term reports, progress notes
- **Healthcare**: Speech therapists, occupational therapists submit session notes
- **Medical**: Doctors add medical observations or treatment notes
- **Family**: Tutors, coaches, babysitters share observations
- **Professional**: Career counselors, mentors provide feedback

### 2. Profile Sections

Profiles are organized into sections defined in [assets/sections.json](assets/sections.json):

| Section | Order | Purpose |
|---------|-------|---------|
| Basic Information | 1 | Personal details and identification |
| Financial Situation | 15 | Financial status and information |
| Mental Conditions | 16 | Mental health information |
| Health Conditions | 17 | Physical health information |

Each section contains free-form text that users can fill in with relevant information.

#### Section Flexibility & Extensibility

**Current Design Limitations:**

The current architecture has **mixed flexibility** for adding/removing sections:

**✅ Easy to Modify (Data Layer)**
- Firestore uses a NoSQL map structure, so new sections are automatically supported
- No database migrations needed - sections are stored as key-value pairs
- Existing profiles won't break when new sections are added

**⚠️ Requires Code Changes (Presentation Layer)**
1. **sections.json**: Add/remove section definitions with `id`, `titleKey`, and `order`
2. **Localization files** (3 files): Add translations in `app_en.arb`, `app_zh_CN.arb`, `app_zh_TW.arb`
3. **Hardcoded switch statements** in two widget files:
   - [lib/widgets/section_navigator.dart](lib/widgets/section_navigator.dart):57-97 - `_getSectionTitle()` method
   - [lib/widgets/section_editor.dart](lib/widgets/section_editor.dart):45-76 - `_getSectionTitle()` method

**Impact Assessment:**

| Change | Difficulty | Files to Modify | Breaking Changes |
|--------|-----------|-----------------|------------------|
| Add new section | Medium | 5 files (1 JSON + 3 ARB + 2 Dart) | No |
| Remove section | Medium | 5 files (1 JSON + 3 ARB + 2 Dart) | No (data preserved in DB) |
| Reorder sections | Easy | 1 file (sections.json) | No |
| Rename section | Hard | 6 files (add localization + code) | Yes (DB migration needed) |

**Recommended Improvements for Better Flexibility:**

To make the system truly flexible without code changes, consider:

1. **Dynamic Localization**: Store section titles in Firestore or use a fallback system
2. **Remove Switch Statements**: Use a dynamic lookup from `AppLocalizations` via reflection or a map
3. **Section Metadata in Database**: Store section definitions in Firestore instead of `sections.json`
4. **Admin Panel**: Create a UI to manage sections without code deployment

**Example Workaround (Current System):**

To add a new section called "Career Goals":
```json
// 1. Update assets/sections.json
{
  "id": "career_goals",
  "titleKey": "section.career_goals",
  "order": 18
}

// 2. Update app_en.arb (and zh_CN, zh_TW)
"sectionCareerGoals": "Career Goals"

// 3. Add to both switch statements in section_navigator.dart & section_editor.dart
case 'section.career_goals':
  return l10n.sectionCareerGoals;
```

The **database requires no changes** - new sections automatically work with existing Firestore documents.

---

## Screen & Component Breakdown

### Screens

#### Home Screen
**File**: [lib/screens/home_screen.dart](lib/screens/home_screen.dart)
**Purpose**: Landing page and main navigation hub
**Features**:
- Three main action buttons:
  - "View Profile" → Navigate to enter profile ID
  - "Edit Profile" → Navigate to authentication
  - "Create Profile" → Navigate to create form
- Uses CommonAppBar with language switcher
- Responsive layout for web and mobile

#### Create Profile Screen
**File**: [lib/screens/create_profile_screen.dart](lib/screens/create_profile_screen.dart)
**Purpose**: Form-based profile creation
**Features**:
- Text fields for ID and password
- Password confirmation field
- Form validation feedback
- Error message display
- Navigation after successful creation

#### Enter Profile ID Screen
**File**: [lib/screens/enter_profile_id_screen.dart](lib/screens/enter_profile_id_screen.dart)
**Purpose**: ID input for viewing profiles
**Features**:
- Single text field for profile ID
- Existence validation
- Error handling for non-existent profiles

#### Enter Edit ID Screen
**File**: [lib/screens/enter_edit_id_screen.dart](lib/screens/enter_edit_id_screen.dart)
**Purpose**: Authentication for profile editing
**Features**:
- ID and password input fields
- Credential validation
- Authentication error messages
- Prevents unauthorized access

#### View Profile Screen
**File**: [lib/screens/view_profile_screen.dart](lib/screens/view_profile_screen.dart)
**Purpose**: Read-only profile display
**Features**:
- Uses SectionNavigator with isEditable=false
- Section dropdown navigation
- Previous/Next buttons
- Progress indicator (e.g., "1/4")
- CommonAppBar for navigation

#### Edit Profile Screen
**File**: [lib/screens/edit_profile_screen.dart](lib/screens/edit_profile_screen.dart)
**Purpose**: Profile modification interface
**Features**:
- Uses SectionNavigator with isEditable=true
- Section dropdown navigation
- Previous/Next buttons
- Save button for persistence
- Progress indicator
- CommonAppBar for navigation

### Widgets

#### SectionNavigator
**File**: [lib/widgets/section_navigator.dart](lib/widgets/section_navigator.dart)
**Purpose**: Manages navigation between profile sections
**Key Props**:
- `profileId`: Identifies which profile to load/edit
- `isEditable`: Boolean to toggle edit/view mode
- `onSave`: Callback when save button is pressed
**Features**:
- Dropdown selector for quick section access
- Previous/Next buttons for sequential navigation
- Progress display (current section / total sections)
- Renders SectionEditor component

#### SectionEditor
**File**: [lib/widgets/section_editor.dart](lib/widgets/section_editor.dart)
**Purpose**: Text editing/display for individual sections
**Features**:
- Multi-line text field when editable
- Read-only text display when not editable
- Localized section titles
- Disabled state handling

#### CommonAppBar
**File**: [lib/widgets/common_app_bar.dart](lib/widgets/common_app_bar.dart)
**Purpose**: Reusable application header
**Features**:
- Home button navigation
- Language switcher dropdown (English, 繁體中文, 简体中文)
- Consistent branding across screens

---

## Data Layer

### Profile Model
**File**: [lib/models/profile.dart](lib/models/profile.dart)

```dart
class Profile {
  final String id;
  final String password;
  final Map<String, dynamic> sections;

  Profile({
    required this.id,
    required this.password,
    required this.sections,
  });

  factory Profile.fromJson(Map<String, dynamic> json) { ... }
  Map<String, dynamic> toJson() { ... }
  Profile copyWith({ ... }) { ... }
}
```

**Properties**:
- `id`: Unique profile identifier (5-15 characters)
- `password`: Authentication credential
- `sections`: Map of section names to content text

### Database Schema

**Collection**: `profiles`

Firebase Firestore uses a NoSQL document-based structure:

```javascript
profiles/{profileId} {
  password: string,              // User's password (plain text - security concern)
  sections: map {                // Map of section names to content
    "Basic Information": string,
    "Financial Situation": string,
    "Mental Conditions": string,
    "Health Conditions": string
  },
  createdAt: timestamp          // Server timestamp for creation
}
```

**Document Structure**:
- **Document ID**: Profile identifier (5-15 characters) - serves as primary key
- **password** (string): User's password (stored plain text - security concern)
- **sections** (map): Key-value pairs of section names and their text content
- **createdAt** (timestamp): Firestore server timestamp for profile creation

**Firestore Security Rules** (firebase.rules):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /profiles/{profileId} {
      // Anyone can read profiles
      allow read: if true;

      // Create requires valid data
      allow create: if request.resource.data.keys().hasAll(['password', 'sections', 'createdAt']);

      // Update/delete require password match
      allow update, delete: if request.resource.data.password == resource.data.password;
    }
  }
}
```

### FirebaseService
**File**: [lib/services/firebase_service.dart](lib/services/firebase_service.dart)

**Core Functions**:

#### createProfile(id, password, initialData)
Creates a new profile document in Firestore.
- **Parameters**:
  - `id`: Profile identifier (used as document ID)
  - `password`: User password
  - `initialData`: Initial section data (typically empty map)
- **Returns**: Boolean success status
- **Firestore Operation**: `collection('profiles').doc(id).set({...})`
- **Validation**: Checks ID format and uniqueness before creation

#### getProfile(id)
Retrieves a complete profile by ID.
- **Parameters**: `id` - Profile identifier (document ID)
- **Returns**: Profile object with all sections or null if not found
- **Firestore Operation**: `collection('profiles').doc(id).get()`
- **Access**: Public - no authentication required (read allowed in security rules)

#### profileExists(id)
Checks if a profile document exists without retrieving full data.
- **Parameters**: `id` - Profile identifier (document ID)
- **Returns**: Boolean
- **Firestore Operation**: `collection('profiles').doc(id).get()` with exists check
- **Use Case**: Validation before navigation

#### validateCredentials(id, password)
Verifies ID/password combination against Firestore.
- **Parameters**:
  - `id`: Profile identifier (document ID)
  - `password`: User password
- **Returns**: Boolean - true if document exists and password matches
- **Firestore Operation**: Get document and compare password field
- **Security**: Used before granting edit access

#### updateProfile(id, password, updatedData)
Saves changes to a profile document.
- **Parameters**:
  - `id`: Profile identifier (document ID)
  - `password`: Authentication credential
  - `updatedData`: Modified section data
- **Returns**: Boolean success status
- **Firestore Operation**: `collection('profiles').doc(id).update({'sections': updatedData})`
- **Security**: Validates password before allowing update

#### deleteProfile(id, password)
Removes a profile document from Firestore.
- **Parameters**:
  - `id`: Profile identifier (document ID)
  - `password`: Authentication credential
- **Returns**: Boolean success status
- **Firestore Operation**: `collection('profiles').doc(id).delete()`
- **Security**: Validates password before deletion
- **Destructive**: Cannot be undone

---

## Routing

**Router File**: [lib/router.dart](lib/router.dart)

**Route Structure** (using GoRouter):

| Route | Screen | Purpose | Auth Required |
|-------|--------|---------|---------------|
| `/` | HomeScreen | Landing page | No |
| `/create` | CreateProfileScreen | Create new profile | No |
| `/enter-id` | EnterProfileIdScreen | Enter ID to view | No |
| `/view/:id` | ViewProfileScreen | Display profile | No |
| `/edit-id` | EnterEditIdScreen | Authentication for edit | No* |
| `/edit/:id` | EditProfileScreen | Edit profile | Yes* |
| `/edit/:id/contributors` | ManageContributorsScreen | Manage contributor tokens | Yes* |
| `/contribute/:token` | ContributorPortalScreen | Submit contribution via token | Token** |

*Authentication happens at screen level, not route level
**Token-based access (no profile password required)

**Navigation Flow**:
```
Home
├─→ Create Profile → Edit (new profile)
├─→ Enter ID → View Profile
└─→ Edit ID (auth) → Edit Profile
```

---

## State Management

**Framework**: Provider

**State Structures**:

### LocaleProvider
**File**: [lib/providers/locale_provider.dart](lib/providers/locale_provider.dart)

**Purpose**: Manages current language selection across the app

**State**:
- `currentLocale`: Currently selected Locale

**Methods**:
- `setLocale(Locale)`: Change application language
- Notifies all listeners when locale changes
- Persists selection for app restarts

### Profile Data Flow
- Profiles are loaded via SupabaseService
- Data is passed down through widget tree
- Edits are collected in local state
- Save triggers service update and state refresh

---

## Internationalization (i18n)

**Framework**: intl package with ARB files

**Supported Languages**:
1. **English** (en) - Base language
2. **Traditional Chinese** (zh_TW) - 繁體中文
3. **Simplified Chinese** (zh_CN) - 简体中文

**File Structure**:
```
lib/l10n/
├── app_en.arb
├── app_zh_CN.arb
└── app_zh_TW.arb
```

**Key Translated Elements**:
- Screen titles and labels
- Button text
- Error messages
- Validation messages
- Section names (Basic Information, Financial Situation, etc.)

**Implementation**:
- Uses `AppLocalizations` delegate
- `LocaleProvider` manages current locale
- CommonAppBar provides language switcher
- All UI text uses localization keys

---

## Security Considerations

### Current Implementation
- **Password Storage**: Passwords stored in plain text in Firestore ⚠️ SECURITY RISK
- **View Access**: Open - anyone with a profile ID can view profiles (Firestore security rules allow read: true)
- **Edit/Update/Delete**: Require password authentication (validated in application layer)
- **Transport**: Uses HTTPS via Firebase (TLS 1.2+)
- **Firestore Security Rules**: Basic rules for read/write access control
- **No Token-Based Auth**: Direct password validation on each operation

### Security Concerns
1. **Plain Text Passwords**: Should use bcrypt, scrypt, or Argon2 hashing
2. **No Password Recovery**: No mechanism for users to reset forgotten passwords
3. **No Rate Limiting**: Potential for brute force attacks
4. **No Session Management**: Each request requires full authentication
5. **No Audit Trail**: No logging of who accessed what and when

### Recommendations
1. Implement password hashing using Cloud Functions (bcrypt recommended)
2. Use Firebase Authentication for proper user management
3. Implement Firebase App Check for abuse prevention
4. Add password reset/recovery flow via Firebase Auth
5. Use Firebase Analytics for access logging and audit trail
6. Consider two-factor authentication via Firebase Auth
7. Enhance Firestore Security Rules to validate password in rules layer
8. Enable Firebase Security Monitoring for threat detection

---

## Technology Stack Summary

### Core Dependencies (from pubspec.yaml)
- **flutter**: SDK 3.0+ - Mobile framework
- **cloud_firestore**: Firebase Firestore database SDK
- **firebase_core**: Firebase initialization and configuration
- **go_router**: Declarative routing
- **provider**: State management
- **intl**: Internationalization
- **flutter_localizations**: i18n support

### Firebase Services Used
- **Firebase Firestore**: NoSQL cloud database for profile storage
- **Firebase Hosting**: Static web app hosting with global CDN
- **Firebase CLI**: Deployment and project management tool

### Platform Support
- **Web**: Primary platform hosted on Firebase Hosting with responsive design
- **iOS**: Built and tested with Firebase iOS SDK
- **Android**: Can be configured with Firebase Android SDK (google-services.json)

### Development Tools
- **Dart SDK**: Included with Flutter
- **Firebase CLI**: For deployment, database management, and local development
- **FlutterFire CLI**: For Firebase project configuration
- **Firebase Console**: Web-based project management and monitoring

---

## Project Structure

```
personal_profile/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── router.dart                  # GoRouter configuration
│   │
│   ├── screens/                     # All screen widgets
│   │   ├── home_screen.dart
│   │   ├── create_profile_screen.dart
│   │   ├── enter_profile_id_screen.dart
│   │   ├── enter_edit_id_screen.dart
│   │   ├── view_profile_screen.dart
│   │   └── edit_profile_screen.dart
│   │
│   ├── widgets/                     # Reusable components
│   │   ├── section_navigator.dart
│   │   ├── section_editor.dart
│   │   └── common_app_bar.dart
│   │
│   ├── models/                      # Data models
│   │   └── profile.dart
│   │
│   ├── services/                    # Business logic
│   │   └── firebase_service.dart
│   │
│   ├── providers/                   # State management
│   │   └── locale_provider.dart
│   │
│   └── l10n/                        # Localization files
│       ├── app_en.arb
│       ├── app_zh_CN.arb
│       └── app_zh_TW.arb
│
├── assets/
│   └── sections.json                # Profile section definitions
│
├── android/                         # Android platform code
│   └── app/google-services.json     # Firebase Android config
│
├── ios/                             # iOS platform code
│   └── Runner/GoogleService-Info.plist  # Firebase iOS config
│
├── web/                             # Web platform code
│   └── index.html                   # Firebase web initialization
│
├── firebase.json                    # Firebase Hosting configuration
├── .firebaserc                      # Firebase project aliases
├── firestore.rules                  # Firestore security rules
├── pubspec.yaml                     # Dependencies and metadata
├── README.md                        # Project documentation
└── Spec.md                          # This file

```

---

## Development Notes

### Environment Setup
1. Install Flutter SDK 3.0+
2. Install Firebase CLI: `npm install -g firebase-tools`
3. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
4. Login to Firebase: `firebase login`
5. Initialize Firebase project: `flutterfire configure`
6. Run `flutter pub get` to install dependencies

### Firebase Project Configuration
1. Create Firebase project in [Firebase Console](https://console.firebase.google.com)
2. Enable Firestore Database
3. Enable Firebase Hosting
4. Run `flutterfire configure` to generate platform-specific config files
5. Deploy Firestore security rules: `firebase deploy --only firestore:rules`

### Building
- **Web**: `flutter build web`
- **iOS**: `flutter build ios`

### Running Locally
- **Web**: `flutter run -d web` or `flutter run -d chrome`
- **iOS**: `flutter run -d ios`
- **Firebase Emulator**: `firebase emulators:start` (for local Firestore testing)

### Deployment

**Web Deployment to Firebase Hosting**:
```bash
# Build web app
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

**Deployment Configuration** (firebase.json):
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### Testing
- Unit tests for services and models
- Widget tests for screens and components
- Integration tests for navigation flows

---

## Future Enhancement Opportunities

### High Priority
1. **Third-Party Contributions**: Implement token-based contributor system (see Core Features section)
2. **Firebase Authentication**: Migrate to Firebase Auth for proper user management
3. **Password Hashing**: Use Cloud Functions to hash passwords with bcrypt
4. **Cloud Functions**: Add serverside validation and business logic

### Medium Priority
5. **Contribution Notifications**: Email/SMS alerts when contributors submit reports
6. **Contributor Analytics**: Track token usage, contribution frequency, and engagement
7. **Rich Text Editor**: Support formatting, attachments, images in contributions
8. **Firebase Storage**: Store profile images, attachments, and documents
9. **Data Export**: Export profile data as PDF using Cloud Functions
10. **Firebase Search**: Implement Algolia or full-text search across profiles and contributions

### Low Priority
11. **Offline Support**: Enable Firestore offline persistence
12. **Firebase Analytics**: Track feature usage and user behavior
13. **Performance Monitoring**: Add Firebase Performance Monitoring
14. **A/B Testing**: Use Firebase Remote Config for feature flags
15. **Push Notifications**: Firebase Cloud Messaging for new contribution alerts
16. **App Check**: Protect against abuse with Firebase App Check
17. **Crashlytics**: Firebase Crashlytics for error tracking
18. **CI/CD**: GitHub Actions with Firebase Hosting auto-deploy
19. **Contribution Templates**: Pre-defined report templates for different contributor types
20. **Bulk Token Management**: Generate and manage multiple tokens at once

---

*Last Updated: 2025-12-29*
*Specification Version: 1.0*
