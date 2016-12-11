#!/bin/bash

set -euo pipefail

NAMES=$(shuf -e Jess Harriet Sam Keith Tim)

if [[ ! -z "${BUILDKITE:-}" ]]; then
  buildkite-agent meta-data set names "$NAMES"
fi

cat <<PIPELINE
steps:
  - command: "readme.bash"
    label: "🎄 Readme"
    artifact_paths: "*.gif"
PIPELINE

for name in $NAMES; do
  cat <<PIPELINE
  - block: "📝 $name"
    prompt: "Dear Secret Santa…"
    fields:
      - text: "Pressie Hint"
        hint: "My pressie hint is…"
        key: "hint-$name"
      - text: "Delivery Address"
        hint: "Please send my xmas present to…"
        key: "address-$name"
PIPELINE
done

cat <<PIPELINE
  - command: "notify-santas-magical-unicorns.bash"
    label: "💌 :santa::skin-tone-3::unicorn_face:"
PIPELINE
