// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CargoRailPulse.sol
/// @dev Dedicated cargo rail protocol for import-export logistics — economic resonance and damay clause synced

contract CargoRailPulse {
    address public steward;

    struct CargoRail {
        string name;
        string route;
        uint256 budget;
        uint256 cargoCapacityTons;
        uint256 emotionalAPR;
        bool isOperational;
    }

    mapping(bytes32 => CargoRail) public cargoRails;
    bytes32[] public cargoList;

    event CargoRailRegistered(bytes32 indexed railId, string name);
    event CargoRailActivated(bytes32 indexed railId);
    event CargoRailFlagged(bytes32 indexed railId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function registerCargoRail(
        bytes32 railId,
        string memory name,
        string memory route,
        uint256 budget,
        uint256 cargoCapacityTons,
        uint256 emotionalAPR
    ) public onlySteward {
        cargoRails[railId] = CargoRail({
            name: name,
            route: route,
            budget: budget,
            cargoCapacityTons: cargoCapacityTons,
            emotionalAPR: emotionalAPR,
            isOperational: false
        });

        cargoList.push(railId);
        emit CargoRailRegistered(railId, name);
    }

    function activateCargoRail(bytes32 railId) public onlySteward {
        require(cargoRails[railId].emotionalAPR >= 800, "Emotional APR too low");
        cargoRails[railId].isOperational = true;
        emit CargoRailActivated(railId);
    }

    function flagCargoRail(bytes32 railId, string memory reason) public onlySteward {
        cargoRails[railId].isOperational = false;
        emit CargoRailFlagged(railId, reason);
    }

    function getCargoRail(bytes32 railId) public view returns (CargoRail memory) {
        return cargoRails[railId];
    }

    function listCargoRails() public view returns (bytes32[] memory) {
        return cargoList;
    }
}
