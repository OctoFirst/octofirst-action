# Octo first action

Activate code analysis and code quality tools for your project.

## Installation

Create a new file in your repository called `.github/workflows/octofirst.yml` and add the following code:

```yaml
name: OctoFirst

on:
  push:
    branches:
      - {{ repository.mainBranch }}
  schedule:
    - cron: '0 0 * * 0'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
        - name: OctoFirst
          uses: OctoFirst/octofirst-action@v1
          with:
            OCTOFIRST_SECRET: {{ secrets.OCTOFIRST_SECRET }}
```

## Configuration

You need to add a secret called `OCTOFIRST_SECRET` to your repository. You can create a new secret by going to your repository settings and clicking on the `Secrets` tab.