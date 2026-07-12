// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Enforcement
/// @notice Enforcement contract for charter rules and sanctions
contract CovenantEnforcement {
    address public guardian;
    uint256 public caseCount;

    struct Case {
        uint256 id;
        address violator;
        string violation;
        string sanction;
        bool enforced;
    }

    mapping(uint256 => Case) public cases;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CaseFiled(uint256 indexed id, address violator, string violation);
    event SanctionApplied(uint256 indexed id, string sanction);

    constructor() {
        guardian = msg.sender;
        caseCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Mag‑file ng violation case
    function fileCase(address violator, string calldata violation) external onlyGuardian {
        caseCount++;
        cases[caseCount] = Case(caseCount, violator, violation, "", false);
        emit CaseFiled(caseCount, violator, violation);
    }

    /// @notice Mag‑apply ng sanction sa case
    function applySanction(uint256 id, string calldata sanction) external onlyGuardian {
        Case storage c = cases[id];
        require(!c.enforced, "Already enforced");
        c.sanction = sanction;
        c.enforced = true;
        emit SanctionApplied(id, sanction);
    }

    /// @notice Tingnan ang case details
    function viewCase(uint256 id) external view returns (Case memory) {
        return cases[id];
    }
}
