// SPDX-License-Identifier: MIT
// Contract Name: IntegrityAnchorFramework
// Purpose: Safeguard core values against external pressure
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract IntegrityAnchorFramework {
    address public chiefOperator;
    uint256 public anchorCount;

    struct Anchor {
        string coreValue;
        uint256 timestamp;
        bool locked;
    }

    Anchor[] public anchors;

    event AnchorCreated(string coreValue, uint256 timestamp);
    event AnchorLocked(string coreValue, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        anchorCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Create new integrity anchor
    function createAnchor(string memory coreValue) public onlyChief {
        anchors.push(Anchor(coreValue, block.timestamp, false));
        anchorCount++;
        emit AnchorCreated(coreValue, block.timestamp);
    }

    // Lock anchor to prevent compromise
    function lockAnchor(uint256 index) public onlyChief {
        require(index < anchors.length, "Invalid anchor index");
        anchors[index].locked = true;
        emit AnchorLocked(anchors[index].coreValue, block.timestamp);
    }

    // View anchor details
    function getAnchor(uint256 index) public view returns (string memory, uint256, bool) {
        require(index < anchors.length, "Invalid anchor index");
        Anchor memory a = anchors[index];
        return (a.coreValue, a.timestamp, a.locked);
    }
}
