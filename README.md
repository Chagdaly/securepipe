# securepipe



\# SecurePipe — Automated Cloud Security Pipeline



A portfolio-grade DevSecOps project that demonstrates shift-left security 

by automatically detecting AWS infrastructure misconfigurations before 

they reach production.



\## What It Does

Every push to this repository triggers an automated security pipeline that:

\- Scans Terraform (IaC) for misconfigurations using \*\*Checkov\*\* and \*\*tfsec\*\*

\- Detects secrets accidentally committed to code using \*\*Gitleaks\*\*

\- Generates findings mapped to CIS AWS Benchmarks and OWASP Top 10



\## Live Demo — Chaos Mode

A chaos inject script simulates a developer accidentally introducing 

vulnerabilities, then the pipeline catches them automatically:

```bash

python chaos\_inject.py inject   # injects vulnerabilities + triggers pipeline

python chaos\_inject.py restore  # restores clean state

```



\## Vulnerabilities Detected

| Finding | Tool | Severity | Benchmark |

|--------|------|----------|-----------|

| SSH port 22 open to 0.0.0.0/0 | tfsec + Checkov | CRITICAL | CIS AWS 5.2 |

| IAM role with AdministratorAccess | Checkov | HIGH | CIS AWS 1.16 |

| S3 bucket public access not blocked | tfsec + Checkov | HIGH | CIS AWS 2.1 |

| No S3 bucket encryption | tfsec | HIGH | CIS AWS 2.2 |

| No S3 access logging | Checkov | MEDIUM | CIS AWS 2.6 |



\## Pipeline Architecture

```

git push → GitHub Actions

&#x20;             ├── Checkov (IaC scan)     → CIS benchmark findings

&#x20;             ├── tfsec (IaC scan)       → CRITICAL/HIGH/MEDIUM/LOW findings  

&#x20;             └── Gitleaks (secrets)     → credential leak detection

```



\## Tech Stack

\- \*\*IaC\*\*: Terraform (HCL)

\- \*\*Cloud\*\*: AWS (S3, IAM, EC2 Security Groups)

\- \*\*Scanners\*\*: Checkov 3.x, tfsec v1.28, Gitleaks

\- \*\*Pipeline\*\*: GitHub Actions

\- \*\*Scripting\*\*: Python 3



\## Key Results

\- 16 Checkov findings detected across 3 resource types

\- 12 tfsec findings including 2 CRITICAL severity

\- Full inject → detect → restore demo cycle in under 60 seconds

\- Zero AWS costs during scanning (all static analysis)



\## What I'd Add Next

\- Trivy container image scanning for CVE detection

\- OPA (Open Policy Agent) for custom policy-as-code rules

\- AWS Security Hub integration for centralized findings dashboard

\- Semgrep SAST scanning for Python application code

