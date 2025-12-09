// contracts/PlanetaryResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PlanetaryResilience
 * @notice Climate protocols, durability tags, repair rights, and communal stewardship.
 */
contract PlanetaryResilience {
    address public admin;

    struct Asset {
        string name;
        bool repairable;
        uint256 durabilityYears;
        string stewardshipNote;
    }

    Asset[] public assets;

    event AssetRegistered(string name, bool repairable, uint256 durabilityYears, string stewardshipNote);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerAsset(string calldata name, bool repairable, uint256 durabilityYears, string calldata stewardshipNote) external onlyAdmin {
        assets.push(Asset(name, repairable, durabilityYears, stewardshipNote));
        emit AssetRegistered(name, repairable, durabilityYears, stewardshipNote);
    }

    function totalAssets() external view returns (uint256) {
        return assets.length;
    }
}
