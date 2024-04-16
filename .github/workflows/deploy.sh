#!/bin/bash

# Set environment variables
AZURE_WEBAPP_NAME="php-demo-webapp"    # set this to your application's name
AZURE_WEBAPP_PACKAGE_PATH="./php"      # set this to the path to your web app project, defaults to the repository root
PHP_VERSION="8.x"                  # set this to the PHP version to use

# Check if the event is workflow_call
if [[ "$GITHUB_EVENT_NAME" != "workflow_call" ]]; then
    echo "This script is intended to be called as a workflow on workflow_call event only."
    exit 1
fi

# Set permissions
chmod -R 400 $GITHUB_WORKSPACE/*

# Define the deploy function
deploy() {
    # Checkout the repository
    git checkout $GITHUB_SHA

    # Download artifact from build job
    echo "Downloading artifact from build job..."
    gh run download -n php-app

    # Login to Azure
    echo "Logging in to Azure..."
    az login --service-principal -u $AZURE_SP_APP_ID -p $AZURE_SP_PASSWORD --tenant $AZURE_TENANT_ID

    # Deploy to Azure Web App
    echo "Deploying to Azure Web App..."
    az webapp deploy --name $AZURE_WEBAPP_NAME --package $AZURE_WEBAPP_PACKAGE_PATH --output none
}

# Call the deploy function
deploy
