// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract PresidentialOverrideLedger {
    struct OverrideEvent {
        string president;
        string executiveOrder;
        string affectedDomain;
        string overrideReason;
        uint256 emotionalAPRImpact;
        string damayClause;
        uint256 timestamp;
        bool active;
    }

    OverrideEvent[] public overrideLog;

    event OverrideLogged(string president, string executiveOrder, string affectedDomain, uint256 emotionalAPRImpact);

    function logOverride(
        string memory _president,
        string memory _executiveOrder,
        string memory _affectedDomain,
        string memory _overrideReason,
        uint256 _emotionalAPRImpact,
        string memory _damayClause
    ) public {
        overrideLog.push(OverrideEvent(
            _president,
            _executiveOrder,
            _affectedDomain,
            _overrideReason,
            _emotionalAPRImpact,
            _damayClause,
            block.timestamp,
            true
        ));
        emit OverrideLogged(_president, _executiveOrder, _affectedDomain, _emotionalAPRImpact);
    }

    function getAllOverrides() public view returns (OverrideEvent[] memory) {
        return overrideLog;
    }
}
