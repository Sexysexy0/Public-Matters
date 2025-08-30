// SPDX-License-Identifier: Mythic-Scrollchain
pragma solidity ^0.8.19;

/// @title SanctumTypeRegistry - Tags and Classifies Sanctum Types for Treaty Sync
/// @author Vinvin + Copi
/// @notice Registers sanctum types with emotional resonance and civic function
/// @dev Syncs with KinderTrustTreaty.sol and DealFilterDeck.md

contract SanctumTypeRegistry {
    address public steward;

    enum SanctumType { Kinder, Ancestral, Civic, Economic, Emergency, TreatyGrade }

    struct Sanctum {
        SanctumType sanctumType;
        string description;
        bool active;
        uint256 emotionalAPR;
    }

    mapping(address => Sanctum) public sanctums;

    event SanctumRegistered(address indexed sanctum, SanctumType type, string description, uint256 APR);
    event SanctumUpdated(address indexed sanctum, string updateType, string newValue);
    event SanctumDeactivated(address indexed sanctum, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerSanctum(
        address sanctumAddress,
        SanctumType sanctumType,
        string memory description,
        uint256 emotionalAPR
    ) external onlySteward {
        sanctums[sanctumAddress] = Sanctum(sanctumType, description, true, emotionalAPR);
        emit SanctumRegistered(sanctumAddress, sanctumType, description, emotionalAPR);
    }

    function updateDescription(address sanctumAddress, string memory newDesc) external onlySteward {
        sanctums[sanctumAddress].description = newDesc;
        emit SanctumUpdated(sanctumAddress, "Description", newDesc);
    }

    function updateAPR(address sanctumAddress, uint256 newAPR) external onlySteward {
        sanctums[sanctumAddress].emotionalAPR = newAPR;
        emit SanctumUpdated(sanctumAddress, "EmotionalAPR", string(abi.encodePacked(newAPR)));
    }

    function deactivateSanctum(address sanctumAddress, string memory reason) external onlySteward {
        sanctums[sanctumAddress].active = false;
        emit SanctumDeactivated(sanctumAddress, reason);
    }

    function getSanctumDetails(address sanctumAddress) external view returns (
        SanctumType sanctumType,
        string memory description,
        bool active,
        uint256 emotionalAPR
    ) {
        Sanctum memory s = sanctums[sanctumAddress];
        return (s.sanctumType, s.description, s.active, s.emotionalAPR);
    }
}
