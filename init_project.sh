#!/bin/bash
set -e

PROJECT_TARGET=""
S3_PREFIX=""
JOB_ID=""
NAMESPACE="default"

while [[ $# -gt 0 ]]; do
  case $1 in
    --name) PROJECT_TARGET="$2"; shift 2 ;;
    --s3-prefix) S3_PREFIX="$2"; shift 2 ;;
    --job-id) JOB_ID="$2"; shift 2 ;;
    --namespace) NAMESPACE="$2"; shift 2 ;;
    *) echo "Unknown parameter $1"; exit 1 ;;
  esac
done

if [ -z "$PROJECT_TARGET" ] || [ -z "$S3_PREFIX" ] || [ -z "$JOB_ID" ]; then
    echo "Usage: ./init_project.sh --name MyProject --s3-prefix PEG/MyProject --job-id my-proj --namespace my-ns"
    exit 1
fi

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${TEMPLATE_DIR}/../${PROJECT_TARGET}"

if [ -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR already exists."
    exit 1
fi

echo "🚀 Bootstrapping new Pollen Detection environment at: $TARGET_DIR"
cp -r "$TEMPLATE_DIR" "$TARGET_DIR"

cd "$TARGET_DIR"
rm -f init_project.sh

echo "🔄 Injecting environment templates..."

# Cross-platform compliant sed replacement wrapper
find . -type f -not -path "*/\.git/*" -print0 | while IFS= read -r -d '' file; do
    sed -i "s|{{S3_PREFIX}}|$S3_PREFIX|g" "$file"
    sed -i "s|{{PROJECT_DIR_NAME}}|$PROJECT_TARGET|g" "$file"
    sed -i "s|{{JOB_ID}}|$JOB_ID|g" "$file"
    sed -i "s|{{PROJECT_TITLE_CASE}}|$PROJECT_TARGET|g" "$file"
    sed -i "s|{{NAMESPACE}}|$NAMESPACE|g" "$file"
done

echo ""
echo "✅ Success! Project architecture for $PROJECT_TARGET is initialized."
echo "➡️  Next steps:"
echo "   cd ../$PROJECT_TARGET"
echo "   quarto render docs/"
echo "   ./scripts/deploy_species.sh"
echo "   python3 src/active_learning_ui.py"
