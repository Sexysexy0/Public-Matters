// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Empire
/// @notice Expansionist and multi-realm dominion safeguard contract
contract CovenantEmpire {
    address public guardian;
    uint256 public empireCount;

    struct Expansion {
        uint256 id;
        string realm;
        string dominionPrinciple;
        string integrationPath;
        bool consolidated;
    }

    mapping(uint256 => Expansion) public expansions;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event EmpireDeclared(uint256 indexed id, string realm, string dominionPrinciple);
    event EmpireConsolidated(uint256 indexed id, string integrationPath);

    constructor() {
        guardian = msg.sender;
        empireCount = 0;
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

    /// @notice Mag‑declare ng empire dominion principle
    function declareEmpire(string calldata realm, string calldata dominionPrinciple) external onlyGuardian {
        empireCount++;
        expansions[empireCount] = Expansion(empireCount, realm, dominionPrinciple, "", false);
        emit EmpireDeclared(empireCount, realm, dominionPrinciple);
    }

    /// @notice Mag‑consolidate ng empire at mag‑assign ng integration path
    function consolidateEmpire(uint256 id, string calldata integrationPath) external onlyGuardian {
        Expansion storage e = expansions[id];
        require(!e.consolidated, "Already consolidated");
        e.integrationPath = integrationPath;
        e.consolidated = true;
        emit EmpireConsolidated(id, integrationPath);
    }

    /// @notice Tingnan ang empire details
    function viewEmpire(uint256 id) external view returns (Expansion memory) {
        return expansions[id];
    }
}
