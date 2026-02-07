# BaiFinanzas iOS App

Native iOS shell app using [Hotwire Native](https://github.com/hotwired/hotwire-native-ios) to wrap the BaiFinanzas Rails web app.

## Prerequisites

- macOS with Xcode 15+ installed
- Apple Developer account (for device testing and TestFlight)
- BaiFinanzas Rails server running (local or production)

## Setup

### 1. Create Xcode Project

1. Open Xcode > File > New > Project
2. Choose **App** (iOS)
3. Configure:
   - Product Name: `BaiFinanzas`
   - Organization Identifier: `com.baifinanzas` (or your own)
   - Interface: **Storyboard**
   - Language: **Swift**
   - Uncheck "Include Tests"
4. Save the project inside `ios/BaiFinanzas/`

### 2. Add Hotwire Native Dependency

1. In Xcode: File > Add Package Dependencies
2. Enter URL: `https://github.com/hotwired/hotwire-native-ios`
3. Set version rule: **Up to Next Major Version** from `1.0.0`
4. Click Add Package
5. Ensure `HotwireNative` is added to the BaiFinanzas target

### 3. Replace Generated Files

Replace the Xcode-generated source files with the ones in this directory:

1. **Delete** the generated `ViewController.swift`, `Main.storyboard`, `AppDelegate.swift`, `SceneDelegate.swift`
2. **Add** all files from `BaiFinanzas/App/` to the project (drag into Xcode's App group)
3. **Add** all files from `BaiFinanzas/Configuration/` (drag into a new Configuration group)
4. **Replace** the generated `Assets.xcassets` with `BaiFinanzas/Assets.xcassets`
5. **Replace** the generated `LaunchScreen.storyboard` with `BaiFinanzas/LaunchScreen.storyboard`
6. **Replace** `Info.plist` with `BaiFinanzas/Info.plist`

### 4. Configure Server URL

Edit `BaiFinanzas/Configuration/Server.swift`:

```swift
// For local development:
static let baseURL = URL(string: "http://localhost:3000")!

// For production:
static let baseURL = URL(string: "https://baifinanzas.com")!
```

> If testing locally on a physical device, use your Mac's local IP (e.g., `http://192.168.1.X:3000`).

### 5. Remove Main Storyboard Reference

Since we use `SceneDelegate` for window setup (no Main.storyboard):

1. Select the **BaiFinanzas** target > General tab
2. Under "Deployment Info", clear the **Main Interface** field (leave it empty)
3. In Info.plist, remove any `UIMainStoryboardFile` entry if present

### 6. Configure Signing

1. Select the BaiFinanzas target > Signing & Capabilities
2. Set your Team
3. Set Bundle Identifier (e.g., `com.baifinanzas.app`)

### 7. Build and Run

1. Select a simulator (iPhone 15 Pro recommended) or connected device
2. Press Cmd+R to build and run
3. The app should show the login page on first launch

## Architecture

```
BaiFinanzas/
  App/
    AppDelegate.swift      - Hotwire config, user agent, path configuration
    SceneDelegate.swift    - Tab bar setup, 4 navigators, routing
  Configuration/
    Server.swift           - Server URL constants
    path-configuration.json - Local navigation rules (fallback)
```

### How It Works

- **4 tabs**: Home, Discovery, Calculators, Profile - each with its own `Navigator`
- **Path configuration** controls navigation behavior (push vs. modal, pull-to-refresh)
- **User agent** includes "Turbo Native" so Rails hides the web bottom nav and header
- **Sign out** reloads all tabs to the sign-in page

### Path Configuration Rules

| Pattern | Behavior |
|---------|----------|
| Default (`/.*`) | Push, pull-to-refresh on |
| `/new`, `/edit` | Modal, no pull-to-refresh |
| `/calculators/*` | Push, no pull-to-refresh (slider conflicts) |
| `/onboarding/*` | Modal, no pull-to-refresh |
| `/objectives/*/edit` | Modal |

## Rails Endpoints

The Rails backend exposes these native-specific endpoints (no auth required):

| Endpoint | Description |
|----------|-------------|
| `GET /native/config` | App version, feature flags |
| `GET /native/tabs` | Tab bar configuration |
| `GET /native/path-configuration` | Navigation rules |

## TestFlight Submission

1. In Xcode: Product > Archive
2. In Organizer: Distribute App > App Store Connect
3. Upload to App Store Connect
4. In App Store Connect: add to TestFlight, invite testers
5. App Review notes: "Hybrid app using Hotwire Native to wrap web app at [your-url]"

## Troubleshooting

**Blank screen after login**: Check that `Server.baseURL` points to a running Rails server.

**Bottom nav showing in native**: Verify the Rails server returns `turbo_native_app? == true`. The user agent must contain "Turbo Native".

**Pull-to-refresh conflicts with sliders**: Path configuration should disable pull-to-refresh on calculator pages. Check that `path-configuration.json` is included in the app bundle.

**Build error "No such module HotwireNative"**: Ensure the SPM package was added correctly (Step 2).
