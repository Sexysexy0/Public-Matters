import os
import re

def audit_contract_authorities(contract_dir):
    print("Executing System Role Authority & Modifier Forensic Audit...")
    print("-" * 75)
    print(f"{'Contract File':<35} | {'Protected Function':<35}")
    print("-" * 75)

    if not os.path.exists(contract_dir):
        print(f"Error: Directory path '{contract_dir}' does not exist.")
        return

    # Scan the local contract workspace
    for root, dirs, files in os.walk(contract_dir):
        for file in files:
            if file.endswith(".sol"):
                file_path = os.path.join(root, file)
                with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                    content = f.read()
                    
                    # Regex to find functions that use permission check modifiers
                    # Captures patterns like: function name(...) public onlyContractor
                    matches = re.findall(r"function\s+(\w+)\(.*?\)[^{]*?(\b\w+Check\b|\bonly\w+\b)", content, re.DOTALL)
                    
                    for func_name, modifier in matches:
                        print(f"{file:<35} | {func_name} ({modifier})")

if __name__ == "__main__":
    # Point directly to your active repository contracts directory
    audit_contract_authorities("contracts")
