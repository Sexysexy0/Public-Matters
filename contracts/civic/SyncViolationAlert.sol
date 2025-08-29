// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract SyncViolationAlert {
    address public steward;

    struct Violation {
        string projectName;
        string contractor;
        bool govMissing;
        bool lguMissing;
        bool queenMissing;
        bool aprMissing;
        bool permitMissing;
        bool jailed;
        bool licenseRevoked;
        uint256 timestamp;
    }

    Violation[] public violations;

    event ViolationDetected(string projectName, string contractor);

    constructor() {
        steward = msg.sender;
    }

    function detectViolation(
        string memory projectName,
        string memory contractor,
        bool govMissing,
        bool lguMissing,
        bool queenMissing,
        bool aprMissing,
        bool permitMissing
    ) public {
        bool jailed = govMissing || lguMissing || queenMissing || aprMissing || permitMissing;
        bool licenseRevoked = jailed;

        violations.push(Violation(projectName, contractor, govMissing, lguMissing, queenMissing, aprMissing, permitMissing, jailed, licenseRevoked, block.timestamp));
        emit ViolationDetected(projectName, contractor);
    }

    function getViolation(uint256 index) public view returns (Violation memory) {
        return violations[index];
    }

    function totalViolations() public view returns (uint256) {
        return violations.length;
    }
}
