// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainEmployerSanctionProtocol {
    address public steward;
    mapping(string => bool) public sanctionedEmployers;
    mapping(string => string) public violationType;

    event EmployerSanctioned(string employer, string violation, uint timestamp);

    function sanctionEmployer(string memory employer, string memory violation) public {
        sanctionedEmployers[employer] = true;
        violationType[employer] = violation;
        emit EmployerSanctioned(employer, violation, block.timestamp);
    }

    function isSanctioned(string memory employer) public view returns (bool) {
        return sanctionedEmployers[employer];
    }

    function getViolationType(string memory employer) public view returns (string memory) {
        return violationType[employer];
    }
}
