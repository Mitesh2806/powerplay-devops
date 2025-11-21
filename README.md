# DevOps Intern Assignment - Powerplay

## 📋 Objective
This project demonstrates the setup of a cloud-based environment on AWS, automating system monitoring tasks, and integrating local logs with AWS CloudWatch. The setup uses an Ubuntu EC2 instance, Nginx web server, Bash scripting, and AWS CLI.

## 🛠️ Prerequisites
* **AWS Account:** Free Tier eligible
* **OS:** Ubuntu Server 22.04 LTS (t3.micro)
* **Tools:** AWS CLI v2, Nginx, SSH client(MobaXterm for windows)

---

## 1. Environment Setup
**Objective:** Launch and secure the server.

* **Instance Type:** t3.micro
* **Hostname:** `mitesh-devops`
* **User Created:** `devops_intern`

**Key Configuration:**
* **Sudo Privileges:** Configured password-less access for `devops_intern` by editing `/etc/sudoers`:
    ```text
    devops_intern ALL=(ALL) NOPASSWD: ALL
    ```
* **Hostname Resolution:** Updated `/etc/hosts` to map `127.0.0.1` to `mitesh-devops` to prevent resolution warnings.

---

## 2. Simple Web Service
**Objective:** Host a static HTML page displaying system metadata.

* **Web Server:** Nginx
* **File Path:** `/var/www/html/index.html`
* **URL:** `http://16.170.243.198/index.html`

**Configuration Steps:**
1.  Installed Nginx: `sudo apt install nginx -y`
2.  Created `index.html` containing:
    * **DevOps Intern Name:** Mitesh
    * **Instance ID:** Retrieved via AWS Metadata 
    * **Uptime:** Retrieved via `uptime -p`

---

## 3. Monitoring Script & Automation
**Objective:** Automate system health checks (CPU, Memory, Disk).

* **Script Location:** `/usr/local/bin/system_report.sh`
* **Log Location:** `/var/log/system_report.log`

**The Script:**
A Bash script was created to capture:
1.  Date & Time
2.  System Uptime
3.  CPU Usage (%)
4.  Memory Usage (%)
5.  Disk Usage (%)
6.  Top 3 Processes by CPU

**Automation (Cron Job):**
The script is scheduled to run every 5 minutes.
* **Cron Schedule:** `*/5 * * * *`
* **Command:**
    ```bash
    */5 * * * * /usr/local/bin/system_report.sh >> /var/log/system_report.log 2>&1
    ```

---

## 4. AWS CloudWatch Integration
**Objective:** Centralize logs by pushing them to the cloud.

* **Log Group Name:** `/devops/intern-metrics`
* **Log Stream Name:** `my-server-logs`

**Implementation:**
Since `put-log-events` requires a sequence token and specific JSON format, the following command block is used to push the latest logs:

```bash
# 1. Generate Timestamp (Milliseconds)
TIMESTAMP=$(date +%s000)

# 2. Capture recent logs
MESSAGE=$(tail -n 10 /var/log/system_report.log)

# 3. Push to CloudWatch
aws logs put-log-events \
    --log-group-name /devops/intern-metrics \
    --log-stream-name my-server-logs \
    --log-events timestamp=$TIMESTAMP,message="$MESSAGE"
    
