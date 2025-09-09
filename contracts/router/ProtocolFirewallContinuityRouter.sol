// SPDX-License-Identifier: ProtocolFirewallContinuity-License
pragma solidity ^0.8.0;

contract ProtocolFirewallContinuityRouter {
    address public steward;

    struct FirewallSignal {
        string protocol;
        bool continuityConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    FirewallSignal[] public signals;

    event FirewallContinuityRouted(string protocol, bool continuityConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeContinuity(string memory protocol, bool continuityConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(FirewallSignal(protocol, continuityConfirmed, clauseType, block.timestamp));
        emit FirewallContinuityRouted(protocol, continuityConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, bool, string memory, uint256) {
        FirewallSignal memory s = signals[index];
        return (s.protocol, s.continuityConfirmed, s.clauseType, s.timestamp);
    }
}
