// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SovereigntyShield
/// @notice Safeguard contract for personal sovereignty in a centralized world
/// @dev Encodes principles of family-centered businesses, uncapturable assets, and truthfulness

contract SovereigntyShield {
    address public guardian;
    uint256 public principleCount;

    struct Principle {
        uint256 id;
        string category;   // e.g., "Business", "Asset", "Truth"
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Principle) public principles;

    event PrincipleLogged(uint256 id, string category, string description, uint256 timestamp);
    event PrincipleCleared(uint256 id, uint256 timestamp);
    event SovereigntyAudit(string report, uint256 timestamp);

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    constructor(address _guardian) {
        guardian = _guardian;
        principleCount = 0;
    }

    /// @notice Log a new sovereignty principle
    function logPrinciple(string calldata category, string calldata description) external onlyGuardian {
        principleCount++;
        principles[principleCount] = Principle(principleCount, category, description, block.timestamp);
        emit PrincipleLogged(principleCount, category, description, block.timestamp);
    }

    /// @notice Clear a principle after resolution
    function clearPrinciple(uint256 id) external onlyGuardian {
        require(bytes(principles[id].description).length > 0, "Principle not found");
        delete principles[id];
        emit PrincipleCleared(id, block.timestamp);
    }

    /// @notice Log a sovereignty audit report
    function logAudit(string calldata report) external onlyGuardian {
        emit SovereigntyAudit(report, block.timestamp);
    }

    /// @notice Check if a principle exists
    function principleExists(uint256 id) external view returns (bool) {
        return bytes(principles[id].description).length > 0;
    }
}
