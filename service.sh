#!/usr/bin/bash
# Script managed by my fork to work with my server setup.
set -e

cd "$(dirname "${0}")"

case "${1}" in
    start)
        docker-compose up -d
        ;;
    stop)
        docker-compose down
        ;;
    backup-prepare)
        if ! [[ -d backups ]]; then
            mkdir backups/
        fi
        find backups/ -mindepth 1 -maxdepth 1 -exec rm '{}' +

        mapfile -t sentry_volumes < <(docker volume ls --format '{{ .Name }}' | grep '^sentry-')
        for volume in "${sentry_volumes[@]}"; do
            docker run -it -v "${volume}:/container" -v "${PWD}/backups:/backups" ubuntu tar -czf "/backups/${volume}.tar.gz" /container
        done
        ;;
    update)
        docker-compose pull
        ;;
esac

# vim: expandtab sw=4