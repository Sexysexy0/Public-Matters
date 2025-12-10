// contracts/PlanetaryCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PlanetaryCommons
 * @notice Protocols for shared resources: water, air, forests, oceans.
 */
contract PlanetaryCommons {
    address public admin;

    struct Resource {
        string name;
        string status;   // e.g., "Stable", "Critical"
        string stewardshipNote;
        uint256 timestamp;
    }

    Resource[] public resources;

    event ResourceRegistered(string name, string status, string stewardshipNote, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerResource(string calldata name, string calldata status, string calldata stewardshipNote) external onlyAdmin {
        resources.push(Resource(name, status, stewardshipNote, block.timestamp));
        emit ResourceRegistered(name, status, stewardshipNote, block.timestamp);
    }

    function totalResources() external view returns (uint256) {
        return resources.length;
    }

    function getResource(uint256 id) external view returns (Resource memory) {
        require(id < resources.length, "Invalid id");
        return resources[id];
    }
}
