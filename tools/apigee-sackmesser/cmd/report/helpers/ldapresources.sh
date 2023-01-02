#!/bin/bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# <http://www.apache.org/licenses/LICENSE-2.0>
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "<h3>LDAP Resources</h3>" >> "$report_html"

mkdir -p "$export_folder/$organization/config/resources/edge/env/$environment/ldapresource"

sackmesser list "organizations/$organization/environments/$environment/ldapresources"| jq -r -c '.[]|.' | while read -r ldapresourcename; do
        sackmesser list "organizations/$organization/environments/$environment/ldapresources/$(urlencode "$ldapresourcename")" > "$export_folder/$organization/config/resources/edge/env/$environment/ldapresource/$(urlencode "$ldapresourcename")".json
    done

if ls "$export_folder/$organization/config/resources/edge/env/$environment/ldapresource"/*.json 1> /dev/null 2>&1; then
    jq -n '[inputs]' "$export_folder/$organization/config/resources/edge/env/$environment/ldapresource"/*.json > "$export_folder/$organization/config/resources/edge/env/$environment/ldapresources".json
fi

echo "<div><table id=\"ldapresource-lint\" data-toggle=\"table\" class=\"table\">" >> "$report_html"
echo "<thead class=\"thead-dark\"><tr>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"id\">Name</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"admin\">Admin</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"connectPool\">Connect Pool</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"connection\">connection</th>" >> "$report_html"
echo "</tr></thead>" >> "$report_html"

echo "<tbody class=\"mdc-data-table__content\">" >> "$report_html"

if [ -f "$export_folder/$organization/config/resources/edge/env/$environment/ldapresources".json ]; then
    jq -c '.[]' "$export_folder/$organization/config/resources/edge/env/$environment/ldapresources".json | while read i; do 
        name=$(echo "$i" | jq -r '.name')
        admin=$(echo "$i" | jq -r '.admin')
        connectPool=$(echo "$i" | jq -r '.connectPool')
        connection=$(echo "$i" | jq -r '.connection')

        echo "<tr class=\"$highlightclass\">"  >> "$report_html"
        echo "<td>$name</td>"  >> "$report_html"
        echo "<td>$admin</td>" >> "$report_html"
        echo "<td>$connectPool</td>" >> "$report_html"
        echo "<td>$connection</td>" >> "$report_html"
        echo "</tr>"  >> "$report_html"
    done
fi

echo "</tbody></table></div>" >> "$report_html"