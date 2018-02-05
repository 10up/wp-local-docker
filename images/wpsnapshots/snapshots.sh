#!/bin/bash
set -e

maybe_run_wpsnapshots() {
    if [ -e /wpsnapshots/.wpsnapshots.json ]; then

        if [ ! -e /root/.wpsnapshots.json ]; then
            ln -s /wpsnapshots/.wpsnapshots.json /root/.wpsnapshots.json
        fi

        wpsnapshots "$@"
     else
        echo 'WP Snapshots is not configured, you must run docker-compose wpsnapshots configure <repository>';
        exit 1;
    fi
}

case "$1" in
    configure)
        wpsnapshots "$@"
        mv /root/.wpsnapshots.json /wpsnapshots/.wpsnapshots.json
        ;;
    *)
        maybe_run_wpsnapshots "$@"
        ;;
esac
