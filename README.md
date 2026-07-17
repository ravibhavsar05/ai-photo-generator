# 🎨 Artiva AI - AI Photo Generator

Artiva AI is a premium, feature-rich Flutter mobile application that leverages Google's advanced Gemini generative models to create, edit, and enhance images. With clean GetX state management, responsive layouts, and local history management, it provides a seamless user experience for AI-powered photo generation and editing.

## 📱 App Demo

![Artiva AI App Demo](https://github.com/ravibhavsar05/ai-photo-generator/raw/main/assets/videos/demo.gif)

---

## 🌟 Key Features

The application provides a comprehensive suite of AI image manipulation tools:

*   **Prompt to Image (Text-to-Image):** Generates high-quality, professional-grade images from textual descriptions.
*   **Face Swap:** Merges user faces into premade templates or custom backgrounds realistically.
*   **Remove Background (Background Removal):** Highly precise subject isolation, rendering backgrounds transparent.
*   **Enhance Photo (Super-Resolution):** Reconstructs blurry, low-resolution, or motion-distorted images to modern HD clarity.
*   **Old Photo Restore:** Repairs physical damage (scratches, dust, cracks) and color imbalances from vintage photos.
*   **Local History:** Keeps a local, persistence-enabled gallery of all generated and edited creations.
*   **Interactive Cropper:** Allows real-time image cropping and sizing before uploading to the AI server.

---

## 🛠 Tech Stack

*   **Framework:** [Flutter SDK](https://flutter.dev) (Supports Android & iOS)
*   **Architecture & State Management:** [GetX](https://pub.dev/packages/get)
*   **UI Sizing:** [Sizer](https://pub.dev/packages/sizer) for responsive and adaptive screen proportions
*   **Networking:** [HTTP](https://pub.dev/packages/http) and Multipart requests
*   **Image Processing:** [Image](https://pub.dev/packages/image) & [Crop Your Image](https://pub.dev/packages/crop_your_image)
*   **Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences) & local file system storage

---

## 🔑 API Configuration & Setup

Artiva AI integrates with the **Google Gemini API** (Google AI Studio) via the `v1beta` endpoint for multimodal content generation.

### 1. Generating your Gemini API Key

To use the AI generation features, you need to acquire an API key:

#### **Method A: Via Google AI Studio (Fastest)**
1. Visit [Google AI Studio](https://aistudio.google.com/).
2. Sign in with your Google account.
3. Click the **"Get API key"** or **"Create API Key"** button.
4. Select a Google Cloud project (or create a new one) and click **"Create API Key in Existing Project"**.
5. Copy the generated API key (starts with `AIzaSy...`).

#### **Method B: Via Google Cloud Console**
1. Open the [Google Cloud Console](https://console.cloud.google.com/).
2. Select your active project.
3. Search for the **Generative Language API** in the API Library and click **Enable**.
4. Go to **APIs & Services > Credentials** to create a standard API Key.

---

### 2. Injecting the API Key into the App

Artiva AI is designed to read the Gemini API key securely through environment variables or configuration files. **To prevent leaking your API key on GitHub, follow the steps below.**

#### **Option 1: Using a Git-Ignored `.env` File (Most Secure)**
We have pre-configured the project's `.gitignore` to ignore `.env`.

1. Copy the example file `.env.example` to create a new file named `.env` in the root of the project:
   ```bash
   cp .env.example .env
   ```
2. Open `.env` and replace `YOUR_ACTUAL_GEMINI_API_KEY_HERE` with your real Gemini API key:
   ```env
   GEMINI_API_KEY=AIzaSy...
   ```
3. Run or compile the app using the `--dart-define-from-file` parameter:
   ```bash
   # Run in Debug mode
   flutter run --dart-define-from-file=.env

   # Build for Android Release
   flutter build apk --dart-define-from-file=.env
   ```

#### **Option 2: Direct Command-Line Injection**
If you do not want to create a local config file, you can pass the environment key directly during invocation:
```bash
flutter run --dart-define=GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE
```

> [!CAUTION]
> Avoid hardcoding your private API key directly in code repositories (such as `lib/core/services/network_services/api_config.dart`) to prevent unauthorized usage and credential leaks.

---


## 📱 Platform Configuration & Permissions

Make sure the required native permissions are enabled on target platforms:

### 🤖 Android Setup
Permissions are already declared in the main manifest file: [`android/app/src/main/AndroidManifest.xml`](file:///Users/akshay/Downloads/ai-photo-generator/android/app/src/main/AndroidManifest.xml)
*   `android.permission.CAMERA` — For taking photos directly.
*   `android.permission.READ_MEDIA_IMAGES` / `READ_EXTERNAL_STORAGE` — For picking source files.
*   `android.permission.WRITE_EXTERNAL_STORAGE` — For saving generated images.

### 🍎 iOS Setup
The usage descriptions are defined in: [`ios/Runner/Info.plist`](file:///Users/akshay/Downloads/ai-photo-generator/ios/Runner/Info.plist)
*   `NSCameraUsageDescription` — Camera capture prompt.
*   `NSPhotoLibraryUsageDescription` — Photo gallery selection access prompt.

---

## 🚀 Getting Started

Follow these steps to clean, prepare, and run the project:

### 1. Prerequisites
*   Ensure you have the Flutter SDK installed (`flutter doctor`).
*   Ensure a physical device or emulator/simulator is connected.

### 2. Clean Cache and Fetch Packages
Run these commands in the project root:
```bash
# Clear any build caches
flutter clean

# Fetch Dart dependencies
flutter pub get
```

### 3. Running the App

You can run the application using your terminal or directly within your favorite Integrated Development Environment (IDE):

#### **Method A: Via Command Line (CLI)**
Run the application while instructing Flutter to load your local `.env` values:
```bash
flutter run --dart-define-from-file=.env
```

#### **Method B: Via VS Code (Visual Studio Code)**
We have pre-configured a launch script for you:
1. Open the project in VS Code.
2. Go to the **Run and Debug** tab (or press `Ctrl+Shift+D` / `Cmd+Shift+D`).
3. Select **"Artiva AI (with .env)"** from the dropdown menu at the top.
4. Press the green play button (or press `F5`) to run the application.

#### **Method C: Via Android Studio / IntelliJ IDEA**
1. Click the configuration dropdown next to the green run arrow and select **Edit Configurations...**
2. In the **Additional run args:** input box, paste:
   ```text
   --dart-define-from-file=.env
   ```
3. Click **Apply** and click **Run**.

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── base/               # Base controller classes
│   ├── theme/              # Dark theme colors and style guide
│   ├── routes/             # App routing configuration
│   ├── services/
│   │   ├── network_services/ # API config and Gemini endpoints
│   │   └── remote_config_service/ # Local mock configs
│   └── controllers/        # Shared system controllers (e.g. crop_image)
├── domain/
│   ├── use_cases/          # Business logic wrappers
│   └── di_use_case.dart    # Dependency Injection registry
├── features/
│   ├── all_ai_generative/  # Interactive AI template gallery
│   ├── bottom_nav/         # Main layout wrapper
│   ├── enhance_photo/      # Photo resolution upscaler
│   ├── face_swap/          # Template-based face swap
│   ├── history/            # Saved history dashboard
│   ├── old_photo_restore/  # Damaged photo restoration
│   ├── prompt_to_image/    # Text prompt editor
│   ├── remove_bg/          # Background removal interface
│   ├── onboarding/         # App introduction onboarding flow
│   └── splash/             # Initial loading screen
├── utils/                  # Deterministic prompt styling & utilities
└── widgets/                # Common UI elements & custom dialogs
```

---

## 💡 AI Prompt Specifications

All features map to deterministic prompt models located in [`lib/utils/app_prompts.dart`](file:///Users/akshay/Downloads/ai-photo-generator/lib/utils/app_prompts.dart):
*   **Remove BG:** Instructs Gemini to isolate the main subject and return transparency.
*   **Enhance:** Rebuilds eyes, skin, and edges to modern HD standards while keeping facial structures authentic.
*   **Restore:** Directs model cleanup processes (removing scratches, fading, and dust).
*   **Templates:** Employs composition styling wrapper (`photorealistic, [prompt], 8k resolution, cinematic lighting`).
