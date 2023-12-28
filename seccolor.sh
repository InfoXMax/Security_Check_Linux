#!/bin/bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Security Check Script${NC}"

# Function to display section separators
function display_separator {
  echo -e "\n${GREEN}========================================${NC}\n"
}

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}This script must be run as root.${NC}" 
  exit 1
fi

# Check for available updates
display_separator
echo -e "${GREEN}Checking for system updates...${NC}"
sudo apt update
updates=$(sudo apt list --upgradable 2>/dev/null | wc -l)

if [ "$updates" -gt 1 ]; then
  echo -e "${RED}There are system updates available. Please consider updating your system.${NC}"
else
  echo -e "${GREEN}System is up to date.${NC}"
fi

# Check for open ports
display_separator
echo -e "${GREEN}Checking for open ports...${NC}"
open_ports=$(sudo ss -tulpn | awk '{print $5}' | cut -d':' -f2 | grep -E "^[0-9]+$" | sort -u)
if [ -z "$open_ports" ]; then
  echo -e "${GREEN}No open ports found.${NC}"
else
  echo -e "${RED}Open ports:${NC}"
  echo "$open_ports"
fi

# Check for weak passwords
display_separator
echo -e "${GREEN}Checking for weak passwords...${NC}"
weak_passwords=$(sudo grep -E '^.*:[^!*]:' /etc/shadow | cut -d':' -f1)
if [ -z "$weak_passwords" ]; then
  echo -e "${GREEN}No users with weak passwords found.${NC}"
else
  echo -e "${RED}Users with weak passwords:${NC}"
  echo "$weak_passwords"
fi

# Check for unnecessary services
display_separator
echo -e "${GREEN}Checking for unnecessary services...${NC}"
unnecessary_services=$(sudo systemctl list-unit-files --type=service --state=enabled | grep enabled)
if [ -z "$unnecessary_services" ]; then
  echo -e "${GREEN}No unnecessary services found.${NC}"
else
  echo -e "${RED}Enabled unnecessary services:${NC}"
  echo "$unnecessary_services"
fi

# Add more checks as needed

# Display final separator
display_separator
echo -e "${GREEN}Security checks completed.${NC}"
