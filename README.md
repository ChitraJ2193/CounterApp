# CounterApp - iOS Application

A simple iOS counter application built with SwiftUI, now configured for CI/CD with GitHub Actions and Google Cloud Storage.

## 🚀 Features

- Simple, intuitive counter interface
- Built with SwiftUI
- Automated CI/CD pipeline with GitHub Actions
- Google Cloud Storage integration for build artifacts
- App Store deployment support

## 📋 Prerequisites

- Xcode 14.0+
- iOS 16.0+
- Ruby 3.1.4 (for Fastlane)
- Google Cloud Project with Storage access
- App Store Connect account (for production deployments)

## 🔧 Setup

### Local Development

1. Clone the repository:
```bash
git clone <your-repo-url>
cd CounterApp
```

2. Open the project in Xcode:
```bash
open "Number  Counter Application.xcodeproj"
```

3. Install Ruby dependencies (if using Fastlane locally):
```bash
bundle install
```

### GitHub Actions Setup

This project uses GitHub Actions for CI/CD. The following secrets need to be configured in your GitHub repository:

#### Required Secrets:

1. **GCP_SERVICE_KEY**: Google Cloud Service Account key (JSON format, base64 encoded)
2. **APP_STORE_CONNECT_API_KEY**: App Store Connect API key (base64 encoded)
3. **API_KEY_ID**: App Store Connect API Key ID
4. **APP_STORE_ISSUER_ID**: App Store Connect Issuer ID

#### Google Cloud Setup:

1. Create a Google Cloud Storage bucket:
```bash
gsutil mb gs://counter_gitcicd_app
```

2. Create secrets for App Store credentials:
```bash
gcloud secrets create appstore-api-key --data-file="path/to/your/AuthKey_XXXXXXXXXX.p8"
```

## 🏗️ Build Pipeline

### GitHub Actions Workflow

The pipeline includes the following stages:

1. **Environment Setup**: Configure Xcode and Ruby dependencies
2. **Build**: Compile the iOS application and create archives
3. **Test**: Run unit tests (when available)
4. **Artifact Preparation**: Package build outputs
5. **Cloud Storage Upload**: Upload artifacts to Google Cloud Storage
6. **App Store Deployment**: Deploy to TestFlight (production only)

### Google Cloud Build

Alternative pipeline using Google Cloud Build is also available:

```bash
# Trigger staging build
gcloud builds submit --config=cloudbuild.yaml --substitutions=_ENVIRONMENT=staging

# Trigger production build
gcloud builds submit --config=cloudbuild.yaml --substitutions=_ENVIRONMENT=production,_APP_STORE_ISSUER_ID=your-issuer-id,_API_KEY_ID=your-key-id
```

## 🚀 Deployment

### Staging Deployment

- Automatically triggered on push to `develop` branch
- Artifacts uploaded to `gs://counter_gitcicd_app/ios-builds/staging/`

### Production Deployment

- Automatically triggered on push to `main` branch
- Artifacts uploaded to `gs://counter_gitcicd_app/ios-builds/production/`
- Automatically deployed to TestFlight

## 📱 Project Structure

```
CounterApp/
├── CounterApp/              # Main application code
│   ├── Assets.xcassets/     # App assets
│   ├── ContentView.swift    # Main UI
│   └── CounterAppApp.swift  # App entry point
├── .github/                 # GitHub Actions workflows
│   └── workflows/
│       └── ios-build-deploy.yml
├── cloudbuild.yaml          # Google Cloud Build configuration
├── Gemfile                  # Ruby dependencies
└── README.md               # This file
```

## 🔄 Migration from GitLab

This project has been migrated from GitLab CI to GitHub Actions. Key changes:

- ✅ Removed `.gitlab-ci.yml`
- ✅ Added GitHub Actions workflow
- ✅ Updated Google Cloud Build configuration
- ✅ Enhanced artifact management
- ✅ Added App Store deployment automation

## 🛠️ Development

### Building Locally

```bash
# Build for simulator
xcodebuild -project "Number  Counter Application.xcodeproj" \
           -scheme "Number  Counter Application" \
           -configuration Release \
           -sdk iphonesimulator \
           build

# Build archive for distribution
xcodebuild archive \
           -project "Number  Counter Application.xcodeproj" \
           -scheme "Number  Counter Application" \
           -configuration Release \
           -archivePath build/CounterApp.xcarchive
```

### Testing

```bash
# Run tests
xcodebuild test \
           -project "Number  Counter Application.xcodeproj" \
           -scheme "Number  Counter Application" \
           -destination 'platform=iOS Simulator,name=iPhone 14'
```

## 📄 License

[Add your license information here]

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Push to your branch
5. Create a Pull Request

## 📞 Support

For issues and questions, please open an issue in the GitHub repository. 