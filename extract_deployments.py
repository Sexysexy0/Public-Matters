import os
import json
from datetime import datetime

def compile_deployment_report():
    deployments_dir = os.path.expanduser("~/Public-Matters/ignition/deployments")
    report_file = os.path.expanduser("~/Public-Matters/deployed_assets_report.md")
    
    print(f"[*] Scanning for deployment artifacts in: {deployments_dir}")
    
    if not os.path.exists(deployments_dir):
        print("[-] No deployment records folder found yet. Run your ignition deployment command first.")
        return

    report_content = [
        "# Master Governance Asset Ledger",
        f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n",
        "--- \n"
    ]

    for network_folder in os.listdir(deployments_dir):
        network_path = os.path.join(deployments_dir, network_folder)
        if os.path.isdir(network_path):
            record_file = os.path.join(network_path, "deployed_addresses.json")
            
            if os.path.exists(record_file):
                report_content.append(f"## Network / Chain ID: {network_folder}\n")
                report_content.append("| Contract Name | Deployed On-Chain Address |")
                report_content.append("| ------------- | ------------------------- |")
                
                try:
                    with open(record_file, 'r') as f:
                        data = json.load(f)
                        for contract_name, address in data.items():
                            report_content.append(f"| {contract_name} | `{address}` |")
                except Exception as e:
                    report_content.append(f"Error reading records: {str(e)}")
                
                report_content.append("\n")

    with open(report_file, 'w') as f:
        f.write("\n".join(report_content))
    
    print(f"[+] Success! Your digital mirror report has been saved to: {report_file}")

if __name__ == "__main__":
    compile_deployment_report()
