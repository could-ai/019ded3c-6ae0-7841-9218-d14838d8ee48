# Secure Vault

Secure Vault is a cross-platform password management application built with Flutter. It helps you safely store your credentials behind a master password, allowing you to quickly access, copy, and manage your passwords on your device.

## Features

- **Master Password Protection**: Lock your vault using a master password stored securely.
- **Save Credentials**: Keep track of usernames, passwords, URLs, and optional notes for various services.
- **Quick Copy**: One-tap action to easily copy your usernames and passwords directly to your clipboard.
- **Dark Mode Support**: Beautifully themed user interface designed to match your device's system appearance (Light/Dark).
- **No Cloud Required**: Designed to run entirely on your device using local persistence.

## Tech Stack

- **Framework**: Flutter / Dart
- **UI Toolkit**: Material 3
- **Local Persistence**: `shared_preferences`
- **Generators**: `uuid` (for unique entry IDs)

## Setup and Running

1. **Install Dependencies**
   Run the following command to download all required packages:
   ```bash
   flutter pub get
   ```

2. **Run the App**
   To launch the app on your preferred emulator or connected device:
   ```bash
   flutter run
   ```

---

## About CouldAI

This app was generated with [CouldAI](https://could.ai), an AI app builder for cross-platform apps that turns prompts into real native iOS, Android, Web, and Desktop apps with autonomous AI agents that architect, build, test, deploy, and iterate production-ready applications.