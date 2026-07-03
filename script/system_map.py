import os
import re

def generate_repository_scope(start_dir="."):
    print("Initializing Full Scope Systems Structure Mapping Matrix...")
    print("=" * 80)
    
    ignore_dirs = {".git", "out", "cache", "node_modules"}
    
    for root, dirs, files in os.walk(start_dir):
        # I-filter out ang mga heavy build artifact folders para malinis ang tree
        dirs[:] = [d for dirs in [dirs] for d in dirs if d not in ignore_dirs]
        
        # Pag-compute sa level ng indentation
        level = root.replace(start_dir, '').count(os.sep)
        indent = ' ' * 4 * (level)
        sub_indent = ' ' * 4 * (level + 1)
        
        base_folder = os.path.basename(root)
        if base_folder == "" or base_folder == ".":
            print(f"📁 [Root Workspace Node: {os.path.abspath(start_dir)}]")
        else:
            print(f"{indent}├── 📂 {base_folder}/")
            
        for file in sorted(files):
            if file.endswith((".sol", ".toml", ".py", ".env")):
                file_path = os.path.join(root, file)
                print(f"{sub_indent}├── 📄 {file}")
                
                # Kung Solidity file, silipin natin kung may direct internal dependencies
                if file.endswith(".sol"):
                    try:
                        with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                            for line in f:
                                if line.strip().startswith("import"):
                                    # Hulihin ang target ng import link
                                    match = re.search(r'["\'](.*?)["\']', line)
                                    if match:
                                        print(f"{sub_indent}│   🔗 [Depends on -> {match.group(1)}]")
                    except:
                        pass
    print("=" * 80)
    print("Ingestion Completed. System maps generated successfully.")

if __name__ == "__main__":
    generate_repository_scope()
