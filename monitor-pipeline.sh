#!/bin/bash

echo "🔍 CI/CD Pipeline Status Monitor"
echo "================================="

echo
echo "📱 iOS Build Artifacts in Google Cloud Storage:"
echo "------------------------------------------------"
gsutil ls -la gs://counter_gitcicd_app/ios-builds/production/ 2>/dev/null || echo "No production artifacts yet"

echo
echo "🏗️  Recent Google Cloud Builds:"
echo "--------------------------------"
gcloud builds list --limit=3 --format="table(id,createTime,status,source.repoSource.branchName)"

echo
echo "📊 Quick Links:"
echo "- GitHub Actions: https://github.com/ChitraJ2193/CounterApp/actions"
echo "- GCP Cloud Build: https://console.cloud.google.com/cloud-build/builds?project=counterapplication-460304"
echo "- GCS Storage: https://console.cloud.google.com/storage/browser/counter_gitcicd_app?project=counterapplication-460304" 