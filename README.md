# Flutter Expense Tracker

A Flutter app to track personal expenses and income with Firebase authentication and Firestore storage. Users can add transactions, categorize them, and visualize spending trends using charts. 

## Features Implemented

- **Authentication**
  - Firebase Authentication integrated
  - Users sign in with Google or any Firebase-supported method
  - Each transaction is linked to the logged-in user via email

- **Transactions**
  - Add transactions with fields:
    - Date
    - Type (Income, Expense, Transfer)
    - Main Category
    - Subcategory
    - Description
    - Amount
    - Fund Source
    - Fund Destination (for transfers)
    - Fee
    - Notes
    - Transaction ID
    - User Email (from Firebase Auth)
  - In-app notifications for success or validation errors (SnackBar)
  - Saved directly to **Firestore** (`transactions` collection)

- **UI**
  - Light and dark color schemes
  - Responsive layout wrapped in `AppHeader`
  - Dynamic subcategory dropdown based on main category
  - Validation for required fields and numeric inputs

## Charts (Planned)

- Category-wise pie charts
- Monthly totals as bar charts
- Animated updates when transactions are added

## Screens (Implemented)

- Login Screen
- Home Screen
- Add Transaction Screen

## Screens (Planned)

- Transaction List Screen (show only current user’s transactions)
- Charts/Analytics Screen
- Settings/Profile Screen

## Firebase Setup

1. Set up Firebase in your Flutter project (`firebase_core`, `cloud_firestore`, `firebase_auth`).  
2. Enable **Firestore** in Firebase Console.  
3. Enable **Authentication** with Google sign-in or other providers.  
4. Add your Firebase configuration file (`google-services.json` for Android, `GoogleService-Info.plist` for iOS).  

## Getting Started

```bash
# Clone the repo via SSH
git clone git@github.com:username/flutter-expense-tracker.git

# Navigate to project folder
cd flutter-expense-tracker

# Install dependencies
flutter pub get

# Run the app
flutter run
