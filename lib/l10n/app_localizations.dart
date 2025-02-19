import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh', 'CN'),
    Locale('zh', 'TW'),
    Locale('zh')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Personal Profile'**
  String get appTitle;

  /// Button text to create a new profile
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get createProfile;

  /// Button text to view a profile
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// Button text to edit a profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Button text to delete a profile
  ///
  /// In en, this message translates to:
  /// **'Delete Profile'**
  String get deleteProfile;

  /// Label for profile ID field
  ///
  /// In en, this message translates to:
  /// **'Profile ID'**
  String get profileId;

  /// Label for password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for password confirmation field
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Button text to enter profile ID
  ///
  /// In en, this message translates to:
  /// **'Enter Profile ID'**
  String get enterProfileId;

  /// Title for dialog to enter password
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// Text for cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button text to save changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Button text to view something
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// Button text to edit something
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Button text to delete something
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Error message for required fields
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// Error message for invalid credentials
  ///
  /// In en, this message translates to:
  /// **'Invalid ID or password'**
  String get invalidCredentials;

  /// Error message when profile is not found
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// Error message when profile creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create profile'**
  String get createFailed;

  /// Error message when profile update fails
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get updateFailed;

  /// Error message when profile deletion fails
  ///
  /// In en, this message translates to:
  /// **'Failed to delete profile'**
  String get deleteFailed;

  /// Error message when passwords do not match
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Section title for basic information
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get sectionBasicInfo;

  /// Section title for work experience
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get sectionWorkExperience;

  /// Section title for education
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get sectionEducation;

  /// Section title for skills
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get sectionSkills;

  /// Section title for projects
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get sectionProjects;

  /// Section title for certifications
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get sectionCertifications;

  /// Section title for languages
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get sectionLanguages;

  /// Section title for volunteer work
  ///
  /// In en, this message translates to:
  /// **'Volunteer Work'**
  String get sectionVolunteerWork;

  /// Section title for awards
  ///
  /// In en, this message translates to:
  /// **'Awards'**
  String get sectionAwards;

  /// Section title for publications
  ///
  /// In en, this message translates to:
  /// **'Publications'**
  String get sectionPublications;

  /// Section title for patents
  ///
  /// In en, this message translates to:
  /// **'Patents'**
  String get sectionPatents;

  /// Section title for references
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get sectionReferences;

  /// Section title for personal interests
  ///
  /// In en, this message translates to:
  /// **'Personal Interests'**
  String get sectionPersonalInterests;

  /// Section title for social media
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get sectionSocialMedia;

  /// Section title for financial situation
  ///
  /// In en, this message translates to:
  /// **'Financial Situation'**
  String get sectionFinancialSituation;

  /// Section title for mental conditions
  ///
  /// In en, this message translates to:
  /// **'Mental Conditions'**
  String get sectionMentalConditions;

  /// Section title for health conditions
  ///
  /// In en, this message translates to:
  /// **'Health Conditions'**
  String get sectionHealthConditions;

  /// Section title for personal strengths
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get sectionStrengths;

  /// Section title for personal weaknesses
  ///
  /// In en, this message translates to:
  /// **'Weaknesses'**
  String get sectionWeaknesses;

  /// Section title for things the person likes
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get sectionLikes;

  /// Section title for things the person dislikes
  ///
  /// In en, this message translates to:
  /// **'Dislikes'**
  String get sectionDislikes;

  /// Section title for short-term goals
  ///
  /// In en, this message translates to:
  /// **'Short-term Goals'**
  String get sectionShortTermGoals;

  /// Section title for long-term goals
  ///
  /// In en, this message translates to:
  /// **'Long-term Goals'**
  String get sectionLongTermGoals;

  /// Section title for favorite pastimes and hobbies
  ///
  /// In en, this message translates to:
  /// **'Favorite Pastimes'**
  String get sectionFavoritePastimes;

  /// Section title for family situation
  ///
  /// In en, this message translates to:
  /// **'Family Situation'**
  String get sectionFamilySituation;

  /// Section title for social relationships
  ///
  /// In en, this message translates to:
  /// **'Social Relationships'**
  String get sectionSocialRelationship;

  /// Message when no sections are available
  ///
  /// In en, this message translates to:
  /// **'No sections available'**
  String get noSections;

  /// Confirmation message for profile deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this profile? This action cannot be undone.'**
  String get deleteConfirmation;

  /// Error message shown when profile creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to create profile. Please try again.'**
  String get profileCreationFailed;

  /// Error message shown when profile ID length is invalid
  ///
  /// In en, this message translates to:
  /// **'ID must be between 5 and 15 characters'**
  String get invalidIdLength;

  /// Error message shown when password length is invalid
  ///
  /// In en, this message translates to:
  /// **'Password must be between 5 and 15 characters'**
  String get invalidPasswordLength;

  /// Error message shown when a profile is not found
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get errorProfileNotFound;

  /// Generic error message shown when something goes wrong
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorGeneric;

  /// Error message for profile ID length validation
  ///
  /// In en, this message translates to:
  /// **'Profile ID must be between {minLength} and {maxLength} characters'**
  String idLengthValidation(Object maxLength, Object minLength);

  /// Error message for password length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be between {minLength} and {maxLength} characters'**
  String passwordLengthValidation(Object maxLength, Object minLength);

  /// Button text to proceed to the next step
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'CN': return AppLocalizationsZhCn();
case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
