# CI Tools

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/Fondeadora/ci-tools)
![licensed|ethically](https://img.shields.io/badge/licensed-ethically-%234baaaa "Ethically licensed badge")

This repository contains several scripts that automate common tasks executed in within CI

## How to use

### Lint Python project

Add the following to your workflow:

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/cache@v2
        id: cache-dependencies
        with:
          path: .venv
          key: ${{ runner.os }}-pip-${{ hashFiles('**/Pipfile.lock') }}
      - name: lint
        uses: Fondeadora/ci-tools/lint
        with:
          access_token: ${{ secrets.ACCESS_TOKEN }}
          cache_hit: ${{ steps.cache-dependencies.outputs.cache-hit }}
```

### Test Python project

Add the following to your workflow:

```yaml
name: A service to test

on: pull_request

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout the repo
        uses: actions/checkout@v2

      - name: Check if we hace cached dependencies
        uses: actions/cache@v2
        id: cache-dependencies
        with:
          path: .venv
          key: ${{ runner.os }}-pip-${{ hashFiles('**/Pipfile.lock') }}

      - name: Test the service
        uses: Fondeadora/ci-tools/test@master
        with:
          access_token: ${{ secrets.ACCESS_TOKEN }}
          cache_hit: ${{ steps.cache-dependencies.outputs.cache-hit }}
          # env_file: .env.example (Optional)
          # test_command: pipenv run make test (Optional)
```

### Serverless deploy

This will add an action with an event trigger. Add the following to your workflow:

```yaml
name: Deploy Service

on:
  workflow_dispatch:
    inputs:
      stage:
        description: "The stage to deploy the service"
        required: true
        default: "dev"

env:
  STAGE: ${{ github.event.inputs.stage }}

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/cache@v2
        id: cache-dependencies
        with:
          path: node_modules
          key: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
          restore-keys: |
            ${{ runner.os }}-npm-
      - name: deploy
        uses: Fondeadora/ci-tools/serverless-deploy@v1.1.1
        with:
          access_token: ${{ secrets.ACCESS_TOKEN }}
          stage: ${{ env.STAGE }}
          cache_hit: ${{ steps.cache-dependencies.outputs.cache-hit == 'true' }}
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-east-1
```

### Git consistency

- [Script](bash/git-consistency.sh)

Add to your github workflow the following snippet:

```yaml
name: Git consistency

on: pull_request

jobs:
  consistency:
    runs-on: ubuntu-latest
    steps:
      - name: Get current project to validate
        uses: actions/checkout@v2
        with:
          path: project

      - name: Get ci tools script
        uses: actions/checkout@v2
        with:
          repository: Fondeadora/ci-tools
          ref: master
          token: ${{ secrets.CI_TOOLS_TOKEN }}
          path: ci-tools

      - name: Setup repository references
        run: |
          cd project
          git fetch origin
          git checkout ${{ github.base_ref }}
          git checkout ${{ github.head_ref }}

      - name: Run git consistency tools
        env:
          BASE_BRANCH: ${{ github.base_ref }}
          CURRENT_BRANCH: ${{ github.head_ref }}
          REPO_TYPE: "mobile|service" # set to the correct value
        run: |
          cd project
          ../ci-tools/validation/git-consistency.sh
```
