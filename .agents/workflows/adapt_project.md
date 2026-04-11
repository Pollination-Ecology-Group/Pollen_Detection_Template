---
description: Adapt this Pollen Detection Template for a new specific project
---

# Adapting the Pollen Detection Template

This workflow initializes the general Pollen Detection Template for a specific new project. Follow these instructions step-by-step:

## Context Gathering
1. Ask the USER for the following details before proceeding:
   - **New Project Name** (e.g., "Texas Pollination Study")
   - **Target Pollen Species List** (the list of classes the new model will train to detect)
   - **S3 Bucket Details** (Where the CZI files or raw images are stored)
   - **GitHub Organization/Repo Name** (Where the updated code will be pushed)

## 1. Project Configuration Update
Update all relevant configurations with the new project metadata:
- **Quarto Website:** Update `documentations/_quarto.yml` replacing title, description, and repository URL with the new project's metadata. 
- **Kubernetes / Docker Files:** Search through the `k8s/` and `docker/` directories. Identify any environment variables (e.g., namespace, S3 paths, job names) tying the template to "colorado_pollen" and replace them with the new project's identifiers.
- **Data Manifests:** In `src/` or `scripts/`, identify the species mapping dictionary/CSV (manifest) and update it to strictly use the new target pollen species list provided by the user.

## 2. Directory and File Maintenance
- Scan the source code (`src/`, `scripts/`) to adjust any hard-coded references to old classes or old paths.
- Modify the `init_project.sh` script to pull data from the new S3 bucket if applicable.

## 3. Deployment Preparation
- Render the documentation with `quarto render documentations/` to rebuild the `docs/` folder with the updated branding.
- Do not execute Kubernetes apply commands without explicit USER permission. Present them with the revised configuration and instructions.

## 4. Final Review
- Provide the user with a summary of the adapted configurations, the generated classes for the model, and wait for their final confirmation before wrapping up.
