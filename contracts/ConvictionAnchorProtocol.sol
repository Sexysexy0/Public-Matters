// SPDX-License-Identifier: MIT
// Contract Name: ConvictionAnchorProtocol
// Purpose: Preserve inner conviction against external pressures
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract ConvictionAnchorProtocol {
    address public chiefOperator;
    uint256 public anchorCount;

    struct Anchor {
        string principle;
        string anchorMechanism;
        uint256 timestamp;
    }

    Anchor[] public anchors;

    event AnchorAdded(string principle, string anchorMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        anchorCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new conviction anchor
    function addAnchor(string memory principle, string memory anchorMechanism) public onlyChief {
        anchors.push(Anchor(principle, anchorMechanism, block.timestamp));
        anchorCount++;
        emit AnchorAdded(principle, anchorMechanism, block.timestamp);
    }

    // View anchor details
    function getAnchor(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < anchors.length, "Invalid anchor index");
        Anchor memory a = anchors[index];
        return (a.principle, a.anchorMechanism, a.timestamp);
    }
}
