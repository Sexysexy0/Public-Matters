// contracts/CropCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CropCommons
 * @notice Logs communal crop production and equity in food systems.
 */
contract CropCommons {
    address public admin;

    struct Crop {
        string name;        // "Rice", "Corn", "Wheat"
        uint256 yield;      // in metric tons
        string status;      // "Harvested", "Pending", "Failed"
        uint256 timestamp;
    }

    Crop[] public crops;

    event CropLogged(string name, uint256 yield, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCrop(string calldata name, uint256 yield, string calldata status) external onlyAdmin {
        crops.push(Crop(name, yield, status, block.timestamp));
        emit CropLogged(name, yield, status, block.timestamp);
    }

    function totalCrops() external view returns (uint256) { return crops.length; }

    function getCrop(uint256 id) external view returns (Crop memory) {
        require(id < crops.length, "Invalid id");
        return crops[id];
    }
}
