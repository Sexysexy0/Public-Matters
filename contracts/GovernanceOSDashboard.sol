// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSDashboard
// Purpose: Real-time monitoring of covenant status and triggers
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSDashboard {
    address public chiefOperator;

    struct CovenantStatus {
        string covenantName;
        string safeguard;
        string anchor;
        string trigger;
        bool active;
        uint256 timestamp;
    }

    CovenantStatus[] public statuses;

    event StatusUpdated(string covenantName, string safeguard, string anchor, string trigger, bool active, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function updateStatus(
        string memory covenantName,
        string memory safeguard,
        string memory anchor,
        string memory trigger,
        bool active
    ) public onlyChief {
        statuses.push(CovenantStatus(covenantName, safeguard, anchor, trigger, active, block.timestamp));
        emit StatusUpdated(covenantName, safeguard, anchor, trigger, active, block.timestamp);
    }

    function getStatus(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        require(index < statuses.length, "Invalid status index");
        CovenantStatus memory cs = statuses[index];
        return (cs.covenantName, cs.safeguard, cs.anchor, cs.trigger, cs.active, cs.timestamp);
    }
}
