#!/bin/bash

# Setup script for GitHub Actions + Google Cloud Platform integration
# This script helps configure the iOS project for CI/CD

set -e

echo "🚀 Setting up CounterApp for GitHub Actions + Google Cloud Platform"
echo "=================================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration variables
PROJECT_ID="counterapplication-460304"
BUCKET_NAME="counter_gitcicd_app"
SERVICE_ACCOUNT_NAME="github-actions-sa"
SERVICE_ACCOUNT_EMAIL="${SERVICE_ACCOUNT_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

echo -e "${YELLOW}🔧 Configuration:${NC}"
echo "  Project ID: $PROJECT_ID"
echo "  Bucket Name: $BUCKET_NAME"
echo "  Service Account: $SERVICE_ACCOUNT_EMAIL"
echo

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

if ! command_exists gcloud; then
    echo -e "${RED}❌ Google Cloud CLI not found. Please install it first.${NC}"
    echo "   Install from: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

if ! command_exists gh; then
    echo -e "${RED}❌ GitHub CLI not found. Please install it first.${NC}"
    echo "   Install from: https://cli.github.com/"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites check passed${NC}"
echo

# Authenticate with Google Cloud
echo -e "${YELLOW}🔐 Setting up Google Cloud authentication...${NC}"
echo "Please make sure you're authenticated with the correct Google Cloud project."
read -p "Continue with project '$PROJECT_ID'? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Please run: gcloud auth login && gcloud config set project $PROJECT_ID"
    exit 1
fi

gcloud config set project $PROJECT_ID

# Create Google Cloud Storage bucket
echo -e "${YELLOW}🪣 Creating Google Cloud Storage bucket...${NC}"
if gsutil ls -b gs://$BUCKET_NAME >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Bucket gs://$BUCKET_NAME already exists${NC}"
else
    gsutil mb gs://$BUCKET_NAME
    echo -e "${GREEN}✅ Created bucket gs://$BUCKET_NAME${NC}"
fi

# Set bucket permissions
gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://$BUCKET_NAME
echo -e "${GREEN}✅ Set bucket permissions${NC}"

# Create service account
echo -e "${YELLOW}👤 Creating service account...${NC}"
if gcloud iam service-accounts describe $SERVICE_ACCOUNT_EMAIL >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Service account $SERVICE_ACCOUNT_EMAIL already exists${NC}"
else
    gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME \
        --display-name="GitHub Actions Service Account" \
        --description="Service account for GitHub Actions CI/CD"
    echo -e "${GREEN}✅ Created service account $SERVICE_ACCOUNT_EMAIL${NC}"
fi

# Grant necessary roles
echo -e "${YELLOW}🔑 Granting IAM roles...${NC}"
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="roles/secretmanager.secretAccessor"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:$SERVICE_ACCOUNT_EMAIL" \
    --role="roles/cloudbuild.builds.builder"

echo -e "${GREEN}✅ Granted IAM roles${NC}"

# Create and download service account key
echo -e "${YELLOW}🔐 Creating service account key...${NC}"
KEY_FILE="github-actions-key.json"
gcloud iam service-accounts keys create $KEY_FILE \
    --iam-account=$SERVICE_ACCOUNT_EMAIL

echo -e "${GREEN}✅ Created service account key: $KEY_FILE${NC}"

# Encode key for GitHub secrets
BASE64_KEY=$(base64 < $KEY_FILE | tr -d '\n')
echo -e "${GREEN}✅ Encoded key for GitHub secrets${NC}"

# Create Google Secret Manager secrets
echo -e "${YELLOW}🔒 Setting up Secret Manager...${NC}"

# Prompt for App Store credentials
echo -e "${YELLOW}📱 App Store Connect Setup${NC}"
echo "You'll need to provide your App Store Connect credentials."
echo "If you don't have them ready, you can set them up later."
read -p "Do you have your App Store Connect API key ready? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Enter path to your App Store Connect API key (.p8 file): " API_KEY_PATH
    read -p "Enter your API Key ID: " API_KEY_ID
    read -p "Enter your Issuer ID: " ISSUER_ID
    
    if [[ -f "$API_KEY_PATH" ]]; then
        # Create secret for App Store API key
        gcloud secrets create appstore-api-key --data-file="$API_KEY_PATH" || \
        gcloud secrets versions add appstore-api-key --data-file="$API_KEY_PATH"
        
        echo -e "${GREEN}✅ Created App Store API key secret${NC}"
        
        # Store API key and issuer ID for later use
        echo "$API_KEY_ID" > .api_key_id
        echo "$ISSUER_ID" > .issuer_id
    else
        echo -e "${RED}❌ API key file not found: $API_KEY_PATH${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Skipping App Store Connect setup. You can configure this later.${NC}"
fi

# GitHub repository setup
echo -e "${YELLOW}🐙 GitHub repository setup...${NC}"
echo "Make sure you're authenticated with GitHub CLI and the repository exists."

read -p "Enter your GitHub repository (format: owner/repo): " GITHUB_REPO

# Set GitHub secrets
echo -e "${YELLOW}🔐 Setting GitHub repository secrets...${NC}"

echo "$BASE64_KEY" | gh secret set GCP_SERVICE_KEY --repo="$GITHUB_REPO"
echo -e "${GREEN}✅ Set GCP_SERVICE_KEY secret${NC}"

if [[ -f ".api_key_id" && -f ".issuer_id" ]]; then
    API_KEY_ID=$(cat .api_key_id)
    ISSUER_ID=$(cat .issuer_id)
    
    # For App Store Connect API key, we need to base64 encode it
    if [[ -f "$API_KEY_PATH" ]]; then
        BASE64_APP_KEY=$(base64 < "$API_KEY_PATH" | tr -d '\n')
        echo "$BASE64_APP_KEY" | gh secret set APP_STORE_CONNECT_API_KEY --repo="$GITHUB_REPO"
        echo -e "${GREEN}✅ Set APP_STORE_CONNECT_API_KEY secret${NC}"
    fi
    
    echo "$API_KEY_ID" | gh secret set API_KEY_ID --repo="$GITHUB_REPO"
    echo -e "${GREEN}✅ Set API_KEY_ID secret${NC}"
    
    echo "$ISSUER_ID" | gh secret set APP_STORE_ISSUER_ID --repo="$GITHUB_REPO"
    echo -e "${GREEN}✅ Set APP_STORE_ISSUER_ID secret${NC}"
    
    # Clean up temporary files
    rm -f .api_key_id .issuer_id
fi

# Clean up service account key file
rm -f $KEY_FILE

echo
echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
echo
echo -e "${YELLOW}📝 Next steps:${NC}"
echo "1. Push your code to the GitHub repository"
echo "2. The GitHub Actions workflow will trigger automatically on push to main/develop"
echo "3. Monitor the build process in the Actions tab of your GitHub repository"
echo "4. Check Google Cloud Storage for build artifacts: gs://$BUCKET_NAME"
echo
echo -e "${YELLOW}🔧 Optional configurations:${NC}"
echo "- Update version number in .github/workflows/ios-build-deploy.yml"
echo "- Customize build environments in cloudbuild.yaml"
echo "- Add additional secrets as needed"
echo
echo -e "${GREEN}Happy building! 🚀${NC}" 