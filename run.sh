#!/bin/bash

# Load environment variables from .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

# Run Flutter with dart-define for each env var
flutter run \
  --dart-define=REVENUECAT_ANDROID_KEY=${REVENUECAT_ANDROID_KEY:-goog_placeholder} \
  --dart-define=REVENUECAT_IOS_KEY=${REVENUECAT_IOS_KEY:-appl_placeholder} \
  "$@"
