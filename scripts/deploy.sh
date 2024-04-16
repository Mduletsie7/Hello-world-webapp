#!/bin/bash

# Set permissions
sudo chmod -R 400 $GITHUB_WORKSPACE/*

# Define the deploy function
deploy() {
    # Deploy to Azure Web App
    echo "Deploying to Azure Web App..."
    az webapp deploy --name $AZURE_WEBAPP_NAME --package $AZURE_WEBAPP_PACKAGE_PATH --output none
}

# Call the deploy function
deploy
