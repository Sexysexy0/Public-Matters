// contracts/SupplyAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SupplyAudit
 * @notice Tracks food supply chains and communal audit of distribution.
 */
contract SupplyAudit {
    address public admin;

    struct Supply {
        string source;      // "Farm", "Importer"
        string destination; // "Market", "Warehouse"
        uint256 volume;     // in metric tons
        string status;      // "Delivered", "Delayed"
        uint256 timestamp;
    }

    Supply[] public supplies;

    event SupplyLogged(string source, string destination, uint256 volume, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logSupply(string calldata source, string calldata destination, uint256 volume, string calldata status) external onlyAdmin {
        supplies.push(Supply(source, destination, volume, status, block.timestamp));
        emit SupplyLogged(source, destination, volume, status, block.timestamp);
    }

    function totalSupplies() external view returns (uint256) { return supplies.length; }

    function getSupply(uint256 id) external view returns (Supply memory) {
        require(id < supplies.length, "Invalid id");
        return supplies[id];
    }
}
