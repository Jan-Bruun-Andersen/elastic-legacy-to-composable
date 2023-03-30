# A small JQ script to convert an Elasticsearch template from legacy format to the
# new composable format.
#
# The new template will contain the following extras:
#
# - A meta section with:
#   - The name of the source JSON file (the legacy template)
#   - A note about the date when the template was converted
# - A template priority computed using a base-priority and the
#     (reverse) legacy template order.
#     E.g. with base = 300 and order = 2, the new priority will
#     300 + 1 - 2 = 299.
#
# - If absent in the legacy template:
#   - A version number (yyyymmdd01)
#   - In the mappings.properties section:
#     - @version (keyword)
#     - @timestamp (date)
#
# Written and concieved by Jan Bruun Andersen on a Thursday afternoon in 2023.
# Updated with code to handle inverse priority.

if (.template) then # Do nothing if a template section already exist.
  .
else
  . += {
    "_meta": (
      ._meta | . += {
        "filename": $fname,
        "converted-by": ("legacy2composable on " + (now | strflocaltime("%F %T")))
      }
    ),
    "version":  (try (.version // (now | strflocaltime("%Y%m%d01") | tonumber))),
    "priority": (($base_prio | tonumber) + 1 - try (.order // 1)),
    "template": {
      "aliases":  (try ( .aliases  // {} )),
      "settings": (try ( .settings // {} )),
      "mappings": (try ( .mappings // {} )) | (
        .properties."@version"   = { type: "keyword" } |
        .properties."@timestamp" = { type: "date"    }
      )
    }
  } |
  del(
    .order,
    .aliases,
    .settings,
    .mappings
  )
end
