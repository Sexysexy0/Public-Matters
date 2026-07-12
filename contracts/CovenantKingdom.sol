// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Kingdom
/// @notice Sovereignty and dominion safeguard contract
contract CovenantKingdom {
    address public guardian;
    uint256 public kingdomCount;

    struct Dominion {
        uint256 id;
        string realm;
        string sovereigntyPrinciple;
        string rulershipPath;
        bool established;
    }

    mapping(uint256 => Dominion) public dominions;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event KingdomDeclared(uint256 indexed id, string realm, string sovereigntyPrinciple);
    event KingdomEstablished(uint256 indexed id, string rulershipPath);

    constructor() {
        guardian = msg.sender;
        kingdomCount = 0;
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

    /// @notice Mag‑declare ng kingdom sovereignty principle
    function declareKingdom(string calldata realm, string calldata sovereigntyPrinciple) external onlyGuardian {
        kingdomCount++;
        dominions[kingdomCount] = Dominion(kingdomCount, realm, sovereigntyPrinciple, "", false);
        emit KingdomDeclared(kingdomCount, realm, sovereigntyPrinciple);
    }

    /// @notice Mag‑establish ng kingdom rulership path
    function establishKingdom(uint256 id, string calldata rulershipPath) external onlyGuardian {
        Dominion storage d = dominions[id];
        require(!d.established, "Already established");
        d.rulershipPath = rulershipPath;
        d.established = true;
        emit KingdomEstablished(id, rulershipPath);
    }

    /// @notice Tingnan ang kingdom details
    function viewKingdom(uint256 id) external view returns (Dominion memory) {
        return dominions[id];
    }
}
