# AWS DevOps POCs

This repository contains a collection of modular, production-ready Proofs of Concept (POCs) built as part of a hands-on technical training program under the direct supervision of [Mike Niner](https://github.com/mikeninerbravog).

Each POC demonstrates practical use of AWS Free Tier resources combined with DevOps principles such as automation, security, monitoring, and infrastructure modularity.

---

## Objectives

- Train DevOps engineers and infrastructure specialists on real-world AWS automation
- Enforce discipline around shell-first design and minimal IAM policies
- Provide reusable building blocks for scalable cloud operations

---

## Repository Structure

```text
aws-devops-pocs/
├── input_logs/              # Shared directory with raw logs for testing
├── logs_to_s3/              # First POC: compress and upload logs to S3
│   ├── aws_logs_to_s3.sh
│   ├── Makefile
│   ├── logs/
│   │   └── upload.log
│   └── README.md
└── README.md                # This file
````

---

## Current POC Modules

| Module       | Description                                                | Status |
| ------------ | ---------------------------------------------------------- | ------ |
| `logs_to_s3` | Compresses logs and uploads them individually to S3        | ✅      |
| `...`        | *(Additional POCs will be added here as training evolves)* | 🔧     |

---

## Operational Philosophy

All modules follow strict operational constraints:

* Executable from pure shell environments (Debian 12+)
* No frameworks, no magic — only CLI and scripts
* Input/output must be explicit (stdin/stdout or file-based)
* IAM permissions must be minimal and specific
* Logs must be clear, auditable, and timestamped
* Each module must be testable in isolation

---

## License

All material is © 2025 Mike Niner Bravog.
For commercial use or training customization, please contact directly.

---
# aws-devops-pocs
