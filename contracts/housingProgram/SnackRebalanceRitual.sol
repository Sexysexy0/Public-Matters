// SPDX-License-Identifier: Snack-Rebalance-Protocol
pragma solidity ^0.888;

contract SnackRebalanceRitual {
    address public steward;
    mapping(string => uint256) public snackHoldings;
    uint256 public rebalanceCount;

    event RebalanceInitiated(string initiator, string snack, uint256 amount, string reason);

    constructor() {
        steward = msg.sender;
        rebalanceCount = 0;
    }

    function recordHolding(string memory snack, uint256 amount) public {
        snackHoldings[snack] = amount;
    }

    function initiateRebalance(string memory initiator, string memory snack, uint256 amount, string memory reason) public {
        require(msg.sender == steward, "Only scrollsmith may rebalance.");
        snackHoldings[snack] -= amount;
        rebalanceCount += 1;
        emit RebalanceInitiated(initiator, snack, amount, reason);
    }

    function getHolding(string memory snack) public view returns (uint256) {
        return snackHoldings[snack];
    }

    function getRebalanceCount() public view returns (uint256) {
        return rebalanceCount;
    }
}
