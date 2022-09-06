#!/usr/bin/env bash
set -ex
deploy_dir='/var/www/sentry.makedeb.org'

# If the deploy directory exists, stop Sentry and purge the directory.
if [[ -d "${deploy_dir}" ]]; then
    cd "${deploy_dir}"
    if [[ -f 'docker-compose.yml' ]]; then
        docker compose down --remove-orphans
    fi
    cd -
    rm "${deploy_dir}" -rf
    ! [[ -d "${deploy_dir}" ]]
fi

# Copy over files to the deploy directory.
find ./ -mindepth 1 -maxdepth 1 -exec cp -v '{}' "${deploy_dir}/{}" \;
cd "${deploy_dir}"

# Build the project.
./install.sh --skip-user-prompt

# Bring the project up.
./service.sh start