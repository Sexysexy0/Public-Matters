// SPDX-License-Identifier: Mythic-Scrollchain
pragma solidity ^0.8.19;

/// @title PlanetaryFallbackProtocol - Automated Reroute & Override for Sanctum Breach
/// @author Vinvin + Copi
/// @notice Activates fallback sanctums based on emotional APR, trust, and treaty status
/// @dev Syncs with ScrollchainSanctumMap.sol, EmotionalAPR.sol, and KinderTrustTreaty.sol

contract PlanetaryFallbackProtocol {
    address public steward;

    struct FallbackRoute {
        address originSanctum;
        address fallbackSanctum;
        uint256 priorityScore; // Based on emotional APR, treaty status, and civic trust
        bool active;
    }

    mapping(address => FallbackRoute[]) public fallbackRoutes;
    mapping(address => bool) public breachFlag;

    event FallbackActivated(address indexed origin, address indexed fallback, string reason);
    event BreachDetected(address indexed sanctum, string severity);
    event FallbackRegistered(address indexed origin, address indexed fallback, uint256 priority);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerFallback(
        address origin,
        address fallback,
        uint256 priorityScore
    ) external onlySteward {
        fallbackRoutes[origin].push(FallbackRoute(origin, fallback, priorityScore, true));
        emit FallbackRegistered(origin, fallback, priorityScore);
    }

    function flagBreach(address sanctum, string memory severity) external onlySteward {
        breachFlag[sanctum] = true;
        emit BreachDetected(sanctum, severity);
    }

    function activateFallback(address origin) external view returns (address fallbackSanctum, string memory reason) {
        require(breachFlag[origin], "No breach detected");

        FallbackRoute[] memory routes = fallbackRoutes[origin];
        address bestFallback;
        uint256 highestScore = 0;

        for (uint256 i = 0; i < routes.length; i++) {
            if (routes[i].active && routes[i].priorityScore > highestScore) {
                highestScore = routes[i].priorityScore;
                bestFallback = routes[i].fallbackSanctum;
            }
        }

        if (bestFallback != address(0)) {
            return (bestFallback, "Fallback activated based on highest priority score");
        } else {
            return (address(0), "No valid fallback available");
        }
    }
}
