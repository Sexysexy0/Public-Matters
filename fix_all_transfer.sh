#!/bin/bash

# Fix pattern: payable(x).transfer(y) → (bool success, ) = payable(x).call{value: y}(""); require(success, "...")
for f in $(grep -rl "\.transfer(" contracts/ --include="*.sol" | grep -v WaterMercyAct); do
    # Pattern 1: payable(something).transfer(amount)
    sed -i 's/payable(\([^)]*\))\.transfer(\([^)]*\));/(bool success, ) = payable(\1).call{value: \2}(""); require(success, "Transfer failed");/g' "$f"
    
    # Pattern 2: address.transfer(amount) or similar
    sed -i 's/\([^)]*\)\.transfer(\([^)]*\));/(bool success, ) = payable(\1).call{value: \2}(""); require(success, "Transfer failed");/g' "$f"
    
    echo "Fixed: $f"
done
