// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Genesis
/// @notice Primordial creation and origin safeguard contract
contract CovenantGenesis {
    address public guardian;
    uint256 public genesisCount;

    struct Creation {
        uint256 id;
        string originName;
        string principle;
        string foundation;
        bool established;
    }

    mapping(uint256 => Creation) public creations;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CreationDeclared(uint256 indexed id, string originName, string principle);
    event CreationEstablished(uint256 indexed id, string foundation);

    constructor() {
        guardian = msg.sender;
        genesisCount = 0;
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

    /// @notice Mag‑declare ng primordial creation principle
    function declareCreation(string calldata originName, string calldata principle) external onlyGuardian {
        genesisCount++;
        creations[genesisCount] = Creation(genesisCount, originName, principle, "", false);
        emit CreationDeclared(genesisCount, originName, principle);
    }

    /// @notice Mag‑establish ng foundation para sa creation
    function establishCreation(uint256 id, string calldata foundation) external onlyGuardian {
        Creation storage c = creations[id];
        require(!c.established, "Already established");
        c.foundation = foundation;
        c.established = true;
        emit CreationEstablished(id, foundation);
    }

    /// @notice Tingnan ang creation details
    function viewCreation(uint256 id) external view returns (Creation memory) {
        return creations[id];
    }
}
