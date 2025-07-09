#!/bin/bash
# Compresses each file inside a directory into its own .tar.gz archive
# and uploads it individually to a specified AWS S3 bucket.

# Exit on error, unset variable usage, or failed pipe segment
set -euo pipefail

# Ensure the logs directory exists (used to store local upload logs)
mkdir -p logs

# Get input arguments: directory path and target S3 bucket
INPUT_DIR="${1:-}"
S3_BUCKET="${2:-}"

# Validate required arguments
if [[ -z "$INPUT_DIR" || -z "$S3_BUCKET" ]]; then
  echo "Usage: $0 /path/to/log_dir s3-bucket-name" >&2
  exit 1
fi

# Validate that the input path is a directory
if [[ ! -d "$INPUT_DIR" ]]; then
  echo "[ERROR] Directory not found: $INPUT_DIR" >&2
  exit 1
fi

# Enable nullglob to avoid literal unmatched globs
shopt -s nullglob

# Collect all files in the input directory
FILES=("$INPUT_DIR"/*)

# Abort if no files found
if [[ "${#FILES[@]}" -eq 0 ]]; then
  echo "[ERROR] No files found in directory: $INPUT_DIR" >&2
  exit 1
fi

# Disable nullglob after usage
shopt -u nullglob

# Get current UTC timestamp for consistent naming
TIMESTAMP=$(date -u +"%Y-%m-%dT%H-%M-%SZ")

# Iterate over each file in the input directory
for FILE in "${FILES[@]}"; do
  if [[ -f "$FILE" ]]; then
    # Extract filename without path
    BASENAME=$(basename "$FILE")

    # Construct archive filename with timestamp
    ARCHIVE_NAME="${BASENAME%.*}_$TIMESTAMP.tar.gz"
    ARCHIVE_PATH="/tmp/$ARCHIVE_NAME"

    # Compress the file into a tar.gz archive
    echo "[INFO] Compressing $FILE → $ARCHIVE_PATH"
    tar -czf "$ARCHIVE_PATH" -C "$(dirname "$FILE")" "$BASENAME"

    # Construct S3 key path under 'logs/'
    S3_KEY="logs/$ARCHIVE_NAME"

    # Upload the archive to the specified S3 bucket
    echo "[INFO] Uploading $ARCHIVE_NAME to s3://$S3_BUCKET/$S3_KEY"
    aws s3 cp "$ARCHIVE_PATH" "s3://$S3_BUCKET/$S3_KEY" --only-show-errors

    # Log success locally
    echo "[OK] $BASENAME uploaded at $(date -u) as $ARCHIVE_NAME" | tee -a logs/upload.log

    # Clean up temporary archive
    rm -f "$ARCHIVE_PATH"
  fi
done
