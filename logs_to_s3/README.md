# aws_logs_to_s3

This module compresses individual log files from a directory and uploads each one as a separate `.tar.gz` archive to an AWS S3 bucket.

---

## Function

- Compresses each file inside a given directory individually
- Uploads each resulting `.tar.gz` file to a specified S3 bucket
- Generates a local upload log: `logs/upload.log`
- Compatible with AWS Free Tier (5GB S3 always free)

---

## Requirements

- AWS account (Free Tier eligible)
- IAM user with `s3:PutObject` permission for the target bucket
- AWS CLI installed and configured (`aws configure`)
- Existing S3 bucket (e.g. `mikeniner-logs-2025`)

---

## Usage via Makefile

```bash
make upload
````

This will:

1. Traverse all files inside `../input_logs/`
2. Compress each file into its own `.tar.gz` archive
3. Upload each archive individually to `s3://<bucket>/logs/`

Other targets:

```bash
make log     # View upload logs
make clean   # Remove temporary .tar.gz files from /tmp
make help    # Show available targets
```

---

## Manual execution

```bash
./aws_logs_to_s3.sh ../input_logs mikeniner-logs-2025
```

This uploads all files from `../input_logs` as compressed archives.

---

## Cron automation

Example: run every hour

```cron
0 * * * * /full/path/to/aws_logs_to_s3.sh /full/path/to/input_logs your-bucket-name
```

Make sure to use **absolute paths** in cron jobs.
Optional: redirect stdout/stderr to files or use `logger`.

---

## DevOps Integration & Evolution

This module is built for infrastructure pipelines and can evolve toward:

* **CloudWatch Logs**: trigger alarms or indexing based on S3 uploads
* **AWS Lambda**: automatic post-processing on upload
* **Athena**: query `.log` contents via SQL directly from S3
* **SSM RunCommand**: remote execution from EC2 nodes
* **S3 EventBridge integration**: trigger agentic workflows or n8n flows

---

## DevOps Design Principles

* Shell-first execution (`bash`, no frameworks)
* Minimal IAM access (least privilege via inline policy)
* Timestamped uploads (UTC ISO-safe filenames)
* Clean logs and failure handling
* Stateless, portable, cron-compatible

---

**Built for command-line automation, audit pipelines, and operational observability.**