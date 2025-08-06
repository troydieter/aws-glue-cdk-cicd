# Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

# PowerShell script to help set up GitHub token in AWS Secrets Manager

Write-Host "GitHub Token Setup for CDK Pipeline" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

# Check if AWS CLI is installed
try {
    aws --version | Out-Null
} catch {
    Write-Host "Error: AWS CLI is not installed. Please install it first." -ForegroundColor Red
    exit 1
}

# Get inputs
$GITHUB_TOKEN = Read-Host "Enter your GitHub Personal Access Token" -AsSecureString
$GITHUB_TOKEN_PLAIN = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($GITHUB_TOKEN))

$SECRET_NAME = Read-Host "Enter the secret name (default: github-token)"
if ([string]::IsNullOrEmpty($SECRET_NAME)) {
    $SECRET_NAME = "github-token"
}

$AWS_REGION = Read-Host "Enter AWS region (default: us-east-1)"
if ([string]::IsNullOrEmpty($AWS_REGION)) {
    $AWS_REGION = "us-east-1"
}

Write-Host ""
Write-Host "Creating secret '$SECRET_NAME' in region '$AWS_REGION'..." -ForegroundColor Yellow

# Create the secret
try {
    aws secretsmanager create-secret --name $SECRET_NAME --description "GitHub Personal Access Token for CodePipeline" --secret-string $GITHUB_TOKEN_PLAIN --region $AWS_REGION
    
    Write-Host "✅ Secret created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Update your default-config.yaml file:" -ForegroundColor White
    Write-Host "   githubTokenSecret: '$SECRET_NAME'" -ForegroundColor Gray
    Write-Host "2. Make sure your GitHub repository is set correctly" -ForegroundColor White
    Write-Host "3. Deploy your pipeline: cdk deploy PipelineCDKStack" -ForegroundColor White
} catch {
    Write-Host "❌ Failed to create secret. Please check your AWS credentials and permissions." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
} finally {
    # Clear the plain text token from memory
    $GITHUB_TOKEN_PLAIN = $null
}