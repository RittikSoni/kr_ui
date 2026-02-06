# GitHub Repository Configuration

This directory contains GitHub templates and workflows for the kr_ui repository.

## 📁 Structure

```
.github/
├── ISSUE_TEMPLATE/          # Issue form templates
│   ├── bug_report.yml       # Bug report form
│   ├── feature_request.yml  # Feature request form
│   ├── documentation.yml    # Documentation improvement form
│   └── config.yml           # External links (Discord, docs, security)
│
├── workflows/               # GitHub Actions workflows
│   ├── ci.yml              # PR validation (analyze, format, test)
│   ├── deploy-docs.yml     # Deploy docs to GitHub Pages (tag-based)
│   └── publish-package.yml # Publish kr_ui to pub.dev (manual)
│
└── PULL_REQUEST_TEMPLATE.md # PR template with checklists
```

## 🚀 Quick Start

### Automatic Features (No Setup Needed)
- ✅ Issue templates appear when users create issues
- ✅ PR template appears when users create pull requests
- ✅ CI runs automatically on all PRs

### Features Requiring Configuration

#### 1. GitHub Pages (for docs deployment)
1. Go to **Settings** → **Pages**
2. Set **Source** to **GitHub Actions**

#### 2. Package Publishing
1. Add GitHub secret `PUB_DEV_CREDENTIALS` with your pub.dev credentials
2. Create environment `pub-dev-production` with yourself as reviewer

See the [walkthrough](https://github.com/RittikSoni/kr_ui/blob/main/.gemini/antigravity/brain/2c55c4fd-ecd0-47c5-89da-affed097aecf/walkthrough.md) for detailed setup instructions.

## 📚 Workflows

### CI - Continuous Integration
**Trigger**: Pull requests and pushes to `main`
- Runs analyze, format checks, tests
- Validates kr_ui_docs builds successfully

### Deploy Docs
**Trigger**: Git tags (`v*`) or manual
- Builds and deploys kr_ui_docs to GitHub Pages
- URL: https://rittiksoni.github.io/kr_ui/

### Publish Package
**Trigger**: Manual only
- Two-step process: dry-run → manual approval → publish
- Publishes kr_ui package to pub.dev
- Creates Git tag and GitHub release

## 🛡️ Security Features

- Manual approval required for publishing
- Dry-run validation before publish
- Credentials stored in GitHub Secrets
- Tag-based docs deployment (prevents accidental updates)
- Version validation against pubspec.yaml

