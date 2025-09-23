#!/usr/bin/env bash

tag_to_clone="v7.9.0"

script_dir=$(realpath "$0" | xargs dirname)
tmp_dir=$(mktemp -d)

echo "Clone OpenAPI Generator ${tag_to_clone} to ${tmp_dir}"
git clone https://github.com/OpenAPITools/openapi-generator.git "${tmp_dir}" || exit 1
cd "${tmp_dir}" || exit 1
git checkout tags/${tag_to_clone}


echo "Copy PHP templates"
mkdir -p "${script_dir}/templates/php"
cp -r "${tmp_dir}/modules/openapi-generator/src/main/resources/php/" "${script_dir}/templates"
