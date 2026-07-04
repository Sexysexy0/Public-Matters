import os
import subprocess
from datetime import datetime

def run_cmd(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, stderr=subprocess.DEVNULL).decode('utf-8').strip()
    except:
        return ""

def generate_mirror_report():
    report_file = "digital_mirror_evidence.md"
    print("[*] Compiling backend forensic data...")

    # Gathering Data
    git_name = run_cmd("git config user.name")
    git_email = run_cmd("git config user.email")
    total_commits = run_cmd("git rev-list --count HEAD")
    
    # Count smart contract files
    contract_files_count = 0
    for root, dirs, files in os.walk("./contracts"):
        for file in files:
            if file.endswith(".sol"):
                contract_files_count += 1

    report = [
        "# Core Governance Architecture & Identity Evidence Log",
        f"**Generated on:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n",
        "---",
        "## 1. Verified Cryptographic Environment Identity",
        f"- **Operating Environment Entity:** Localhost Root Authority",
        f"- **Local Git Profile Identity Name:** `{git_name}`",
        f"- **Local Git Profile Identity Email:** `{git_email}`",
        f"- **X509 Certificate Bound Email:** `fckrzkill@gmail.com` (From client.crt)",
        f"- **Organizational Scope:** `Public Matters` / `Covenant Deployments` (Malolos, Bulacan)\n",
        "## 2. Codebase Scope & Technical Infrastructure Metrics",
        f"- **Total System Commits in History:** `{total_commits}`",
        f"- **Total Solidity Smart Contracts Detected:** `{contract_files_count}`",
        f"- **Active Submodules Managed:**",
    ]

    # Parse .gitmodules if exists
    if os.path.exists(".gitmodules"):
        with open(".gitmodules", "r") as f:
            for line in f:
                if "path =" in line or "url =" in line:
                    report.append(f"  - `{line.strip()}`")
    
    report.append("\n## 3. Top Historical Contributors and Proxies")
    report.append("| Commits | Author Name & Email |")
    report.append("| ------- | ------------------- |")
    
    authors_log = run_cmd("git shortlog -sn --all")
    for author in authors_log.split("\n"):
        if author.strip():
            parts = author.strip().split("\t")
            count = parts[0]
            name = parts[1] if len(parts) > 1 else "Unknown"
            report.append(f"| {count} | {name} |")

    with open(report_file, "w") as f:
        f.write("\n".join(report))
        
    print(f"[+] Complete! Mirror report compiled and saved to: {report_file}")

if __name__ == "__main__":
    generate_mirror_report()
