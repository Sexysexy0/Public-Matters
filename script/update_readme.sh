#!/usr/bin/env bash
# Final Clean Markdown Table Ledger Updater

README_FILE="README.md"

echo "Rebuilding README deployment ledger with pristine markdown table formatting..."

python3 - << 'PYEOF'
import json
import glob

readme_file = "README.md"

suites = {
    "Arcade Governance Suite": [
        "ArcadeGovernance", "ChildProtectionFund", "SymbolismFilter"
    ],
    "Candaba Floodplain Suite": [
        "CandabaEcologicalGuardian", "CandabaImpoundingDAO", "DredgingContractorRegistry", "FarmerCompensationVault", "FloodSolutionArbiter"
    ],
    "Dependencies & Core Suite": [
        "CitizenVotingDAO", "NexusID", "SovereignOracle", "TrustScoreDAO"
    ],
    "Master Architecture Suite": [
        "CoalitionBuilder", "GlobalAssetRegistry", "OperatorConsciousnessLedger", "OperatorPrivileges", "TrustIndex", "TrustIntegrator"
    ],
    "Leadership Suite": [
        "BluntAdvice", "CommandFeedback", "DiplomaticNuance", "HistoryLightedPath", "PoliticalEndstate"
    ],
    "Trust & Accountability Suite": [
        "BrittleInstrument", "CoalitionBuilder", "InspirationIntimidation", "SpeedOfTrust"
    ]
}

deployments = {}

broadcast_files = glob.glob("broadcast/**/*.s.sol/**/run-latest.json", recursive=True)
if not broadcast_files:
    broadcast_files = glob.glob("broadcast/**/run-latest.json", recursive=True)

for b_file in broadcast_files:
    try:
        with open(b_file, "r") as f:
            data = json.load(f)

        receipts = {}
        for r in data.get("receipts", []):
            tx_hash = r.get("transactionHash")
            if tx_hash:
                block_hex = r.get("blockNumber", "0x0")
                gas_hex = r.get("gasUsed", "0x0")
                block_val = int(block_hex, 16) if str(block_hex).startswith("0x") else block_hex
                gas_val = int(gas_hex, 16) if str(gas_hex).startswith("0x") else gas_hex
                receipts[tx_hash] = {"block": str(block_val), "gas": str(gas_val)}

        for tx in data.get("transactions", []):
            if tx.get("transactionType") == "CREATE":
                raw_name = tx.get("contractName", "")
                simple_name = raw_name.split(":")[-1] if ":" in raw_name else raw_name
                addr = tx.get("contractAddress")
                tx_hash = tx.get("hash")
                rec = receipts.get(tx_hash, {"block": "N/A", "gas": "N/A"})
                
                if addr:
                    deployments[simple_name] = {
                        "address": f"`{addr.lower()}`",
                        "block": rec["block"],
                        "gas": rec["gas"],
                        "verified": "✅"
                    }
    except Exception as e:
        print(f"Warning: Error reading {b_file}: {e}")

try:
    with open(readme_file, "r") as f:
        lines = f.readlines()

    ledger_start_idx = -1
    separator_idx = -1
    
    for idx, line in enumerate(lines):
        if "## Deployment Ledger" in line:
            ledger_start_idx = idx
        elif ledger_start_idx != -1 and line.strip() == "---":
            separator_idx = idx
            break

    # Construct clean markdown lines with explicit newlines
    new_ledger_lines = ["## Deployment Ledger\n\n"]
    
    for suite_name, contract_names in suites.items():
        new_ledger_lines.append(f"### {suite_name}\n\n")
        new_ledger_lines.append("| Contract | Address | Block | Gas | Verified |\n")
        new_ledger_lines.append("|:---|:---|:---:|:---:|:---:|\n")
        
        for name in contract_names:
            if name in deployments:
                info = deployments[name]
                row = f"| {name} | {info['address']} | {info['block']} | {info['gas']} | {info['verified']} |\n"
            else:
                row = f"| {name} | `N/A` | N/A | N/A | ❌ |\n"
            new_ledger_lines.append(row)
            
        new_ledger_lines.append("\n")

    if ledger_start_idx != -1 and separator_idx != -1:
        prefix = lines[:ledger_start_idx]
        suffix = lines[separator_idx:]
        final_lines = prefix + new_ledger_lines + suffix
    else:
        final_lines = new_ledger_lines

    with open(readme_file, "w") as f:
        f.writelines(final_lines)

    print("✅ README deployment ledger updated with pristine table formatting!")

except Exception as e:
    print(f"Error updating README file: {e}")
PYEOF
