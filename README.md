# Security Check Script

## Overview

The **Security_Check_Script.sh** is a Bash script designed to enhance the security posture of your Linux system. It automates the detection of common vulnerabilities, ensuring a proactive approach to system security.

## Key Features

- **System Updates Check:** Verifies and prompts for system updates.
- **Open Ports Check:** Identifies open ports on the system.
- **Weak Passwords Check:** Identifies users with potentially weak passwords.
- **Unnecessary Services Check:** Lists enabled unnecessary services.
- **Rootkits Check using rkhunter:** Detects rootkits on the system.
- **Malware and Viruses Check using clamav:** Scans for malware and viruses.
- **Unauthorized Users Check:** Identifies potentially unauthorized users.
- **Review System Logs:** Displays the latest system logs.
- **Audit File Permissions:** Examines and logs file and directory permissions.
- **SELinux or AppArmor (Optional):** Provides instructions for enabling SELinux.
- **Review Firewall Rules:** Displays the status of the Uncomplicated Firewall (ufw).
- **Review Running Processes:** Lists all running processes.
- **Two-Factor Authentication (2FA) (Optional):** Placeholder for 2FA implementation.
- **Review Kernel Parameters:** Logs all kernel parameters.

## Usage

1. Ensure script execution permissions: `chmod +x security_check_script.sh`
2. Run the script as root: `sudo ./security_check_script.sh`
3. Review the output for potential security issues.

## Customization

- Uncomment and customize optional sections based on your system requirements.

## Disclaimer

This script is provided as-is. Review and understand each section before running on a production system. The author is not responsible for any damage or loss.

## License

This script is licensed under the [MIT License](LICENSE).
