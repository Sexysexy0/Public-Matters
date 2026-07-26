#!/bin/bash
# save as: classify_contracts.sh

mkdir -p /tmp/contract_classes
mkdir -p /tmp/contract_classes/empty
mkdir -p /tmp/contract_classes/interface
mkdir -p /tmp/contract_classes/library
mkdir -p /tmp/contract_classes/real_no_access
mkdir -p /tmp/contract_classes/has_access

echo "Classifying contracts..."

for f in contracts/*.sol; do
    lines=$(wc -l < "$f")
    name=$(basename "$f")
    
    if [ "$lines" -lt 10 ]; then
        echo "$name" >> /tmp/contract_classes/empty/list.txt
    elif grep -q "^interface " "$f"; then
        echo "$name" >> /tmp/contract_classes/interface/list.txt
    elif grep -q "^library " "$f"; then
        echo "$name" >> /tmp/contract_classes/library/list.txt
    elif grep -q "only\|require.*msg.sender\|Ownable\|AccessControl" "$f"; then
        echo "$name" >> /tmp/contract_classes/has_access/list.txt
    else
        echo "$name" >> /tmp/contract_classes/real_no_access/list.txt
    fi
done

echo "=== CLASSIFICATION RESULTS ==="
echo "Empty shells: $(wc -l < /tmp/contract_classes/empty/list.txt 2>/dev/null || echo 0)"
echo "Interfaces: $(wc -l < /tmp/contract_classes/interface/list.txt 2>/dev/null || echo 0)"
echo "Libraries: $(wc -l < /tmp/contract_classes/library/list.txt 2>/dev/null || echo 0)"
echo "Has access control: $(wc -l < /tmp/contract_classes/has_access/list.txt 2>/dev/null || echo 0)"
echo "NEEDS FIX (real contracts, no access): $(wc -l < /tmp/contract_classes/real_no_access/list.txt 2>/dev/null || echo 0)"
