#!/bin/bash

echo "Security Check Script"

# Function to display section separators
function display_separator {
  echo -e "\n========================================\n"
}

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root." 
  exit 1
fi

# Check for available updates
display_separator
echo "Checking for system updates..."
sudo apt update
updates=$(sudo apt list --upgradable 2>/dev/null | wc -l)

if [ "$updates" -gt 1 ]; then
  echo "There are system updates available. Please consider updating your system."
else
  echo "System is up to date."
fi

# Check for open ports
display_separator
echo "Checking for open ports..."
open_ports=$(sudo ss -tulpn | awk '{print $5}' | cut -d':' -f2 | grep -E "^[0-9]+$" | sort -u)
if [ -z "$open_ports" ]; then
  echo "No open ports found."
else
  echo "Open ports:"
  echo "$open_ports"
fi

# Check for weak passwords
display_separator
echo "Checking for weak passwords..."
weak_passwords=$(sudo grep -E '^.*:[^!*]:' /etc/shadow | cut -d':' -f1)
if [ -z "$weak_passwords" ]; then
  echo "No users with weak passwords found."
else
  echo "Users with weak passwords:"
  echo "$weak_passwords"
fi

# Check for unnecessary services
display_separator
echo "Checking for unnecessary services..."
unnecessary_services=$(sudo systemctl list-unit-files --type=service --state=enabled | grep enabled)
if [ -z "$unnecessary_services" ]; then
  echo "No unnecessary services found."
else
  echo "Enabled unnecessary services:"
  echo "$unnecessary_services"
fi

# Add more checks as needed

# Display final separator
display_separator
echo "Security checks completed."
