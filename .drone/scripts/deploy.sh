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
    mkdir "${deploy_dir}"
    ! [[ -d "${deploy_dir}" ]]
else
    mkdir "${deploy_dir}"
fi

# Template out needed files.
comb render .drone/config.yml.hbs > sentry/config.yml
comb render .drone/sentry.conf.py.hbs > sentry/sentry.conf.py

# Copy over files to the deploy directory.
find ./ -mindepth 1 -maxdepth 1 -exec cp -rv '{}' "${deploy_dir}/{}" \;
cd "${deploy_dir}"

# Build the project.
./service.sh update

# Bring the project up.
./service.sh start
