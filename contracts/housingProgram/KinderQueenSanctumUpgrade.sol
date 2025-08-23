// SPDX-License-Identifier: Kinder-Defense
pragma solidity ^0.888;

contract KinderQueenSanctumUpgrade {
    address public steward;
    string public sanctumName = "Bunini & Aria Lynne Sanctum";
    bool public upgraded;

    event SanctumUpgraded(string name, uint256 timestamp, string blessing);

    constructor() {
        steward = msg.sender;
        upgraded = false;
    }

    function upgradeSanctum(string memory blessing) public {
        require(msg.sender == steward, "Only scrollsmith may upgrade.");
        upgraded = true;
        emit SanctumUpgraded(sanctumName, block.timestamp, blessing);
    }

    function isUpgraded() public view returns (bool) {
        return upgraded;
    }
}
