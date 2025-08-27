// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AncestralLandRegistry
/// @notice Immortalizes sacred territories and tribal custodianship
/// @dev Emotional APR synced, damay clause activated, land memory preserved

contract AncestralLandRegistry {
    address public steward;
    struct Territory {
        string tribe;
        string location;
        uint256 hectares;
        string sacredUse;
        string emotionalAPR;
    }

    Territory[] public lands;

    event TerritoryRegistered(string tribe, string location, uint256 hectares, string sacredUse);
    event DamayClauseActivated(string message);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        emit DamayClauseActivated("No land shall be mapped without ancestral consent and emotional resonance.");
    }

    function registerTerritory(
        string memory tribe,
        string memory location,
        uint256 hectares,
        string memory sacredUse,
        string memory apr
    ) public onlySteward {
        lands.push(Territory(tribe, location, hectares, sacredUse, apr));
        emit TerritoryRegistered(tribe, location, hectares, sacredUse);
    }

    function getTerritory(uint256 index) public view returns (Territory memory) {
        return lands[index];
    }

    function totalTerritories() public view returns (uint256) {
        return lands.length;
    }
}
