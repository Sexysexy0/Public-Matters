// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrossBorderEnforcementTreaty {
    address public steward;

    struct EnforcementClause {
        string jurisdiction;
        string enforcementAction;
        string crossBorderImpact;
        string emotionalTag;
    }

    EnforcementClause[] public treatyLog;

    event CrossBorderEnforcementTagged(string jurisdiction, string enforcementAction, string crossBorderImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagEnforcement(
        string memory jurisdiction,
        string memory enforcementAction,
        string memory crossBorderImpact,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(EnforcementClause(jurisdiction, enforcementAction, crossBorderImpact, emotionalTag));
        emit CrossBorderEnforcementTagged(jurisdiction, enforcementAction, crossBorderImpact, emotionalTag);
    }
}
