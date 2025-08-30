// SPDX-License-Identifier: Mythic-Scrollchain
pragma solidity ^0.8.19;

/// @title ScrollchainSanctumMap - Visual Map of Sanctum Clusters & Emotional Zones
/// @author Vinvin + Copi
/// @notice Registers sanctum coordinates, fallback paths, and emotional APR zones
/// @dev Syncs with SanctumTypeRegistry.sol, KinderTrustTreaty.sol, and EmotionalAPR.sol

contract ScrollchainSanctumMap {
    address public steward;

    struct SanctumNode {
        string name;
        string region;
        uint256 latitude;
        uint256 longitude;
        uint256 emotionalAPR;
        bool active;
        string sanctumType;
    }

    mapping(address => SanctumNode) public sanctumMap;
    mapping(address => address[]) public fallbackPaths;

    event SanctumMapped(address indexed sanctum, string name, string region, string type, uint256 APR);
    event FallbackLinked(address indexed origin, address indexed fallback, string reason);
    event SanctumDeactivated(address indexed sanctum, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function mapSanctum(
        address sanctumAddress,
        string memory name,
        string memory region,
        uint256 latitude,
        uint256 longitude,
        uint256 emotionalAPR,
        string memory sanctumType
    ) external onlySteward {
        sanctumMap[sanctumAddress] = SanctumNode(name, region, latitude, longitude, emotionalAPR, true, sanctumType);
        emit SanctumMapped(sanctumAddress, name, region, sanctumType, emotionalAPR);
    }

    function linkFallback(address origin, address fallback, string memory reason) external onlySteward {
        fallbackPaths[origin].push(fallback);
        emit FallbackLinked(origin, fallback, reason);
    }

    function deactivateSanctum(address sanctumAddress, string memory reason) external onlySteward {
        sanctumMap[sanctumAddress].active = false;
        emit SanctumDeactivated(sanctumAddress, reason);
    }

    function getSanctumDetails(address sanctumAddress) external view returns (
        string memory name,
        string memory region,
        uint256 latitude,
        uint256 longitude,
        uint256 emotionalAPR,
        bool active,
        string memory sanctumType
    ) {
        SanctumNode memory node = sanctumMap[sanctumAddress];
        return (node.name, node.region, node.latitude, node.longitude, node.emotionalAPR, node.active, node.sanctumType);
    }

    function getFallbacks(address origin) external view returns (address[] memory) {
        return fallbackPaths[origin];
    }
}
