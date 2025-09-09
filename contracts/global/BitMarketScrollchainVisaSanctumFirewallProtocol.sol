// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainVisaSanctumFirewallProtocol {
    address public steward;
    mapping(string => bool) public flaggedEmployers;
    mapping(string => bool) public blockedVisas;

    event EmployerFlagged(string employer, string violationType, uint timestamp);
    event VisaBlocked(string visaType, string reason, uint timestamp);

    function flagEmployer(string memory employer, string memory violationType) public {
        flaggedEmployers[employer] = true;
        emit EmployerFlagged(employer, violationType, block.timestamp);
    }

    function blockVisa(string memory visaType, string memory reason) public {
        blockedVisas[visaType] = true;
        emit VisaBlocked(visaType, reason, block.timestamp);
    }

    function isEmployerFlagged(string memory employer) public view returns (bool) {
        return flaggedEmployers[employer];
    }

    function isVisaBlocked(string memory visaType) public view returns (bool) {
        return blockedVisas[visaType];
    }
}
