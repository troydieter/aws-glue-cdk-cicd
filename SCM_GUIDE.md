### 1. Pipeline Configuration (`pipeline.py`)
- Removed `aws_codecommit` import and dependencies
- Replaced `CodePipelineSource.code_commit()` with `CodePipelineSource.git_hub()`
- Removed CodeCommit repository creation and archive workarounds
- Simplified pipeline dependencies

### 2. Configuration (`default-config.yaml`)
- Replaced `repoName` with `githubRepo` (format: `owner/repo-name`)
- Updated default branch from `master` to `main`
- Added `githubTokenSecret` for GitHub authentication

### 3. Helper Functions (`helper.py`)
- Removed `create_archive()` function (no longer needed for GitHub)
- GitHub handles source code retrieval automatically

## Setup Instructions

### 1. Create GitHub Repository
1. Create a new repository on GitHub or use an existing one
2. Push your code to the repository
3. Note the repository format: `your-username/repository-name`

### 2. Configure GitHub Authentication
1. Create a GitHub Personal Access Token:
   - Go to GitHub Settings > Developer settings > Personal access tokens
   - Generate a new token with `repo` scope
   - Copy the token value

2. Store the token in AWS Secrets Manager:
   ```bash
   aws secretsmanager create-secret \
     --name github-token \
     --description "GitHub Personal Access Token for CodePipeline" \
     --secret-string "your-github-token-here"
   ```

### 3. Update Configuration
Update your `default-config.yaml` file:
```yaml
codepipeline:
  githubRepo: 'your-github-username/your-repo-name'  # Replace with your GitHub repo
  repoBranch: 'main'  # Or your preferred branch
  githubTokenSecret: 'github-token'  # Name of the secret in AWS Secrets Manager
```

### 4. Deploy the Pipeline
```bash
cdk deploy PipelineCDKStack
```

## Supported SCM Providers

CodeStar/CodePipeline supports these modern SCM providers:
- **GitHub** (implemented in this migration)
- **GitHub Enterprise Server**
- **Bitbucket**
- **GitLab** (via webhooks)

## Troubleshooting

### Common Issues:
1. **Authentication Errors**: Ensure your GitHub token has proper permissions and is stored correctly in Secrets Manager
2. **Repository Not Found**: Verify the repository format is `owner/repo-name`
3. **Branch Not Found**: Ensure the specified branch exists in your repository

### Pipeline Permissions:
The pipeline automatically gets the necessary permissions to:
- Access the GitHub repository via the stored token
- Trigger builds on code changes
- Deploy infrastructure changes