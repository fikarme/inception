#!/bin/bash

# Script to add 42.fr domains to /etc/hosts for local development

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "This script needs sudo privileges to edit /etc/hosts"
    echo "Run with: sudo $0"
    exit 1
fi

# Backup hosts file
cp /etc/hosts /etc/hosts.backup.$(date +%Y%m%d_%H%M%S)
echo "Created backup of /etc/hosts"

# Domains to add
DOMAINS=(
    "test.42.fr"
    "ibkocak.42.fr"
    "hatice.42.fr"
    "ctasar.42.fr"
    "akdemir.42.fr"
    "relvan.42.fr"
)

# Add header comment if not exists
if ! grep -q "# 42 School Inception Project" /etc/hosts; then
    echo "" >> /etc/hosts
    echo "# 42 School Inception Project" >> /etc/hosts
fi

# Add each domain
for domain in "${DOMAINS[@]}"; do
    # Check if domain already exists
    if grep -q "$domain" /etc/hosts; then
        echo "✓ $domain already exists in hosts file"
    else
        echo "127.0.0.1    $domain" >> /etc/hosts
        echo "✓ Added $domain to hosts file"
    fi
done

echo ""
echo "All domains added! You can now access:"
for domain in "${DOMAINS[@]}"; do
    echo "  https://$domain"
done

echo ""
echo "To remove these entries later, restore from backup:"
echo "  sudo cp /etc/hosts.backup.* /etc/hosts"
