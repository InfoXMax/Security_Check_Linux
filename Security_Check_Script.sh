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

# Check for rootkits using rkhunter
display_separator
echo -e "${GREEN}Checking for rootkits...${NC}"
sudo rkhunter --check --skip-keypress

# Check for malware and viruses using clamav
display_separator
echo -e "${GREEN}Checking for malware and viruses...${NC}"
sudo clamscan -r /

# Check for unauthorized users
display_separator
echo -e "${GREEN}Checking for unauthorized users...${NC}"
unauthorized_users=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd)
if [ -z "$unauthorized_users" ]; then
  echo -e "${GREEN}No unauthorized users found.${NC}"
else
  echo -e "${RED}Unauthorized users:${NC}"
  echo "$unauthorized_users"
fi

# Review system logs
display_separator
echo -e "${GREEN}Reviewing system logs...${NC}"
sudo tail /var/log/syslog

# Audit file permissions
display_separator
echo -e "${GREEN}Auditing file permissions...${NC}"
sudo find / -type f -exec ls -l {} + | awk '$1 ~ /w.$/' >audit1.log
sudo find / -type d -exec ls -ld {} + | awk '$1 ~ /w.$/' >audit2.log

# Enable SELinux or AppArmor
# Note: This depends on the Linux distribution and may require installation
# Uncomment and customize based on your distribution
# display_separator
# echo -e "${GREEN}Enabling SELinux...${NC}"
# sudo apt install selinux-basics selinux-policy-default
# sudo selinux-activate

# Review firewall rules
display_separator
echo -e "${GREEN}Reviewing firewall rules...${NC}"
sudo ufw status

# Review running processes
display_separator
echo -e "${GREEN}Reviewing running processes...${NC}"
sudo ps aux >proc.log

# Implement two-factor authentication (2FA)
# Note: This may depend on the authentication method used (e.g., PAM)
# Uncomment and customize based on your setup
# display_separator
# echo -e "${GREEN}Implementing Two-Factor Authentication (2FA)...${NC}"
# ...

# Review kernel parameters
display_separator
echo -e "${GREEN}Reviewing kernel parameters...${NC}"
sysctl -a > kernel.log

display_separator
echo -e "${RED}Loot files created :  audit1.log  audit2.log  kernel.log  proc.log ${NC}"
# Install and configure Snort (Intrusion Detection System)
# Note: This depends on the Linux distribution and may require installation
# Uncomment and customize based on your distribution
