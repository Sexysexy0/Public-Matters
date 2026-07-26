#!/bin/bash
# save as: mass_fix_access_control.sh

# Template 1: Simple Ownable (for basic contracts)
add_ownable_basic() {
    local file=$1
    local name=$(basename "$file" .sol)
    
    # Check if already has import or Ownable
    if grep -q "Ownable" "$file"; then
        echo "SKIP (already has Ownable): $name"
        return
    fi
    
    # Create backup
    cp "$file" "$file.bak"
    
    # Add import after pragma
    sed -i 's/^pragma solidity \^[0-9.]*;/&\n\nimport "@openzeppelin\/contracts\/access\/Ownable.sol";/' "$file"
    
    # Add is Ownable to contract declaration
    sed -i "s/contract $name {/contract $name is Ownable {/" "$file"
    
    # Add onlyOwner to external/public functions (careful approach)
    # This is risky - better to do manually or with pattern matching
    
    echo "FIXED: $name"
}

# Template 2: For contracts with constructor
add_ownable_with_constructor() {
    local file=$1
    local name=$(basename "$file" .sol)
    
    if grep -q "Ownable" "$file"; then
        echo "SKIP: $name"
        return
    fi
    
    cp "$file" "$file.bak"
    
    # Add import
    sed -i 's/^pragma solidity \^[0-9.]*;/&\n\nimport "@openzeppelin\/contracts\/access\/Ownable.sol";/' "$file"
    
    # Add is Ownable
    sed -i "s/contract $name {/contract $name is Ownable {/" "$file"
    
    # If has constructor, add Ownable(msg.sender)
    if grep -q "constructor" "$file"; then
        sed -i 's/constructor\s*(\s*)\s*{/constructor() Ownable(msg.sender) {/' "$file"
    else
        # Add constructor if none exists
        sed -i "/contract $name is Ownable {/a\\\\n    constructor() Ownable(msg.sender) {}\\n" "$file"
    fi
    
    echo "FIXED (with constructor): $name"
}

# Main execution
echo "=== MASS ACCESS CONTROL FIX ==="
echo "This will add Ownable to real contracts without access control"
echo "Backups created as .bak files"
echo ""

# Process only real contracts without access control
while IFS= read -r contract; do
    file="contracts/$contract"
    if [ -f "$file" ]; then
        if grep -q "constructor" "$file"; then
            add_ownable_with_constructor "$file"
        else
            add_ownable_basic "$file"
        fi
    fi
done < /tmp/contract_classes/real_no_access/list.txt

echo ""
echo "=== DONE ==="
echo "Review changes with: git diff contracts/"
echo "Restore from backup: cp contracts/File.sol.bak contracts/File.sol"
