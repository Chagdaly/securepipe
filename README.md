# SecurePipe — Automated Cloud Security Pipeline

A portfolio-grade DevSecOps project that demonstrates shift-left security by automatically detecting AWS infrastructure misconfigurations before they reach production.

## What It Does

Every push to this repository triggers an automated security pipeline that:

- Scans Terraform IaC for misconfigurations using Checkov and tfsec
- Detects secrets accidentally committed to code using Gitleaks
- Generates findings mapped to CIS AWS Benchmarks and OWASP Top 10

## Live Demo — Chaos Mode

A chaos inject script simulates a developer accidentally introducing vulnerabilities, then the pipeline catches them automatically:

## Vulnerabilities Detected

| Finding | Tool | Severity | Benchmark |
|---------|------|----------|-----------|
| SSH port 22 open to 0.0.0.0/0 | tfsec + Checkov | CRITICAL | CIS AWS 5.2 |
| IAM role with AdministratorAccess | Checkov | HIGH | CIS AWS 1.16 |
| S3 public access not blocked | tfsec + Checkov | HIGH | CIS AWS 2.1 |
| No S3 bucket encryption | tfsec | HIGH | CIS AWS 2.2 |
| No S3 access logging | Checkov | MEDIUM | CIS AWS 2.6 |

## Pipeline Architecture

- git push triggers GitHub Actions
- Checkov scans IaC and maps findings to CIS benchmarks
- tfsec scans IaC and classifies CRITICAL/HIGH/MEDIUM/LOW severity
- Gitleaks scans all commits for credential leaks

## Tech Stack

- IaC: Terraform
- Cloud: AWS S3, IAM, EC2 Security Groups
- Scanners: Checkov 3.x, tfsec v1.28, Gitleaks
- Pipeline: GitHub Actions
- Scripting: Python 3

## Key Results

- 16 Checkov findings across 3 resource types
- 12 tfsec findings including 2 CRITICAL severity
- Full inject to detect to restore demo cycle under 60 seconds
- Zero AWS costs during scanning

## What I Would Add Next

- Trivy container image scanning for CVE detection
- OPA for custom policy-as-code rules
- AWS Security Hub integration for centralized findings
- Semgrep SAST scanning for application code