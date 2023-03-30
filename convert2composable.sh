#!/bin/bash
#
# Script to convert legacy templates into the new composable template format.
# Actually, they only have one component - themselves, but have the new format
# that allows them to be composed of different template components.

declare -a -r conv_filters=(
  "$(dirname $0)/legacy2composable.jq"
  "$(dirname $0)/jq-compactor.pl"
)
declare -i    n=0
declare -i    base_prio=300

if [[ $# -lt 1 ]]; then
  printf >&2 "Usage: %s JSON-file [...]\n" "$0"
  exit 1
fi

for ((n=0; n < ${#conv_filters[@]}; n++)); do
  filter="${conv_filters[$n]}"
  [[ -f "${filter}" ]] || { printf >&2 "Error: Filter %s was not found!\n" "${filter}"; exit 1; }
done

n=0
for fname in "$@"; do
  if [[ ! -f "${fname}" ]]; then
    printf >&2 "Warning: Not a file, %s\n" "${fname}"
    continue
  fi

  printf >&2 "Converting %-40s => %s\n" "${fname}" "${fname}.new"
  cat "${fname}" |
    jq \
      --arg fname "${fname}" \
      --arg base_prio ${base_prio} \
      --from-file "${conv_filters[0]}" |
    perl -f "${conv_filters[1]}" > "${fname}".new
  n=$((n+1))
done

if [[ $n -eq 0 ]]; then
  printf >&2 "Warning: Zero files processed!\n"
else
  cat >&2 <<-EOD
	Processed $n files.
	If you are satified with the new files, use the command

	  rename ".json.new" ".json" *.json.new

	to replace the old JSON files with the new.
EOD
fi
