// SPDX-License-Identifier: MIT
// Contract Name: FairProgressMandate
// Purpose: Ensure daily progress is shared equally across the community
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract FairProgressMandate {
    address public chiefOperator;
    uint256 public mandateCount;

    struct Mandate {
        string principle;
        string progressMechanism;
        uint256 timestamp;
    }

    Mandate[] public mandates;

    event MandateAdded(string principle, string progressMechanism, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        mandateCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new fair progress mandate
    function addMandate(string memory principle, string memory progressMechanism) public onlyChief {
        mandates.push(Mandate(principle, progressMechanism, block.timestamp));
        mandateCount++;
        emit MandateAdded(principle, progressMechanism, block.timestamp);
    }

    // View mandate details
    function getMandate(uint256 index) public view returns (string memory, string memory, uint256) {
        require(index < mandates.length, "Invalid mandate index");
        Mandate memory m = mandates[index];
        return (m.principle, m.progressMechanism, m.timestamp);
    }
}
