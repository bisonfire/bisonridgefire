## Embesafe Wildfire Protection – Field App (iOS)

An iOS SwiftUI app for Embesafe Wildfire Protection implementing core workflows: Property Mitigation Assessment, Roof Measurement (Map + LiDAR), and Config-driven Estimating with Good/Better/Best proposals.

### Features (Scaffold)
- SwiftUI app shell with tabs for Measure, Projects, Estimates, and Settings
- ARKit/MapKit-capable target setup via Info.plist privacy keys
- Xcode project generated via XcodeGen (`project.yml`)
- Assets and App Icon placeholders

### Tech
- iOS 16+
- Swift 5.9+
- SwiftUI, MapKit, ARKit, PDFKit (system frameworks)
- Optional: Turf (SPM) for geometry utilities

### Getting Started
1) Install Xcode 15+
2) Install XcodeGen: `brew install xcodegen`
3) From the repo root, generate the Xcode project:
```
xcodegen generate
```
4) Open the project:
```
open FireMitigationApp.xcodeproj
```
5) Select a signing team in Xcode (TARGETS → Signing & Capabilities) and run on device.
6) If you prefer not to use XcodeGen: Create a new iOS App in Xcode named "Embesafe", then copy the contents of `App/`, `Models/`, `Services/`, `Views/`, and `Resources/` into the project. Ensure you add `MapKit`, `ARKit`, and `PDFKit` in the target's Frameworks, and include the privacy keys from `Resources/Info.plist`.

### App Store Readiness Checklist (high level)
- Set unique bundle ID and signing team in `project.yml`
- Add real App Icons in `Resources/Assets.xcassets/AppIcon.appiconset`
- Provide privacy usage strings (camera, location, photos)
- Fill out `NSLocation*` keys only if you actually use location
- Configure any third-party services (e.g., Firebase) and remove unused permissions
- Add branded assets and company identifiers
- Create App Store assets (screenshots, description) and complete App Privacy in App Store Connect
- Ensure all third-party licenses are included and attribution where required

### Structure
```
App/
  FireMitigationApp.swift
  ContentView.swift
Models/
Services/
Views/
Resources/
  Info.plist
  Assets.xcassets/
    AppIcon.appiconset/
project.yml
```

### Notes
- This scaffold compiles on iOS and is structured to expand into:
  - Map-based polygon drawing and Turf-based area/length calculations
  - ARKit LiDAR measurement views for roof metrics
  - Config-driven estimate engine reading JSON catalogs
  - PDFKit report generation and signature capture

This codebase is branded for Embesafe. Replace assets and company text as needed in `Resources/Assets.xcassets` and `Views/AboutEmbesafeView.swift`.
