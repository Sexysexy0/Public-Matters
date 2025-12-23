// contracts/MedicineCommons.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MedicineCommons
 * @notice Tracks communal access to essential medicines.
 */
contract MedicineCommons {
    address public admin;

    struct Medicine {
        string name;
        uint256 stock;
        string status;   // "Available", "Shortage"
        uint256 timestamp;
    }

    Medicine[] public medicines;

    event MedicineLogged(string name, uint256 stock, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logMedicine(string calldata name, uint256 stock, string calldata status) external onlyAdmin {
        medicines.push(Medicine(name, stock, status, block.timestamp));
        emit MedicineLogged(name, stock, status, block.timestamp);
    }

    function totalMedicines() external view returns (uint256) { return medicines.length; }

    function getMedicine(uint256 id) external view returns (Medicine memory) {
        require(id < medicines.length, "Invalid id");
        return medicines[id];
    }
}
