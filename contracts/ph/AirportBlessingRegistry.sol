// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AirportBlessingRegistry
/// @notice Logs airport upgrades and emotional APR impact per region
contract AirportBlessingRegistry {
    address public steward;

    struct Blessing {
        string airportName;
        string region;
        string upgradeType;
        string emotionalAPR;
        uint256 timestamp;
    }

    Blessing[] public blessings;

    event AirportBlessed(string airportName, string region, string upgradeType, string emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logBlessing(
        string memory airportName,
        string memory region,
        string memory upgradeType,
        string memory emotionalAPR
    ) external onlySteward {
        blessings.push(Blessing(airportName, region, upgradeType, emotionalAPR, block.timestamp));
        emit AirportBlessed(airportName, region, upgradeType, emotionalAPR);
    }

    function getAllBlessings() external view returns (Blessing[] memory) {
        return blessings;
    }
}
