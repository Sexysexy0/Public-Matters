// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BudgetOverrideProtocol {
    address public steward;
    mapping(string => uint256) public overrideAllocations;
    mapping(string => bool) public isOverridden;

    event OverrideCommitted(string sector, uint256 amount, string reason);
    event OverrideRevoked(string sector);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function commitOverride(string memory sector, uint256 amount, string memory reason) public onlySteward {
        overrideAllocations[sector] = amount;
        isOverridden[sector] = true;
        emit OverrideCommitted(sector, amount, reason);
    }

    function revokeOverride(string memory sector) public onlySteward {
        isOverridden[sector] = false;
        emit OverrideRevoked(sector);
    }

    function getOverride(string memory sector) public view returns (uint256 amount, bool active) {
        return (overrideAllocations[sector], isOverridden[sector]);
    }
}
