# CounterApp

A simple counter application built with SwiftUI.

## CI/CD Setup with Google Cloud

### Prerequisites
1. A Google Cloud Platform account
2. A GitLab account
3. Xcode 14.3 or later

### Setup Instructions

1. **Google Cloud Setup**
   - Create a new project in Google Cloud Console
   - Enable the necessary APIs (Cloud Build, Cloud Run, etc.)
   - Create a service account with appropriate permissions
   - Download the service account key file

2. **GitLab Setup**
   - Go to your project's Settings > CI/CD > Variables
   - Add the following variables:
     - `GOOGLE_CLOUD_KEY_FILE`: The contents of your service account key file
     - `PROJECT_ID`: Your Google Cloud project ID

3. **Update Configuration**
   - Replace `your-google-cloud-project-id` in `.gitlab-ci.yml` with your actual Google Cloud project ID

4. **Pipeline Configuration**
   The pipeline consists of two stages:
   - Build: Compiles the SwiftUI application
   - Deploy: Deploys the application to Google Cloud

### Running the Pipeline
The pipeline will automatically run when you push to the main branch. You can also manually trigger it from the GitLab CI/CD interface.

## Development

### Requirements
- Xcode 14.3+
- iOS 15.0+
- Swift 5.0+

### Building Locally
1. Clone the repository
2. Open `CounterApp.xcodeproj` in Xcode
3. Build and run the project 