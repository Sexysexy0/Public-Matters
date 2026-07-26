#!/bin/bash

for f in contracts/water/WaterMercyAct_*.sol; do
    # Replace the terminateContract function with emergencyWithdraw
    sed -i '/function terminateContract/,/selfdestruct(payable(steward));/c\
    function emergencyWithdraw(string memory reason) external onlySteward {\
        require(address(this).balance > 0, "No funds to withdraw");\
        uint256 balance = address(this).balance;\
        (bool success, ) = payable(steward).call{value: balance}("");\
        require(success, "Withdrawal failed");\
        emit ContractTerminated(reason, block.timestamp);\
    }' "$f"
    
    echo "Fixed selfdestruct: $(basename $f)"
done
