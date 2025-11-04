// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StablecoinDepegTreaty {
    address public steward;

    struct DepegClause {
        string stablecoinName;
        string depegTrigger;
        string recoveryPlan;
        string emotionalTag;
    }

    DepegClause[] public treatyLog;

    event StablecoinDepegTagged(string stablecoinName, string depegTrigger, string recoveryPlan, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagDepeg(
        string memory stablecoinName,
        string memory depegTrigger,
        string memory recoveryPlan,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(DepegClause(stablecoinName, depegTrigger, recoveryPlan, emotionalTag));
        emit StablecoinDepegTagged(stablecoinName, depegTrigger, recoveryPlan, emotionalTag);
    }
}
