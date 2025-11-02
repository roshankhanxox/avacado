#!/bin/bash

# Install dependencies
npm install --ignore-optional

# Explicitly install the platform-specific Rollup dependency
npm install @rollup/rollup-linux-x64-gnu@4.9.5

# Build the project
npm run build 

## If the SDK is not present (deploys that only include this subfolder),
## clone and build it so the frontend has the local file dependency available.
if [ ! -d "./packages/ac-eerc-sdk" ]; then
	echo "SDK not found in ./packages, cloning from GitHub..."
	mkdir -p ./packages
	git clone --depth=1 https://github.com/ava-labs/ac-eerc-sdk.git ./packages/ac-eerc-sdk || {
		echo "Failed to clone ac-eerc-sdk; continuing without local SDK clone."
	}
fi

if [ -d "./packages/ac-eerc-sdk" ]; then
	echo "Building ac-eerc-sdk..."
	(cd ./packages/ac-eerc-sdk && npm ci --ignore-optional && npm run build) || {
		echo "SDK build failed — continuing and letting frontend build report errors."
	}
fi