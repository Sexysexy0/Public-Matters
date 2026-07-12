// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Legacy
/// @notice Intergenerational transfer and preservation contract
contract CovenantLegacy {
    address public guardian;
    uint256 public legacyCount;

    struct Legacy {
        uint256 id;
        string covenantName;
        string valuePreserved;
        string successor;
        bool transferred;
    }

    mapping(uint256 => Legacy) public legacies;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event LegacyDeclared(uint256 indexed id, string covenantName, string valuePreserved);
    event LegacyTransferred(uint256 indexed id, string successor);

    constructor() {
        guardian = msg.sender;
        legacyCount = 0;
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

    /// @notice Mag‑declare ng legacy value
    function declareLegacy(string calldata covenantName, string calldata valuePreserved) external onlyGuardian {
        legacyCount++;
        legacies[legacyCount] = Legacy(legacyCount, covenantName, valuePreserved, "", false);
        emit LegacyDeclared(legacyCount, covenantName, valuePreserved);
    }

    /// @notice Mag‑transfer ng legacy sa successor
    function transferLegacy(uint256 id, string calldata successor) external onlyGuardian {
        Legacy storage l = legacies[id];
        require(!l.transferred, "Already transferred");
        l.successor = successor;
        l.transferred = true;
        emit LegacyTransferred(id, successor);
    }

    /// @notice Tingnan ang legacy details
    function viewLegacy(uint256 id) external view returns (Legacy memory) {
        return legacies[id];
    }
}
