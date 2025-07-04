#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This ain't it, chief. Run with sudo."
    exit 1
fi

DOMAINS=(
    "test.42.fr"
    "ibkocak.42.fr"
    "hatice.42.fr"
    "ctasar.42.fr"
    "akdemir.42.fr"
    "relvan.42.fr"
)

for domain in "${DOMAINS[@]}"; do
    if ! grep -q "127.0.0.1[[:space:]]\+$domain" /etc/hosts; then
        echo "127.0.0.1    $domain" >> /etc/hosts
    fi
done

echo "/etc/hosts updated"
