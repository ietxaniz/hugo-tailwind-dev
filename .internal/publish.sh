#!/bin/sh

set -e

if [ -z "$1" ]; then
  echo "❌ Error: You must provide a version tag (e.g., ./publish.sh 1.0)"
  exit 1
fi

VERSION="$1"
IMAGE_NAME=inigoetxaniz/hugo-tailwind-dev

echo "🔨 Building image..."
docker build -t $IMAGE_NAME:$VERSION .

echo "🏷️ Tagging as latest..."
docker tag $IMAGE_NAME:$VERSION $IMAGE_NAME:latest

echo "📤 Pushing version $VERSION..."
docker push $IMAGE_NAME:$VERSION

echo "📤 Pushing latest..."
docker push $IMAGE_NAME:latest

echo "✅ Pushed $IMAGE_NAME with tags: $VERSION and latest"
