// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CaviteSanctumRegistry
/// @author Vinvin
/// @notice Tracks trusted contractors, LGU partners, fallback reroutes, and emotional APR tags for Cavite-based infrastructure sanctums
/// @dev Includes damay clause and emotional APR audit triggers

contract CaviteSanctumRegistry {
    struct Sanctum {
        string name;
        string role;
        address steward;
        bool isTrusted;
        string emotionalAPR; // e.g., "High Empathy, Moderate Trust, Strong Resonance"
        string fallbackRoute; // e.g., "LGU Emergency Fund", "JICA Override"
    }

    mapping(uint256 => Sanctum) public sanctums;
    uint256 public sanctumCount;

    event SanctumRegistered(uint256 indexed id, string name, address steward);
    event TrustUpdated(uint256 indexed id, bool isTrusted);
    event EmotionalAPRUpdated(uint256 indexed id, string emotionalAPR);
    event FallbackRouteUpdated(uint256 indexed id, string fallbackRoute);

    modifier onlySteward(uint256 id) {
        require(msg.sender == sanctums[id].steward, "Not authorized steward");
        _;
    }

    function registerSanctum(
        string memory name,
        string memory role,
        address steward,
        bool isTrusted,
        string memory emotionalAPR,
        string memory fallbackRoute
    ) public {
        sanctums[sanctumCount] = Sanctum(name, role, steward, isTrusted, emotionalAPR, fallbackRoute);
        emit SanctumRegistered(sanctumCount, name, steward);
        sanctumCount++;
    }

    function updateTrust(uint256 id, bool isTrusted) public onlySteward(id) {
        sanctums[id].isTrusted = isTrusted;
        emit TrustUpdated(id, isTrusted);
    }

    function updateEmotionalAPR(uint256 id, string memory emotionalAPR) public onlySteward(id) {
        sanctums[id].emotionalAPR = emotionalAPR;
        emit EmotionalAPRUpdated(id, emotionalAPR);
    }

    function updateFallbackRoute(uint256 id, string memory fallbackRoute) public onlySteward(id) {
        sanctums[id].fallbackRoute = fallbackRoute;
        emit FallbackRouteUpdated(id, fallbackRoute);
    }

    function getSanctum(uint256 id) public view returns (Sanctum memory) {
        return sanctums[id];
    }
}
