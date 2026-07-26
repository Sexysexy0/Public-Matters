#!/bin/bash
# save as: safe_mass_fix.sh

FIXED=0
SKIPPED=0
FAILED=0

echo "=== SAFE MASS ACCESS CONTROL FIX ==="
echo "Processing 3,017 contracts..."
echo ""

while IFS= read -r contract; do
    file="contracts/$contract"
    name=$(basename "$contract" .sol)
    
    # Skip if backup exists (already processed)
    if [ -f "$file.bak" ]; then
        echo "SKIP (already processed): $name"
        SKIPPED=$((SKIPPED+1))
        continue
    fi
    
    # Check if truly needs fix
    if grep -q "Ownable\|AccessControl\|onlyOwner\|onlyAdmin" "$file"; then
        echo "SKIP (has access control): $name"
        SKIPPED=$((SKIPPED+1))
        continue
    fi
    
    # Check if abstract/interface/library
    if grep -q "^abstract contract\|^interface\|^library" "$file"; then
        echo "SKIP (abstract/interface/library): $name"
        SKIPPED=$((SKIPPED+1))
        continue
    fi
    
    # Create backup
    cp "$file" "$file.bak"
    
    # Get pragma line
    pragma=$(grep "^pragma solidity" "$file" | head -1)
    
    # Check if has constructor
    has_constructor=$(grep -c "constructor" "$file" || echo 0)
    
    if [ "$has_constructor" -gt 0 ]; then
        # Template B: Has constructor
        # Add import after pragma
        sed -i 's/^pragma solidity \^[0-9.]*;/&\n\nimport "@openzeppelin\/contracts\/access\/Ownable.sol";/' "$file"
        
        # Add is Ownable to contract declaration
        sed -i "s/contract $name {/contract $name is Ownable {/" "$file"
        
        # Add Ownable(msg.sender) to constructor
        sed -i 's/constructor\s*(\s*)\s*{/constructor() Ownable(msg.sender) {/' "$file"
    else
        # Template A: No constructor
        # Add import after pragma
        sed -i 's/^pragma solidity \^[0-9.]*;/&\n\nimport "@openzeppelin\/contracts\/access\/Ownable.sol";/' "$file"
        
        # Add is Ownable to contract declaration
        sed -i "s/contract $name {/contract $name is Ownable {/" "$file"
        
        # Add constructor after contract declaration
        sed -i "/contract $name is Ownable {/a\\\\n    constructor() Ownable(msg.sender) {}\\n" "$file"
    fi
    
    echo "FIXED: $name"
    FIXED=$((FIXED+1))
    
    # Progress every 100
    if [ $((FIXED % 100)) -eq 0 ]; then
        echo "Progress: $FIXED fixed, $SKIPPED skipped, $FAILED failed"
    fi
    
done < /tmp/contract_classes/real_no_access/list.txt

echo ""
echo "=== SUMMARY ==="
echo "Fixed: $FIXED"
echo "Skipped: $SKIPPED"
echo "Failed: $FAILED"
echo ""
echo "Review changes: git diff --stat contracts/"
echo "Test: forge test"
echo "Restore all: for f in contracts/*.sol.bak; do cp \"$f\" \"${f%.bak}\"; done"
