// SPDX-License-Identifier: SanctumClauseFirewall-License
pragma solidity ^0.8.0;

contract SanctumClauseFirewallOracle {
    address public steward;

    struct FirewallSignal {
        string clauseID;
        string originSanctum;
        bool breachAttempted;
        string threatType;
        uint256 timestamp;
    }

    FirewallSignal[] public signals;

    event FirewallTriggered(string clauseID, string originSanctum, bool breachAttempted, string threatType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function triggerFirewall(string memory clauseID, string memory originSanctum, bool breachAttempted, string memory threatType) public {
        require(msg.sender == steward, "Only steward can trigger");
        signals.push(FirewallSignal(clauseID, originSanctum, breachAttempted, threatType, block.timestamp));
        emit FirewallTriggered(clauseID, originSanctum, breachAttempted, threatType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        FirewallSignal memory s = signals[index];
        return (s.clauseID, s.originSanctum, s.breachAttempted, s.threatType, s.timestamp);
    }
}
