// SPDX-License-Identifier: SecurityBreachAudit-License
pragma solidity ^0.8.0;

contract SecurityBreachAuditOracle {
    address public steward;

    struct BreachSignal {
        string protocol;
        string asset;
        bool breachConfirmed;
        string severity;
        uint256 timestamp;
    }

    BreachSignal[] public signals;

    event BreachAuditEmitted(string protocol, string asset, bool breachConfirmed, string severity, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitAudit(string memory protocol, string memory asset, bool breachConfirmed, string memory severity) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(BreachSignal(protocol, asset, breachConfirmed, severity, block.timestamp));
        emit BreachAuditEmitted(protocol, asset, breachConfirmed, severity, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        BreachSignal memory s = signals[index];
        return (s.protocol, s.asset, s.breachConfirmed, s.severity, s.timestamp);
    }
}
