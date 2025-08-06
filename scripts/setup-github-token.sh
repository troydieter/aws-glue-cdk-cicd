#!/bin/bash

# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# Script to help set up GitHub token in AWS Secrets Manager

set -e

echo "GitHub Token Setup for CDK Pipeline"
echo "===================================="
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install it first."
    exit 1
fi

# Get inputs
read -p "Enter your GitHub Personal Access Token: " -s GITHUB_TOKEN
echo ""
read -p "Enter the secret name (default: github-token): " SECRET_NAME
SECRET_NAME=${SECRET_NAME:-github-token}

read -p "Enter AWS region (default: us-east-1): " AWS_REGION
AWS_REGION=${AWS_REGION:-us-east-1}

echo ""
echo "Creating secret '$SECRET_NAME' in region '$AWS_REGION'..."

# Create the secret
aws secretsmanager create-secret \
    --name "$SECRET_NAME" \
    --description "GitHub Personal Access Token for CodePipeline" \
    --secret-string "$GITHUB_TOKEN" \
    --region "$AWS_REGION"

if [ $? -eq 0 ]; then
    echo "✅ Secret created successfully!"
    echo ""
    echo "Next steps:"
    echo "1. Update your default-config.yaml file:"
    echo "   githubTokenSecret: '$SECRET_NAME'"
    echo "2. Make sure your GitHub repository is set correctly"
    echo "3. Deploy your pipeline: cdk deploy PipelineCDKStack"
else
    echo "❌ Failed to create secret. Please check your AWS credentials and permissions."
    exit 1
fi