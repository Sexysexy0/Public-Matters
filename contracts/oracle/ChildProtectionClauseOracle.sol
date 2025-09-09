// SPDX-License-Identifier: ChildProtectionClause-License
pragma solidity ^0.8.0;

contract ChildProtectionClauseOracle {
    address public steward;

    struct ProtectionSignal {
        string clauseID;
        string originEntity;
        bool clauseActivated;
        string breachType;
        uint256 timestamp;
    }

    ProtectionSignal[] public signals;

    event ProtectionEmitted(string clauseID, string originEntity, bool clauseActivated, string breachType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitProtection(string memory clauseID, string memory originEntity, bool clauseActivated, string memory breachType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(ProtectionSignal(clauseID, originEntity, clauseActivated, breachType, block.timestamp));
        emit ProtectionEmitted(clauseID, originEntity, clauseActivated, breachType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        ProtectionSignal memory s = signals[index];
        return (s.clauseID, s.originEntity, s.clauseActivated, s.breachType, s.timestamp);
    }
}
