# Personal Profile Management Application

A Flutter application for managing personal profiles with support for multiple languages and web/iOS platforms.

## Features

- Create, read, update, and delete personal profiles
- Multilingual support (English, Traditional Chinese, Simplified Chinese)
- Secure profile access with ID and password
- Multiple information sections for comprehensive profile data
- Responsive design for web and mobile platforms
- Built with Flutter and Supabase

## Setup

1. Create a Supabase project and get your project URL and anon key
2. Copy `.env.example` to `.env` and fill in your Supabase credentials:
   ```
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

3. Create the following table in your Supabase database:
   ```sql
   create table profiles (
     id text primary key,
     password text not null,
     data jsonb not null,
     created_at timestamp with time zone default timezone('utc'::text, now()) not null
   );
   ```

4. Install dependencies:
   ```bash
   flutter pub get
   ```

5. Generate the necessary files:
   ```bash
   flutter pub run build_runner build
   ```

6. Run the application:
   ```bash
   # For web
   flutter run -d chrome
   
   # For iOS
   flutter run -d ios
   ```

## Project Structure

- `lib/`
  - `l10n/` - Localization files
  - `models/` - Data models
  - `providers/` - State management
  - `screens/` - UI screens
  - `services/` - Backend services
  - `main.dart` - Application entry point
  - `router.dart` - Navigation configuration

## Adding New Sections

To add new profile sections, modify the `assets/sections.json` file and add corresponding translations in the localization files (`lib/l10n/app_*.arb`).
