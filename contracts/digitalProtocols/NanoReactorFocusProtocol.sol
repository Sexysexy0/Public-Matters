// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NanoReactorFocusProtocol {
    address public steward;
    string public coreInitiative = "Kronos Reactor Development";
    string[] public distractions;
    mapping(string => bool) public isSanctumAligned;

    event StrategyRefocused(string initiative);
    event DistractionFlagged(string venture);
    event SanctumAuditLogged(string venture, bool aligned);

    constructor() {
        steward = msg.sender;
        distractions = [
            "Fuel Consulting",
            "Transportation Ventures",
            "Ancillary Diversification"
        ];
        for (uint i = 0; i < distractions.length; i++) {
            isSanctumAligned[distractions[i]] = false;
            emit DistractionFlagged(distractions[i]);
        }
    }

    function refocusStrategy(string memory newInitiative) public {
        require(msg.sender == steward, "Only steward may refocus.");
        coreInitiative = newInitiative;
        emit StrategyRefocused(newInitiative);
    }

    function auditVenture(string memory venture, bool aligned) public {
        require(msg.sender == steward, "Only steward may audit.");
        isSanctumAligned[venture] = aligned;
        emit SanctumAuditLogged(venture, aligned);
    }

    function getCoreInitiative() public view returns (string memory) {
        return coreInitiative;
    }

    function isVentureAligned(string memory venture) public view returns (bool) {
        return isSanctumAligned[venture];
    }
}
