# aws_logs_to_s3

This module compresses every file inside a target directory into **individual `.tar.gz` archives**, then uploads each one separately to an AWS S3 bucket.  
It is designed for secure, timestamped, automated log offloading — using only the AWS Free Tier and CLI-based operations.

---

## Function

- Accepts a directory containing log files
- Compresses **each file** into a separate `.tar.gz` (not a single archive)
- Uploads each archive independently to a `logs/` folder inside the S3 bucket
- Records a detailed local log at `logs/upload.log`

---

## Requirements

- AWS account (Free Tier eligible)
- S3 bucket created (e.g., `mikeniner-logs-2025`)
- IAM user with `s3:PutObject` permission scoped to:
```

arn\:aws\:s3:::your-bucket-name/logs/\*

````
- AWS CLI installed and configured (`aws configure`)

---

## Usage via Makefile

```bash
make upload
````

This will:

1. Locate all files inside `../input_logs/`
2. Compress each one individually into a `.tar.gz` file
3. Upload each archive to `s3://<bucket>/logs/`

Additional targets:

```bash
make log     # Show upload history from logs/upload.log
make clean   # Remove temporary tar.gz archives from /tmp
make help    # Display available Makefile commands
```

---

## Manual execution

```bash
./aws_logs_to_s3.sh ../input_logs mikeniner-logs-2025
```

---

## Cron Automation

To run the script every hour:

```cron
0 * * * * /full/path/to/aws_logs_to_s3.sh /full/path/to/input_logs your-bucket-name
```

* Always use **absolute paths**
* Redirect output to files or use `logger` if required

---

## DevOps Integration & Evolution

This module is designed for audit pipelines and remote log offloading. It can evolve into:

* **CloudWatch integration** for alerting and indexing
* **Lambda triggers** on upload for validation or enrichment
* **Athena queries** for on-demand log inspection via SQL
* **SSM RunCommand** to orchestrate remote execution from EC2
* **EventBridge rules** for multi-agent or n8n-driven workflows

---

## Operational Design Principles

* No frameworks — built entirely with `bash`, `awscli`, and core tools
* Input/output is always explicit and observable
* No side effects — files are temporary and cleaned after upload
* IAM policies are minimal and purpose-specific
* Compatible with cron, CI/CD, and agentic pipelines